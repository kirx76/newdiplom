import json
import random
import tornado.ioloop
import tornado.web
import os
import connections
import hashlib
import tornado.websocket
import requests
import transliterate
from jinja2 import Environment, FileSystemLoader

env = Environment(loader=FileSystemLoader('templates'))

settings = {
    "cookie_secret": "61oETzKXQAGaYdk333EmGeJfdfdh12345ddsa2JFuYh7EQnp2XdTP1o/Vo=",
    "login_url": "/login",
}


def listToDict(lst):
    op = {i: lst[i] for i in range(0, len(lst))}
    return op


def get_user_info(phone):
    connect = connections.getConnection()
    try:
        with connect.cursor() as cursor:
            sql = """
            SELECT users.id, user_name, user_img, user_phone, user_password, access_name, access_list.id as al_id
            FROM users 
            JOIN users_accesses ON users.id = users_accesses.user_id 
            JOIN access_list ON users_accesses.access_id = access_list.id 
            WHERE users.user_phone = %s;"""
            cursor.execute(sql, (phone))
        user = cursor.fetchone()
    except:
        return None
    finally:
        connect.close()
    return user


class BaseHandler(tornado.web.RequestHandler):
    def prepare(self):
        self.clear_header('Server')

    def get_current_user(self):
        return self.get_secure_cookie("user")


class LoginHandler(tornado.web.RequestHandler):
    def get(self):
        self.write('123')


class MainHandler(tornado.web.RequestHandler):
    def get(self):
        connect = connections.getConnection()
        cursor = connect.cursor()
        cursor.execute(f"select * from dish_types")
        dish_types = cursor.fetchall()
        usr = self.get_secure_cookie("user")
        if usr is not None:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        else:
            user_info = None
        template = env.get_template('index.html')
        self.write(template.render(dish_types=dish_types, user_info=user_info))


class DishTypesHandler(tornado.web.RequestHandler):
    def prepare(self):
        if 'None' in self.request.path:
            raise tornado.web.HTTPError(
                status_code=404,
                reason="Invalid resource path."
            )

    def get(self, args):
        connect = connections.getConnection()
        cursor = connect.cursor()
        cursor.execute(f'select * from dish_types where dish_type_translit = "{args}"')
        type_id = int(cursor.fetchone()['id'])
        cursor.execute(f'select * from dishs where dish_type_id = {type_id}')
        dishs = cursor.fetchall()

        template = env.get_template('dishs.html')
        usr = self.get_secure_cookie("user")
        if usr is not None:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        else:
            user_info = None

        try:
            with connect.cursor() as cursor:
                sql = """
                SELECT * FROM users 
                JOIN user_orders ON users.id = user_orders.user_id 
                JOIN orders ON user_orders.order_id = orders.id 
                JOIN dishes_in_order ON orders.id = dishes_in_order.order_id 
                WHERE users.user_phone = %s AND orders.order_status = 0;
                """
                cursor.execute(sql, (user_info['user_phone']))
                dish_count = cursor.fetchall()
        except Exception as e:
            dish_count = None
        finally:
            connect.close()
        self.write(template.render(dishs=dishs, user_info=user_info, dish_count=dish_count))


class testhandler(tornado.web.RequestHandler):
    def get(self):
        connect = connections.getConnection()
        cursor = connect.cursor()
        cursor.execute(f'select * from dish_types where dish_type_translit = "Burgery"')
        type_id = int(cursor.fetchone()['id'])
        cursor.execute(f'select * from dishs where dish_type_id = {type_id}')
        dishs = cursor.fetchall()

        template = env.get_template('test.html')
        usr = self.get_secure_cookie("user")
        if usr is not None:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        else:
            user_info = None

        try:
            with connect.cursor() as cursor:
                sql = """
                SELECT * FROM users 
                JOIN user_orders ON users.id = user_orders.user_id 
                JOIN orders ON user_orders.order_id = orders.id 
                JOIN dishes_in_order ON orders.id = dishes_in_order.order_id 
                WHERE users.user_phone = %s AND orders.order_status = 0;
                """
                cursor.execute(sql, (user_info['user_phone']))
                dish_count = cursor.fetchall()
        except Exception as e:
            dish_count = None
        finally:
            connect.close()
        dicte = {'dishs': dishs, 'user_info': user_info, 'dish_count': dish_count}
        self.write(template.render(dicte=dicte, user_info=user_info))


class NotFoundHandler(tornado.web.RequestHandler):
    def prepare(self):  # for all methods
        self.redirect('/')
        raise tornado.web.HTTPError(
            status_code=404,
            reason="Invalid resource path."
        )


class UserProfile(BaseHandler):
    @tornado.web.authenticated
    def get(self, *args):
        print(self.request.body)
        usr = self.get_secure_cookie("user")
        if usr is not None:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        else:
            user_info = None
        user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        template = env.get_template('userinfo.html')
        self.write(template.render(user_info=user_info))


class testcoockie(tornado.web.RequestHandler):
    def get(self):
        self.set_secure_cookie('user', hashlib.md5(b'1234444321').hexdigest())


class removecockie(tornado.web.RequestHandler):
    def prepare(self):
        self.clear_all_cookies(path='/')
        self.redirect('/')

    def get(self):
        self.clear_all_cookies(path='/')
        self.redirect('/')


class registrationHandler(tornado.web.RequestHandler):
    def prepare(self):
        print(self.request.headers)

    def get(self):
        template = env.get_template('inputs/registration.html')
        self.write(template.render())

    def write_error(self, status_code: int, **kwargs):
        self.set_status(500)
        self.finish({"code": status_code, "message": kwargs})

    def post(self, *args):
        name = self.get_argument('name')
        phone = ''.join(x for x in self.get_argument('phone') if x.isdigit())[1:]
        password = self.get_argument('password')
        crypt_password = hashlib.md5(password.encode()).hexdigest()
        connect = connections.getConnection()
        cursor = connect.cursor()
        try:
            count = cursor.execute(f"select * from users where user_phone = {phone}")
        except:
            count = 1
        if count > 0:
            self.write_error(status_code=500, message='Данный пользователь уже зарегистрирован')
        else:
            try:
                with connect.cursor() as cursor:
                    adduser = "INSERT INTO `users` (`id`, `user_name`, `user_img`, `user_phone`, `user_password`) VALUES (0, %s, 'default.png', %s, %s)"
                    cursor.execute(adduser, (name, phone, crypt_password))
                    connect.commit()
                    newuser = cursor.lastrowid
                    adduser_role = "INSERT INTO `users_accesses` VALUES (%s, 1)"
                    cursor.execute(adduser_role, (newuser))
                    connect.commit()
                # self.set_secure_cookie('user', json.dumps({'user': name, 'secret': crypt_password}))
                self.set_secure_cookie('user', json.dumps(
                    {'user': name, 'secret': crypt_password,
                     'phone': phone}))
            except Exception as e:
                print(e)
                self.write_error(status_code=500, message='Неожиданная ошибка сервера')
            finally:
                connect.close()
            self.redirect('/')


class authHandler(tornado.web.RequestHandler):
    def write_error(self, status_code: int, **kwargs):
        self.set_status(500)
        self.finish({"code": status_code, "message": kwargs})

    def post(self):
        print(self.request.body)
        phone = ''.join(x for x in self.get_argument('phone') if x.isdigit())[1:]
        password = self.get_argument('password')
        crypt_password = hashlib.md5(password.encode()).hexdigest()
        connect = connections.getConnection()
        try:
            with connect.cursor() as cursor:
                sql = "SELECT * FROM users where user_phone = %s and user_password = %s"
                isactive = cursor.execute(sql, (phone, crypt_password))
                if isactive == 1:
                    user_info = cursor.fetchone()
                    self.set_secure_cookie('user', json.dumps(
                        {'user': user_info['user_name'], 'secret': user_info['user_password'],
                         'phone': user_info['user_phone']}))
                elif isactive == 0:
                    self.write_error(status_code=500, message='Данные пользователя неверны')
        except Exception as e:
            self.write_error(status_code=500, message=e)
        finally:
            connect.close()


class addDish(BaseHandler):
    def write_error(self, status_code: int, **kwargs):
        self.set_status(500)
        self.finish({"code": status_code, "message": kwargs})

    @tornado.web.authenticated
    def post(self, ):
        dish_id = self.get_argument('dish_id')
        status = int(self.get_argument('status'))
        user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        connect = connections.getConnection()
        try:
            with connect.cursor() as cursor:
                sql = """SELECT * FROM users 
                         JOIN user_orders ON users.id = user_orders.user_id 
                         JOIN orders ON user_orders.order_id = orders.id 
                         WHERE users.user_phone = %s AND order_status = 0;"""
                lastorder = int(cursor.execute(sql, (user_info['user_phone'])))
                last_order = cursor.fetchone()
                if lastorder == 1 and status == 1:
                    know = "SELECT * FROM dishes_in_order WHERE dish_id = %s and order_id = %s"
                    cursor.execute(know, (dish_id, last_order['order_id']))
                    try:
                        ishave = cursor.fetchone()['dish_count_in_order']
                    except:
                        ishave = 0
                    if ishave > 0:
                        add = "UPDATE dishes_in_order SET dish_count_in_order = dish_count_in_order + 1 WHERE dish_id = %s AND order_id = %s;"
                        cursor.execute(add, (dish_id, last_order['order_id']))
                        connect.commit()
                    else:
                        add = "INSERT INTO dishes_in_order VALUES (0, %s, %s, 1)"
                        cursor.execute(add, (dish_id, last_order['order_id']))
                        connect.commit()
                elif lastorder == 1 and status == 0:
                    know = "SELECT * FROM dishes_in_order WHERE dish_id = %s and order_id = %s"
                    ishave = cursor.execute(know, (dish_id, last_order['order_id']))
                    try:
                        counthave = cursor.fetchone()['dish_count_in_order']
                    except:
                        counthave = 1
                    if ishave == 1:
                        if counthave > 1:
                            remove = "UPDATE dishes_in_order SET dish_count_in_order = dish_count_in_order - 1 WHERE dish_id = %s AND order_id = %s;"
                            cursor.execute(remove, (dish_id, last_order['order_id']))
                            connect.commit()
                        else:
                            remove = "DELETE FROM dishes_in_order WHERE dish_id = %s AND order_id = %s;"
                            cursor.execute(remove, (dish_id, last_order['order_id']))
                            connect.commit()
                elif lastorder == 0:
                    ordertemplate = "INSERT INTO orders VALUES (0,NOW(),0,0,0,0);"
                    cursor.execute(ordertemplate)
                    connect.commit()
                    neworder = cursor.lastrowid
                    user_orders = "INSERT INTO user_orders VALUES (0, %s, %s);"
                    cursor.execute(user_orders, (neworder, user_info['id']))
                    connect.commit()

                    if status == 1:
                        know = "SELECT * FROM dishes_in_order WHERE dish_id = %s and order_id = %s"
                        cursor.execute(know, (dish_id, neworder))
                        try:
                            ishave = cursor.fetchone()['dish_count_in_order']
                        except:
                            ishave = 0
                        if ishave > 0:
                            add = "UPDATE dishes_in_order SET dish_count_in_order = dish_count_in_order + 1 WHERE dish_id = %s AND order_id = %s;"
                            cursor.execute(add, (dish_id, neworder))
                            connect.commit()
                        else:
                            add = "INSERT INTO dishes_in_order VALUES (0, %s, %s, 1)"
                            cursor.execute(add, (dish_id, neworder))
                            connect.commit()
                    else:
                        know = "SELECT * FROM dishes_in_order WHERE dish_id = %s and order_id = %s"
                        ishave = cursor.execute(know, (dish_id, neworder))
                        counthave = cursor.fetchone()['dish_count_in_order']
                        if ishave == 1:
                            if counthave > 1:
                                remove = "UPDATE dishes_in_order SET dish_count_in_order = dish_count_in_order - 1 WHERE dish_id = %s AND order_id = %s;"
                                cursor.execute(remove, (dish_id, neworder))
                                connect.commit()
                            else:
                                remove = "DELETE FROM dishes_in_order WHERE dish_id = %s AND order_id = %s;"
                                cursor.execute(remove, (dish_id, neworder))
                                connect.commit()

        except Exception as e:
            self.write_error(status_code=500, message=e)
        finally:
            connect.close()


class getUserBasket(BaseHandler):
    def write_error(self, status_code: int, **kwargs):
        self.set_status(500)
        self.finish({"code": status_code, "message": kwargs})

    @tornado.web.authenticated
    def post(self):
        print(self.request.body)
        phone = json.loads(self.get_secure_cookie("user").decode())['phone']
        user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        connect = connections.getConnection()
        try:
            with connect.cursor() as cursor:
                sql = """
                SELECT * FROM users 
                JOIN user_orders ON users.id = user_orders.user_id 
                JOIN orders ON user_orders.order_id = orders.id 
                JOIN dishes_in_order ON orders.id = dishes_in_order.order_id 
                JOIN dishs ON dishes_in_order.dish_id = dishs.id 
                WHERE users.user_phone = %s AND orders.order_status = 0;"""

                count = cursor.execute(sql, (phone))
                answer = cursor.fetchall()
                table = "SELECT * FROM tables"
                cursor.execute(table)
                tables = cursor.fetchall()
                if answer is None or answer == "" or count < 1:
                    self.write_error(500, message='Ваша корзина пуста')
                else:
                    # self.write(json.dumps(listToDict(answer), indent=4, sort_keys=True, default=str))
                    getallusers = "SELECT * FROM users"
                    cursor.execute(getallusers)
                    allusers = cursor.fetchall()
                    template = env.get_template('modals/basketmodal.html')
                    user_basket = {'dish_list': answer, 'tables': tables, 'user_info': user_info, 'allusers': allusers}
                    self.write(template.render(user_basket=user_basket))
        except Exception as e:
            print(e)
        finally:
            connect.close()


class payOrder(BaseHandler):
    def write_error(self, status_code: int, **kwargs):
        self.set_status(status_code)
        self.finish({"code": status_code, "message": kwargs})

    @tornado.web.authenticated
    def post(self):
        table_id = int(self.get_argument('table'))
        total_cost = int(self.get_argument('total_cost'))
        order_id = int(self.get_argument('order_id'))
        phone = json.loads(self.get_secure_cookie("user").decode())['phone']
        try:
            notuser_phone = self.get_argument('notuser_phone')
        except:
            notuser_phone = None
        connect = connections.getConnection()
        try:
            with connect.cursor() as cursor:
                check_total_cost = """
                SELECT * FROM users 
                JOIN user_orders ON users.id = user_orders.user_id 
                JOIN orders ON user_orders.order_id = orders.id 
                JOIN dishes_in_order ON orders.id = dishes_in_order.order_id 
                JOIN dishs ON dishes_in_order.dish_id = dishs.id 
                WHERE users.user_phone = %s AND orders.order_status = 0;"""

                cursor.execute(check_total_cost, (phone))
                check_total = cursor.fetchall()
                tot_cost = 0
                for item in check_total:
                    tot_cost += int(item['dish_price']) * int(item['dish_count_in_order'])
                if notuser_phone == "" or notuser_phone is None:
                    if tot_cost == total_cost:
                        update_order = """UPDATE orders set order_price = %s, order_status = 1, order_table = %s where orders.id = %s"""
                        cursor.execute(update_order, (tot_cost, table_id, order_id))
                        connect.commit()
                    else:
                        self.write_error(500, message='Не стоит менять цену заказа :)')
                else:
                    try:
                        chars = 'abcdefghijklnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
                        user_password = ''
                        for i in range(6):
                            user_password += random.choice(chars)
                        nowuser_password = hashlib.md5(user_password.encode()).hexdigest()
                        notuser_phone = ''.join(x for x in self.get_argument('notuser_phone') if x.isdigit())[1:]
                        notuser_name = self.get_argument('notuser_name')
                        createuser = """INSERT INTO users VALUES (0, %s, 'default.png', %s, %s)"""
                        cursor.execute(createuser, (notuser_name, notuser_phone, nowuser_password))
                        connect.commit()
                        newuser_id = cursor.lastrowid
                        adduser_role = "INSERT INTO `users_accesses` VALUES (%s, 1)"
                        cursor.execute(adduser_role, (newuser_id))
                        connect.commit()
                        message = f"FeedFood\nВаш пароль для входа на сайт: {user_password}"
                        req = requests.get(
                            f'https://smsc.ru/sys/send.php?login=ekirichenk8&psw=769323vS&phones=7{notuser_phone}&mes={message}')
                        changeordertouser = """UPDATE user_orders SET user_id = %s WHERE order_id = %s"""
                        cursor.execute(changeordertouser, (newuser_id, order_id))
                        connect.commit()
                        user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
                        order_executor_id = user_info['id']
                        update_order = """UPDATE orders set order_price = %s, order_status = 2, order_executor = %s, order_table = %s where orders.id = %s"""
                        cursor.execute(update_order, (tot_cost, order_executor_id, table_id, order_id))
                        connect.commit()

                    except Exception as e:
                        print(e)


        except Exception as e:
            print(e)
            self.write_error(500, message='Заказ не создан')

        finally:
            connect.close()
            self.write('Заказ успешно оплачен <a href="/">На главную</a>')


class clientOrdersHandler(BaseHandler):
    @tornado.web.authenticated
    def write_error(self, status_code: int, **kwargs):
        self.set_status(status_code)
        self.finish({"code": status_code, "message": kwargs})

    @tornado.web.authenticated
    def get(self, *args):
        connect = connections.getConnection()
        try:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
            with connect.cursor() as cursor:
                allorders = """SELECT * FROM orders 
                JOIN user_orders ON orders.id = user_orders.order_id 
                JOIN users ON user_orders.user_id = users.id 
                WHERE order_status = 1 order by orders.id DESC;"""
                cursor.execute(allorders)
                orders = cursor.fetchall()
                template = env.get_template('userorders.html')
                user_orders = {'orders': orders}
                self.write(template.render(user_orders=user_orders, user_info=user_info))
        finally:
            connect.close()

    @tornado.web.authenticated
    def post(self):
        order_id = int(self.get_argument('order_id'))
        executor_id = int(self.get_argument('executor_id'))
        status = int(self.get_argument('status'))

        connect = connections.getConnection()
        try:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
            with connect.cursor() as cursor:
                if status == 1:
                    updateorder = """UPDATE orders SET order_status = %s, order_executor = %s WHERE id = %s"""
                    cursor.execute(updateorder, (2, executor_id, order_id))
                    connect.commit()
                    self.write_error(status_code=200, message='Заказ успешно одобрен')
                elif status == 0:
                    updateorder = """UPDATE orders SET order_status = %s, order_executor = %s WHERE id = %s"""
                    cursor.execute(updateorder, (9, executor_id, order_id))
                    connect.commit()
                    self.write_error(status_code=500, message='Заказ перенесен в сомнительные')
                else:
                    self.write_error(status_code=500, message='Не удалось обработать запрос')
        except Exception as e:
            print(e)
            self.write_error(status_code=500, message='Непредвиденная ошибка')
        finally:
            connect.close()


class clientOrdersIdHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self, *args):
        connect = connections.getConnection()
        try:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
            with connect.cursor() as cursor:
                allorders = """SELECT * FROM orders 
                JOIN user_orders ON orders.id = user_orders.order_id 
                JOIN users ON user_orders.user_id = users.id 
                JOIN dishes_in_order ON orders.id = dishes_in_order.order_id 
                JOIN dishs ON dishes_in_order.dish_id = dishs.id 
                WHERE order_status = 1 and orders.id = %s"""
                cursor.execute(allorders, args[0])
                orders = cursor.fetchall()
                template = env.get_template('userordersinfo.html')
                user_orders = {'orders': orders}
                self.write(template.render(user_orders=user_orders, user_info=user_info))
        finally:
            connect.close()


class SimpleWebSocket(tornado.websocket.WebSocketHandler):
    connections = dict()

    def open(self):
        try:
            usr = self.get_secure_cookie("user")
            if usr is not None:
                user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
            else:
                user_info = None
            print('Создан пользователь')
            if user_info is not None:
                self.connections[int(user_info['id'])] = self
        except Exception as e:
            print(e)

    def on_message(self, message):
        target = json.loads(message)
        print(self.connections)
        print(target)
        connect = connections.getConnection()
        try:
            with connect.cursor() as cursor:
                getallexecutors = """SELECT users.id FROM users JOIN users_accesses ON users.id = users_accesses.user_id WHERE users_accesses.access_id = 2"""
                cursor.execute(getallexecutors)
                allexecutors = cursor.fetchall()
                try:
                    targ = target['for_executors']
                except:
                    targ = False
                if targ:
                    for executor in self.connections:
                        for ex in allexecutors:
                            if int(executor) == int(ex['id']):
                                self.connections.get(executor, '').write_message(str(target['message']))
                    # [self.connections.get(executor, '').write_message(str(target['message'])) for executor in self.connections]
                else:
                    try:
                        self.connections[int(target['user_id'])].write_message(str(target['message']))
                        # self.connections[int(target['sender_id'])].write_message('Пользователь оповещен о заказе')
                    except:
                        self.connections[int(target['sender_id'])].write_message(
                            'Пользователя нет на сайте, но мы оповестим его')
        except Exception as e:
            print(e)

        finally:
            connect.close()

    def on_close(self):
        print('closed')


class updateUserInfo(BaseHandler):
    def write_error(self, status_code: int, **kwargs):
        self.set_status(status_code)
        self.finish({"code": status_code, "message": kwargs})

    @tornado.web.authenticated
    def post(self, *args):
        user_name = self.get_argument('user_name')
        user_phone = ''.join(x for x in self.get_argument('user_phone') if x.isdigit())[1:]
        user_password = self.get_argument('user_password')
        user_id = int(self.get_argument('user_id'))
        connect = connections.getConnection()
        try:
            with connect.cursor() as cursor:
                getphone = "SELECT * FROM users where user_phone = %s"
                ishave = cursor.execute(getphone, (user_phone))
                if ishave == 0:
                    if user_password is None or user_password == "":
                        getuser = "SELECT * FROM users WHERE id = %s"
                        cursor.execute(getuser, (user_id))
                        user_password = str(cursor.fetchone()['user_password'])
                        updateprofile = """UPDATE users SET user_name = %s, user_phone = %s WHERE id = %s"""
                        cursor.execute(updateprofile, (user_name, user_phone, user_id))
                        connect.commit()
                        self.set_secure_cookie('user', json.dumps(
                            {'user': user_name, 'secret': user_password,
                             'phone': user_phone}))
                    else:
                        user_password = str(hashlib.md5(user_password.encode()).hexdigest())
                        updateprofile = """UPDATE users SET user_name = %s, user_phone = %s, user_password = %s WHERE id = %s"""
                        cursor.execute(updateprofile, (user_name, user_phone, user_password, user_id))
                        connect.commit()
                        self.set_secure_cookie('user', json.dumps(
                            {'user': user_name, 'secret': user_password,
                             'phone': user_phone}))
                    self.redirect('/')

                else:
                    checklastphone = """SELECT * FROM users WHERE id = %s"""
                    cursor.execute(checklastphone, (user_id))
                    last_phone = cursor.fetchone()['user_phone']
                    if last_phone == user_phone:
                        if user_password is None or user_password == "":
                            getuser = "SELECT * FROM users WHERE id = %s"
                            cursor.execute(getuser, (user_id))
                            user_password = str(cursor.fetchone()['user_password'])
                            updateprofile = """UPDATE users SET user_name = %s, user_phone = %s WHERE id = %s"""
                            cursor.execute(updateprofile, (user_name, user_phone, user_id))
                            connect.commit()
                            self.set_secure_cookie('user', json.dumps(
                                {'user': user_name, 'secret': user_password,
                                 'phone': user_phone}))
                        else:
                            user_password = str(hashlib.md5(user_password.encode()).hexdigest())
                            updateprofile = """UPDATE users SET user_name = %s, user_phone = %s, user_password = %s WHERE id = %s"""
                            cursor.execute(updateprofile, (user_name, user_phone, user_password, user_id))
                            connect.commit()
                            self.set_secure_cookie('user', json.dumps(
                                {'user': user_name, 'secret': user_password,
                                 'phone': user_phone}))
                        self.redirect('/')
                    else:
                        self.write_error(status_code=500, message='Такой номер телефона уже зарегестрирован ')
        except Exception as e:
            print(e)
        finally:
            connect.close()


class dishord(BaseHandler):
    def write_error(self, status_code: int, **kwargs):
        self.set_status(status_code)
        self.finish({"code": status_code, "message": kwargs})

    @tornado.web.authenticated
    def post(self):
        print(self.request.body)
        try:
            user_id = int(self.get_argument('user_id'))
        except:
            user_id = None
        dish_id = int(self.get_argument('dish_id'))
        usr = self.get_secure_cookie("user")
        if usr is not None:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        else:
            user_info = None
        connect = connections.getConnection()
        try:
            with connect.cursor() as cursor:
                getuserdish = """SELECT * FROM users 
                JOIN user_orders ON users.id = user_orders.user_id 
                JOIN orders ON user_orders.order_id = orders.id 
                JOIN dishes_in_order ON dishes_in_order.order_id = orders.id 
                JOIN dishs ON dishes_in_order.dish_id = dishs.id 
                WHERE users.id = %s
                AND dishs.id = %s 
                AND orders.order_status = 0;"""

                cursor.execute(getuserdish, (user_id, dish_id))
                dish_info = cursor.fetchone()
                getalldish = """SELECT * FROM dishs WHERE id = %s"""
                cursor.execute(getalldish, (dish_id))
                dish_info_total = cursor.fetchone()
                getingrs = """SELECT * FROM dishs 
                JOIN ingredients_in_dish ON dishs.id = ingredients_in_dish.dish_id 
                JOIN ingredients ON ingredients_in_dish.ingredient_id = ingredients.id 
                WHERE dishs.id = %s"""
                cursor.execute(getingrs, (dish_id))
                dish_ingrs = cursor.fetchall()
                template = env.get_template('inputs/dishord.html')
                dishord = {'dish': dish_info, 'user_info': user_info, 'dish_info': dish_info_total,
                           'dish_ingrs': dish_ingrs}
                self.write(template.render(dishord=dishord))
        except Exception as e:
            print(e)

        finally:
            connect.close()


class customerorders(BaseHandler):
    @tornado.web.authenticated
    def post(self):
        print(self.request.body)
        usr = self.get_secure_cookie("user")
        if usr is not None:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        else:
            user_info = None
        connect = connections.getConnection()
        try:
            with connect.cursor() as cursor:
                sql = """SELECT * FROM users 
                JOIN user_orders ON users.id = user_orders.user_id 
                JOIN orders ON user_orders.order_id = orders.id 
                WHERE users.id = %s """
                cursor.execute(sql, (user_info['id']))
                user_orders = cursor.fetchall()
                template = env.get_template('inputs/customerorders.html')
                orders = {'user_orders': user_orders, 'user_info': user_info}
                self.write(template.render(orders=orders))

        finally:
            connect.close()


class adminPanelHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self):
        usr = self.get_secure_cookie("user")
        if usr is not None:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        else:
            user_info = None
        template = env.get_template('adminpanel.html')
        admin = {'user_info': user_info}
        self.write(template.render(admin=admin, user_info=user_info))

    @tornado.web.authenticated
    def post(self):
        usr = self.get_secure_cookie("user")
        if usr is not None:
            user_info = get_user_info(json.loads(self.get_secure_cookie("user").decode())['phone'])
        else:
            user_info = None
        print(self.request.body)
        target = int(self.get_argument('target'))
        print(target)
        connect = connections.getConnection()

        try:
            with connect.cursor() as cursor:
                if target == 1:
                    pass
                elif target == 2:
                    getallusers = """SELECT * FROM users JOIN users_accesses ON users.id = users_accesses.user_id JOIN access_list ON users_accesses.access_id = access_list.id"""
                    cursor.execute(getallusers)
                    allusers = cursor.fetchall()
                    getallaccesslvl = """SELECT * FROM access_list"""
                    cursor.execute(getallaccesslvl)
                    access_list = cursor.fetchall()
                    template = env.get_template('inputs/admin/blockuser.html')
                    block_user = {'user_info': user_info, 'allusers': allusers, 'access_list': access_list}
                    self.write(template.render(block_user=block_user, user_info=user_info))
                elif target == 3:
                    template = env.get_template('inputs/admin/newdishtype.html')
                    new_dish_type = {'user_info': user_info}
                    self.write(template.render(new_dish_type=new_dish_type, user_info=user_info))

                elif target == 4:
                    template = env.get_template('inputs/admin/newingr.html')
                    self.write(template.render(user_info=user_info))
                elif target == 5:
                    template = env.get_template('inputs/admin/newdish.html')
                    getalltypes = """SELECT * FROM dish_types"""
                    cursor.execute(getalltypes)
                    alltypes = cursor.fetchall()
                    getallingr = """SELECT * FROM ingredients"""
                    cursor.execute(getallingr)
                    allingr = cursor.fetchall()
                    new_dish = {'alltypes': alltypes, 'allingr': allingr}
                    self.write(template.render(new_dish=new_dish, user_info=user_info))
        except Exception as e:
            print(e)
        finally:
            connect.close()


class adminfunc(BaseHandler):
    def write_error(self, status_code: int, **kwargs):
        self.set_status(status_code)
        self.finish({"code": status_code, "message": kwargs})

    @tornado.web.authenticated
    def post(self):
        print(self.request.body)
        func_status = str(self.get_argument('func_status'))
        connect = connections.getConnection()
        print(func_status)
        try:
            with connect.cursor() as cursor:
                if func_status == 'blockuser':
                    user_id = int(self.get_argument('user_id'))
                    access_lvl = int(self.get_argument('access_lvl'))
                    changestatus = """UPDATE users_accesses SET access_id = %s WHERE user_id = %s"""
                    cursor.execute(changestatus, (access_lvl, user_id))
                    connect.commit()
                    self.write_error(status_code=200, message='Статус пользователя успешно изменен')
                elif func_status == 'newdishtype':
                    newdishtype_name = str(self.get_argument('newdishtype_name'))
                    fname = transliterate.translit(newdishtype_name, reversed=True)
                    file1 = self.request.files['newdishtype_img'][0]
                    final_filename = fname + '.png'
                    output_file = open("static/img/" + final_filename, 'wb')
                    output_file.write(file1['body'])
                    addnewdishtype = """INSERT INTO dish_types values(0, %s, %s, %s)"""
                    cursor.execute(addnewdishtype, (newdishtype_name, '../static/img/' + final_filename, fname))
                    connect.commit()
                    self.redirect('/admin')

                elif func_status == 'newdish':
                    print("NEWDISHES")
                    newdish_name = str(self.get_argument('newdish_name'))
                    newdish_desc = str(self.get_argument('newdish_desc'))
                    newdish_price = int(self.get_argument('newdish_price'))
                    newdish_dish_type = int(self.get_argument('newdish_dish_type'))
                    newdish_ingredients = self.get_arguments('newdish_ingredients')
                    newdish_ingredients_weight = self.get_arguments('newdish_ingredients_weight')
                    print(newdish_ingredients)
                    print(newdish_ingredients_weight)

                    fname = transliterate.translit(newdish_name, reversed=True)
                    file1 = self.request.files['newdish_img'][0]
                    final_filename = fname + '.png'
                    output_file = open("static/img/" + final_filename, 'wb')
                    output_file.write(file1['body'])
                    addnewdishtype = """INSERT INTO dishs values(0, %s, %s, 0, %s, %s, %s)"""
                    cursor.execute(addnewdishtype, (
                        newdish_name, newdish_price, newdish_dish_type, newdish_desc,
                        '../static/img/' + final_filename))
                    connect.commit()
                    newdish_id = cursor.lastrowid
                    for i, item in enumerate(newdish_ingredients):
                        insertingrindish = """INSERT INTO ingredients_in_dish VALUES(0, %s, %s, %s)"""
                        cursor.execute(insertingrindish, (newdish_id, item, newdish_ingredients_weight[i]))
                        connect.commit()
                    self.redirect('/admin')

                elif func_status == 'newingr':
                    newingr_name = str(self.get_argument('newingr_name'))
                    newingr_desc = str(self.get_argument('newingr_desc'))
                    newingr_cal = int(self.get_argument('newingr_cal'))

                    addnewingr = """INSERT INTO ingredients values(0, %s, %s, %s)"""
                    cursor.execute(addnewingr, (newingr_name, newingr_desc, newingr_cal))
                    connect.commit()
                    self.redirect('/admin')
        except Exception as e:
            print(e)

        finally:
            connect.close()


def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
        (r"/dishtypes/(.*)", DishTypesHandler),
        (r"/test", testhandler),
        (r"/user/([0-9]+)", UserProfile),
        (r"/login", LoginHandler),
        (r"/testcookie", testcoockie),
        (r"/registration", registrationHandler),
        (r"/authentication", authHandler),
        (r"/remc", removecockie),
        (r"/adddish", addDish),
        (r"/getusrbasket", getUserBasket),
        (r"/payorder", payOrder),
        (r"/clientorders", clientOrdersHandler),
        (r"/clientorders/([0-9]+)", clientOrdersIdHandler),
        (r"/websocket", SimpleWebSocket),
        (r"/updateprofile", updateUserInfo),
        (r"/dishord", dishord),
        (r"/customerorders", customerorders),
        (r"/admin", adminPanelHandler),
        (r"/adminfunc", adminfunc),

    ], **settings,
        template_path=os.path.join(os.path.dirname(__file__), "templates"),
        static_path=os.path.join(os.path.dirname(__file__), "static"),
        default_handler_class=NotFoundHandler)


if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()

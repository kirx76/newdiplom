import json

import tornado.ioloop
import tornado.web
import os
import connections
import hashlib
import transliterate
# from webassets import Environment as EV
# static_directory = "../static"
# output_directory = "/static"
# my_env = EV(static_directory, output_directory)
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
            SELECT users.id, user_name, user_img, user_phone, user_password, access_name 
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
        # self.render('index.html', dish_types=dish_types)
        usr = self.get_secure_cookie("user")
        print(usr)
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
            # self.write_error(status_code=500, message=e)
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
            # self.write_error(status_code=500, message=e)
            dish_count = None
        finally:
            connect.close()
        dicte = {'dishs': dishs, 'user_info': user_info, 'dish_count': dish_count}
        self.write(template.render(dicte=dicte))


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
        print(*args)
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
        print(hashlib.sha256(b'123').hexdigest())
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
        # if self.request.headers.get("Content-Type", "").startswith("application/json"):
        #     self.json_args = json.loads(self.request.body)
        # else:
        #     self.json_args = None

    def get(self):
        template = env.get_template('inputs/registration.html')
        self.write(template.render())

    def write_error(self, status_code: int, **kwargs):
        self.set_status(500)
        self.finish({"code": status_code, "message": kwargs})

    def post(self, *args):
        name = self.get_argument('name')
        phone = ''.join(x for x in self.get_argument('phone') if x.isdigit())
        password = self.get_argument('password')
        crypt_password = hashlib.md5(password.encode()).hexdigest()
        print(name, phone, password)
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
                    print(newuser)
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

    def get(self):
        print(self.request.body)

    def post(self):
        phone = ''.join(x for x in self.get_argument('phone') if x.isdigit())
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
    @tornado.web.authenticated
    def write_error(self, status_code: int, **kwargs):
        self.set_status(500)
        self.finish({"code": status_code, "message": kwargs})

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
    @tornado.web.authenticated
    def write_error(self, status_code: int, **kwargs):
        self.set_status(500)
        self.finish({"code": status_code, "message": kwargs})

    def post(self):
        phone = json.loads(self.get_secure_cookie("user").decode())['phone']

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
                print(answer)
                if answer is None or answer == "" or count < 1:
                    self.write_error(500, message='Ваша корзина пуста')
                else:
                    # self.write(json.dumps(listToDict(answer), indent=4, sort_keys=True, default=str))

                    template = env.get_template('modals/basketmodal.html')
                    user_basket = {'dish_list': answer, 'tables': tables}
                    self.write(template.render(user_basket=user_basket))
        except Exception as e:
            print(e)
        finally:
            connect.close()

class payOrder(BaseHandler):
    @tornado.web.authenticated
    def write_error(self, status_code: int, **kwargs):
        self.set_status(500)
        self.finish({"code": status_code, "message": kwargs})

    def post(self):
        print(self.request.body)
        table_id = int(self.get_argument('table'))
        total_cost = int(self.get_argument('total_cost'))
        order_id = int(self.get_argument('order_id'))
        phone = json.loads(self.get_secure_cookie("user").decode())['phone']
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
                print(tot_cost)
                if tot_cost == total_cost:
                    update_order = """UPDATE orders set order_price = %s, order_status = 1, order_table = %s where orders.id = %s"""
                    cursor.execute(update_order, (tot_cost, table_id, order_id))
                    connect.commit()
                else:
                    self.write_error(500, message='Не стоит менять цену заказа :)')
        except Exception as e:
            print(e)
            self.write_error(500, message='Заказ не создан')

        finally:
            connect.close()
            self.write('Заказ успешно оплачен <a href="/">На главную</a>')


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

    ], **settings,
        template_path=os.path.join(os.path.dirname(__file__), "templates"),
        static_path=os.path.join(os.path.dirname(__file__), "static"),
        default_handler_class=NotFoundHandler)


if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()

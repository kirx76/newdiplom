import pymysql.cursors


# Функция возвращает connection.

def getConnection():
    # Вы можете изменить параметры соединения.
    connection = pymysql.connect(host='localhost',
                                 user='root',
                                 password='',
                                 db='newdiplom',
                                 charset='utf8mb4',
                                 cursorclass=pymysql.cursors.DictCursor)
    return connection

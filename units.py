from tornado.testing import AsyncHTTPTestCase
import host

class TestMyApp(AsyncHTTPTestCase):
    def get_app(self):
        return host.make_app()

    def test_homepage(self):
        response = self.fetch('/')
        self.assertEqual(response.code, 200)

    def test_dish_type(self):
        response = self.fetch('/dishtypes/Burgery')
        self.assertAlmostEqual(response.code, 200)

    def test_stress(self):
        i = 0
        while i < 1000:
            response = self.fetch('/')
            self.assertAlmostEqual(response.code, 200)
            i += 1

    def test_auth(self):
        response = self.fetch('/authentication', method="POST", body=b'phone=8(999)+999-9999&password=123qwe')
        self.assertAlmostEqual(response.code, 200)


import unittest
from app import app

class TestApp(unittest.TestCase):
    def test_home(self):
        tester = app.test_client()
        response = tester.get("/")
        content = response.data.decode("utf-8")
        print(f"\n[TEST LOG] Response Content: {content}")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(content, "Hello, Jenkins Multi-Stage Pipeline!")

if __name__ == "__main__":
    unittest.main()

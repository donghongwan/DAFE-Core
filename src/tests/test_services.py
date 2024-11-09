# tests/test_services.py

import unittest
from services import UserService  # Assuming you have a UserService class

class TestServices(unittest.TestCase):
    def setUp(self):
        self.user_service = UserService()

    def test_create_user(self):
        user = self.user_service.create_user('addr1', 100)
        self.assertEqual(user['address'], 'addr1')
        self.assertEqual(user['balance'], 100)

    def test_get_user(self):
        self.user_service.create_user('addr2', 200)
        user = self.user_service.get_user('addr2')
        self.assertIsNotNone(user)
        self.assertEqual(user['address'], 'addr2')

    def test_update_user_balance(self):
        self.user_service.create_user('addr3', 300)
        self.user_service.update_user_balance('addr3', 400)
        user = self.user_service.get_user('addr3')
        self.assertEqual(user['balance'], 400)

    def test_delete_user(self):
        self.user_service.create_user('addr4', 500)
        self.user_service.delete_user('addr4')
        user = self.user_service.get_user('addr4')
        self.assertIsNone(user)

if __name__ == '__main__':
    unittest.main()

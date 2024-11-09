# tests/test_smart_contracts.py

import unittest
from smart_contracts import SmartContract  # Assuming you have a SmartContract class

class TestSmartContracts(unittest.TestCase):
    def setUp(self):
        self.contract = SmartContract()

    def test_initial_balance(self):
        self.assertEqual(self.contract.get_balance('addr1'), 0)  # Assuming initial balance is 0

    def test_deposit(self):
        self.contract.deposit('addr1', 100)
        self.assertEqual(self.contract.get_balance('addr1'), 100)

    def test_withdraw(self):
        self.contract.deposit('addr1', 200)
        self.contract.withdraw('addr1', 100)
        self.assertEqual(self.contract.get_balance('addr1'), 100)

    def test_withdraw_insufficient_funds(self):
        with self.assertRaises(ValueError):
            self.contract.withdraw('addr1', 100)  # Should raise an error

if __name__ == '__main__':
    unittest.main()

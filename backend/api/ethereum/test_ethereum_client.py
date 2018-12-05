import ethereum_client
from web3 import Web3
import web3

def create_bet_test():
    w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
    test_account = w3.eth.accounts[0]
    print(test_account)
    ethereum_client.create_bet(test_account)

if __name__ == "__main__":
    create_bet_test()
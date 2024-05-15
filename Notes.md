ERC4337 or Account Abstraction:
    A more Modular approach to use a wallet but depends on the use of EOA for validation of a sender of the operation 

    4 parts: 
    -> Entry Point Contract 
    -> AA wallet 
    -> Paymaster 
    -> Bundler 


    Entry Point Contract is the main part where the changes/transactions are updated on the blockchain 

    AA wallet is the wallet that will be used to pay for the transaction/ used to do the user operation that could be like a normal EOA 

    Paymaster is the contract that will be used to pay for the transaction
    
    Bundler is the contract that will be used to bundle the transaction and send it to the Entry Point contract. It also has a important role that is to simulate the userOperation and check if the userOperation is valid or not and only after that it will send the transaction to the Entry Point contract.
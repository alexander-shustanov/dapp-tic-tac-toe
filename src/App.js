import React, {Component} from 'react';
import Web3 from 'web3';
import ticTacToe from 'contracts/TicTacToe.json';
import TruffleContract from 'truffle-contract';

if (typeof window.web3 === 'undefined') {
    alert("No web3");
}

let web3 = window.web3;

function initContract() {
    let contract = TruffleContract(ticTacToe);
    contract.setProvider(web3);
    return contract;
}

class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            balance: 0.0,
            game: 0,
            deck: null
        };

        this.contract = initContract();

        web3.eth.getBalance(web3.eth.defaultAccount, (err, balance) => {
            if (err !== null) {
                alert(err);
            } else {
                this.setState({balance: web3.fromWei(web3.toDecimal(balance))});
            }
        });


    }

    render() {
        return (
            <div>My balance is {this.state.balance}</div>
        );
    }
}

export default App;

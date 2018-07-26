var TicTacToe = artifacts.require("TicTacToe");

module.exports = deployer => {
	deployer.deploy(TicTacToe);
};

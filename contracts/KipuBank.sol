// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract KipuBank {
    
    uint256 public immutable LIMIT_WITHDRAWAL = 5 ether;
    uint256 public immutable bankCap;

    mapping(address => uint256) private balances;

    uint256 public balanceTotal;
    uint256 public depositosTotales;
    uint256 public retirosTotales;

    constructor(uint256 _bankCap) {
        bankCap = _bankCap;
    }

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    error LimiteDepositoExcedido();
    error LimiteRetiroExcedido();
    error FondosInsuficientes();
    error TransferenciaFallida();
    error AccionNoPermitida();
    error ValorCero();

    modifier excedioLimiteDeposito() {
        if (address(this).balance + msg.value > bankCap) {
            revert LimiteDepositoExcedido();
        }
        _;
    }

    function deposit() external payable excedioLimiteDeposito() {

        if (msg.value == 0) {
            revert ValorCero();
        }
        balances[msg.sender] += msg.value;
        balanceTotal += msg.value;
        depositosTotales++;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external { 
        if (amount == 0) {
            revert ValorCero();
        }
        if (amount > LIMIT_WITHDRAWAL) {
            revert LimiteRetiroExcedido();
        }
        if (!hasSufficientFunds(msg.sender, amount)) {
            revert FondosInsuficientes();
        }

        balances[msg.sender] -= amount;
        retirosTotales++;
        balanceTotal -= amount;
        emit Withdraw(msg.sender, amount);

        (bool transferenciaCompletada, ) = payable(msg.sender).call{value: amount}("");
        if (!transferenciaCompletada) {
            revert TransferenciaFallida();
        }
    }

    function hasSufficientFunds(address user, uint256 amount) private view returns(bool) {
        return balances[user] >= amount;
    }

    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    receive() external payable { 
        revert AccionNoPermitida();
    }

    fallback() external payable {
        revert AccionNoPermitida();
    }

}
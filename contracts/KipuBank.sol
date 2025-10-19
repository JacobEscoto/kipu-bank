// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract KipuBank {
    /// @notice limitWithdrawal Define el limite de saldo en Retiros (ETHER)
    uint256 public immutable limitWithdrawal = 5 ether;

    /// @notice bankCap Define el limite de saldo en depositos en el banco
    uint256 public immutable bankCap;

    /// @notice Mapping de balances de los usuarios
    mapping(address => uint256) private balances;

    /// @notice balanceTotal Contador del balance total en kipu bank
    uint256 public balanceTotal;

    /// @notice depositosTotales Contador para ver cuantos depositos se han realizado
    uint256 public depositosTotales;

    /// @notice retirosTotales Contador para ver cuantos retiros se han realizado
    uint256 public retirosTotales;
    
    // Constructor
    constructor(uint256 _bankCap) {
        bankCap = _bankCap;
    }
    
    // Eventos
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    /// @notice Error que registra cuando un usuario deposita mas del limite establecido en el contrato
    error LimiteDepositoExcedido();
    
    /// @notice Error que registra cuando un usuario hace un retiro que excede el limite establecido
    error LimiteRetiroExcedido();

    /// @notice Error que se registra cuando no hay fondos suficientes para retirar
    error FondosInsuficientes();
    
    /// @notice Error que registra cuando la transferencia ha fallado
    error TransferenciaFallida();
    
    /// @notice Error que registra cuando se hace un receive o fallback
    error AccionNoPermitida();
    
    /// @notice Error cuando el usuario quiere depositar / registrar un monto de 0 ETH
    error ValorCero();

    /// @notice Modifier para saber si el limite de deposito se ha excedido
    modifier excedioLimiteDeposito() {
        if (address(this).balance + msg.value > bankCap) {
            revert LimiteDepositoExcedido();
        }
        _;
    }
    /// @notice Depositar fondos en la boveda
    function deposit() external payable excedioLimiteDeposito() {

        if (msg.value == 0) {
            revert ValorCero();
        }
        balances[msg.sender] += msg.value;
        balanceTotal += msg.value;
        depositosTotales++;
        emit Deposit(msg.sender, msg.value);
    }

    /** 
    * @notice Retirar un monto de la boveda
    * @param amount Cantidad a retirar
    */
    function withdraw(uint256 amount) external { 
        if (amount == 0) {
            revert ValorCero();
        }
        if (amount > limitWithdrawal) {
            revert LimiteRetiroExcedido();
        }
        if (!hasSufficientFunds(msg.sender, amount)) {
            revert FondosInsuficientes();
        }

        balances[msg.sender] -= amount;
        balanceTotal -= amount;
        retirosTotales++;
        emit Withdraw(msg.sender, amount);

        (bool transferenciaCompletada, ) = payable(msg.sender).call{value: amount}("");
        if (!transferenciaCompletada) {
            revert TransferenciaFallida();
        }
    }

    /**
    * @notice Permite ver si hay suficientes fondos
    * @param user Direccion del usuario
    * @param amount Cantidad de fondos solicitados
    */
    function hasSufficientFunds(address user, uint256 amount) private view returns(bool) {
        return balances[user] >= amount;
    }

    /**
    * @notice Permite ver el balance de un usuario
    * @param user Direccion del usuario
    */
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
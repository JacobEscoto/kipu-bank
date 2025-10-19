# Smart Contract - KipuBank
**🎯 Objetivo**<br/>
Este smart contract esta diseñado para depositar ETH, al igual que retirar fondos de su bóveda personal. 

## Funcionalidades del Contrato

- Depositar ETH
- Retirar ETH
- Consultar el balance del usuario

## Instrucciones de Deploy
- Crear o Copiar el archivo [KipuBank.sol](contracts/KipuBank.sol)
- Compilar el archivo con cualquier versión arriba de 0.8.20
- Entrar a la tab de <ins>Deploy and Run Transactions</ins>
- Se debe escribir un parámetro en el requisito de bankCap
- Dale click a deploy
- Deberás confirmar la acción si estas utilizando un Injected Provider

## Interacción con el Contrato
- **deposit**
    - Debes seleccionar una cuenta con el que harás el deposito (Injected Provider o accounts de Remix VM).
    - En el text field de **value** deberás de introducir la cantidad a depositar.
    - Dar click al botón **deposit**.
    - **Ojo:** Se verifica que no hayas ingresado un valor en 0 o mayor que el límite de saldo en depositos.
- **withdraw**
    - Introducir la cantidad a retirar.
    - Dar click al botón **withdraw**.
    - **Ojo:** Se verifica que no hayas ingresado un valor igual a 0 o mayor que tu balance!
- **Ver Balance**
    - Debes ingresar el address del usuario al que quieres obtener el balance.
    - Dar click al boton de **getBalance**. Te devolverá el balance del usuario solicitado.


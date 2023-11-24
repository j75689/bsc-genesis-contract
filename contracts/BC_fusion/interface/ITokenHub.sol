pragma solidity 0.8.17;

interface ITokenHub {
  function unlock(address contractAddr, address recipient, uint256 amount)
    external payable;
  function getContractAddrByBEP2Symbol(bytes32 bep2Symbol) external view returns(address);
  function BEP2_TOKEN_SYMBOL_FOR_BNB() external view returns (bytes32);
}

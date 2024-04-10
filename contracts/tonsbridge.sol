pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Context.sol";

    struct TonAddress {
        int8 workchain;
        bytes32 address_hash;
    }
    
interface wton {
    function burn(uint256 amount, TonAddress memory addr) external;
}

interface univ2 {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) 
        external 
        returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
}

contract tonsbridge is Context {
    using SafeMath for uint256;
    event bridges(TonAddress to , address from, uint256 amount ,uint256 amountFinal, uint256 amountRouter , bool isPrepaid , uint256 time);
    event withdraw(address from , address to , uint256 amount ,uint256 time);
    event withdrawToken(address from , address to , uint256 amount,address token ,uint256 time);

    bool internal locked = false;
    address public owner ;
    address public wtonContract ;
    address public swapContract ;
    uint256 rDecimals = 1000;
    constructor(address ton , address swap) {
        owner = msg.sender;
        wtonContract = ton;
        swapContract = swap;
    }
    
    function bridgeETH(TonAddress memory to , uint256 amount,address token,uint256 feeRate ) public payable
    {
        //Transfer token to contract
        ERC20(token).transferFrom(_msgSender(),address(this),amount);
        ERC20(token).approve(swapContract,amount);
        //Swap via univ2 and get amounts out 
        address[] memory path;
        path = new address[](2);
        path[0] = token;
        path[1] = wtonContract;
        uint[] memory tamount = univ2(swapContract).swapExactETHForTokens{value: msg.value}(0,path,address(this),block.timestamp+60);
        //Do the bridge
        bridge(to,tamount[1],feeRate);
    }

    function bridgeToken(TonAddress memory to , uint256 amount,address token,uint256 feeRate ) public
    {
        //Transfer token to contract
        ERC20(token).transferFrom(_msgSender(),address(this),amount);
        ERC20(token).approve(swapContract,amount);
        //Swap via univ2 and get amounts out 
        address[] memory path;
        path = new address[](2);
        path[0] = token;
        path[1] = wtonContract;
        uint[] memory tamount = univ2(swapContract).swapExactTokensForTokens(amount,0,path,address(this),block.timestamp+60);
        //Do the bridge
        bridge(to,tamount[1],feeRate);

    }

    function bridgeWToken(TonAddress memory to , uint256 amount ,uint256 feeRate ) public
    {
        ERC20(wtonContract).transferFrom(_msgSender(),address(this),amount);
        bridge(to,amount,feeRate);
    }

    function bridge(TonAddress memory to , uint256 amount,uint256 feeRate ) internal
    {
        require(!locked);
        locked = true;
        bool isPre = true;
        if(feeRate>0)
        {
            isPre=false;
        }
        uint256 amountRouter = (amount.mul(feeRate)).div(rDecimals);
        uint256 amountBurn = amount.sub(amountRouter);
        wton(wtonContract).burn(amountBurn,to);

        emit bridges(to,_msgSender(),amount,amountBurn,amountRouter,isPre,block.timestamp);
        locked = false;
    }
    function withdraws(address to , uint256 amount ) public 
    {
        require(msg.sender == owner , 'permission deny');
        payable(to).transfer(amount);
        emit withdraw(msg.sender, to, amount, block.timestamp);
    }

    function withdrawTokens(address to ,address token, uint256 amount ) public 
    {
        require(msg.sender == owner , 'permission deny');
        ERC20(token).transfer(to, amount);
        emit withdrawToken(msg.sender, to, amount,token, block.timestamp);
    }
    
}
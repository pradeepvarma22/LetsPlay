// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "hardhat/console.sol";
import "./VRFv2Consumer.sol";

contract LetsPlay is VRFv2Consumer {

    //
    event CreateGame(address _whoCreated, uint256 _gameId);
    event StakeGameFee(address _user, uint256 _gameId, bool _isLast);
    event ClaimStake(address _winner, uint256 _gameId, uint256 _amount);
    uint256 public maxPlayers;
    uint256 public constant entryFee = 0.0000000001 ether;
    uint256 public gameCount;


    constructor(uint64 _subscriptionId) VRFv2Consumer(_subscriptionId) {
        maxPlayers = 2;
    }


    Game[] public games;


    struct Game {
        uint256 createdDate;
        bool isStarted;
        bool isEnded;
        address winner;
        uint256 winnerAmount;
        uint256 presentPlayersCount;
        address[] players;
    }


    function createGame() external returns(uint256 _gameId) {
        gameCount += 1;

        address[] memory _dummyPlayers;

        Game memory _game = Game({
            createdDate: block.timestamp,
            isStarted: false,
            isEnded: false,
            winner: address(0),
            winnerAmount: 0,
            presentPlayersCount: 0,
            players: _dummyPlayers
        });

        games.push(_game);
        emit CreateGame(msg.sender, _gameId);
        _gameId = gameCount - 1;
    }

    function stakeGameFee(uint256 _gameId) external payable returns(bool isLast, uint256 _requestId) {
        require(games[_gameId].isEnded == false, "Game Ended Started");
        require(games[_gameId].isStarted == false, "Game is currently running");
        require(
            games[_gameId].presentPlayersCount < maxPlayers,
            "Max Players Exceeded"
        );
        isLast = false;
        require(msg.value > entryFee, "Entry Fee is too low");
        games[_gameId].presentPlayersCount += 1;

        if (games[_gameId].presentPlayersCount == maxPlayers) {
            games[_gameId].isStarted = true;
            games[_gameId].winnerAmount = entryFee * maxPlayers;
            isLast = true;
            _requestId =  requestRandomWords();
        } else {
            games[_gameId].players.push(msg.sender);
        }
        emit StakeGameFee(msg.sender, _gameId,  isLast);
        return (isLast,_requestId);
    }

    function claimStake(uint256 _gameId, uint256 _requestId) external
    {
        require(games[_gameId].isEnded, "Already Claimed");
        bool fulfillDone = false;
        address payable _winnerAddress;
        address temp_winnerAddress;
        (temp_winnerAddress, fulfillDone) = winner(_gameId, _requestId);

        if(fulfillDone)
        {
            _winnerAddress = payable(temp_winnerAddress);
            delete games[_gameId].players;
            games[_gameId].isEnded = true;
            _winnerAddress.transfer(entryFee * maxPlayers);
            games[_gameId].winnerAmount = entryFee * maxPlayers;
            games[_gameId].winner= temp_winnerAddress;
        }
        emit ClaimStake(temp_winnerAddress, _gameId, entryFee * maxPlayers);
    }


    function winner(uint256 _gameId, uint256 _requestId) public view returns(address _winnerAddress,bool fulfillDone)
    {
        uint256[] memory data;
        uint256 _ans;
        (fulfillDone, data)  =  getRequestStatus(_requestId);
        if(fulfillDone)
        {
            _ans = data[0];
        }
        _ans = _ans%maxPlayers;
        _winnerAddress = games[_gameId].players[_ans];
        return (_winnerAddress, fulfillDone);
    }


    // once last player had joined the game automatically game will be started
    function hasAllPlayersStaked(uint256 _gameId) public view returns (bool) {
        return games[_gameId].presentPlayersCount == maxPlayers;
    }


    function hasUserPaid(uint256 _gameId) public view returns (bool _isPaid) {
        uint256 _playersSize = games[_gameId].players.length;

        for (uint256 i = 0; i < _playersSize; i++) {
            if (games[_gameId].players[i] == msg.sender) {
                _isPaid = true;
            }
        }
        _isPaid = false;
        return _isPaid;
    }
}
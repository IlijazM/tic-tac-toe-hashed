// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TicTacToe {
    struct Lobby {
        /// If this value is false, the Lobby is "null".
        bool nonDefault;
        address playerOne;
        address playerTwo;
        address winner;
        bytes1 currentPlayer;
        bytes1[9] board;
    }

    /// A player mapped to a lobby.
    /// If the resulting id is 0, the player is not inside of a lobby.
    mapping(address => uint256) public lobbyIdsByAddress;

    /// All lobbies
    /// There will be no lobby with the key 0.
    mapping(uint256 => Lobby) public lobbiesById;

    /// Keeps track of the lobby count and will also be responsible for generating unique lobby ids.
    uint256 public lobbyCount;

    constructor() {
        lobbyCount = 1;
    }

    /// Joins a lobby.
    /// requires: the player must not by inside of a lobby already.
    function joinLobby() external {
        // Gets the current lobby
        uint256 lobbyId = lobbyIdsByAddress[msg.sender];

        require(lobbyId == 0, "The player is already in a lobby.");

        // Checks if the newest lobby has a space left.
        if (
            lobbiesById[lobbyCount - 1].playerOne != address(0) &&
            lobbiesById[lobbyCount - 1].playerTwo == address(0)
        ) {
            // Join the lobby.
            lobbiesById[lobbyCount - 1].playerTwo = msg.sender;
            lobbyIdsByAddress[msg.sender] = lobbyCount - 1;
        } else {
            // Creates a new lobby
            lobbiesById[lobbyCount] = Lobby({
                nonDefault: true,
                playerOne: msg.sender,
                playerTwo: address(0),
                winner: address(0),
                currentPlayer: 0x00,
                board: [
                    bytes1("2"),
                    bytes1("2"),
                    bytes1("2"),
                    bytes1("2"),
                    bytes1("2"),
                    bytes1("2"),
                    bytes1("2"),
                    bytes1("2"),
                    bytes1("2")
                ]
            });
            lobbyIdsByAddress[msg.sender] = lobbyCount;
            lobbyCount++;
        }
    }

    /// Gets the current lobby.
    function getCurrentLobby() public view returns (Lobby memory) {
        return lobbiesById[lobbyIdsByAddress[msg.sender]];
    }

    /// Leaves a lobby by setting the winner to the opponent.
    /// requires: the player must be inside of a lobby
    function leaveLobby() external {
        Lobby storage lobby = lobbiesById[lobbyIdsByAddress[msg.sender]];

        require(lobby.nonDefault == true, "The player is not in a lobby.");

        if (lobby.playerOne == msg.sender) {
            lobby.winner = lobby.playerTwo;
        } else {
            lobby.winner = lobby.playerOne;
        }

        lobbyIdsByAddress[lobby.playerOne] = 0;
        lobbyIdsByAddress[lobby.playerTwo] = 0;
    }

    /// If the users requests to make a play in the current lobby.
    /// requires: position must be between 0 and 8.
    /// requires: the player must be inside of a lobby.
    /// requires: it must be the players turn.
    /// requires: the required position must not be already set
    /// @param position the index of the field.
    function requestPlay(uint8 position) external {
        require(position < 9, "The position must be between 0 - 8");

        Lobby storage lobby = lobbiesById[lobbyIdsByAddress[msg.sender]];

        require(lobby.nonDefault == true, "The player is not in a lobby.");

        if (lobby.currentPlayer == 0x00) {
            require(msg.sender == lobby.playerOne, "It's player one's turn.");
        } else {
            require(msg.sender == lobby.playerTwo, "It's player two's turn.");
        }

        require(
            lobby.board[position] == bytes1("2"),
            "Cannot set an already set position"
        );

        lobby.board[position] = lobby.currentPlayer;
        _winDetection(lobby, msg.sender);
        lobby.currentPlayer = ~lobby.currentPlayer;
    }

    function _winDetection(Lobby storage lobby, address sender) internal {
        if (
            lobby.board[0] == lobby.currentPlayer &&
            lobby.board[1] == lobby.currentPlayer &&
            lobby.board[2] == lobby.currentPlayer
        ) {
            lobby.winner = sender;
            lobbyIdsByAddress[lobby.playerOne] = 0;
            lobbyIdsByAddress[lobby.playerTwo] = 0;
            return;
        }
        if (
            lobby.board[3] == lobby.currentPlayer &&
            lobby.board[4] == lobby.currentPlayer &&
            lobby.board[5] == lobby.currentPlayer
        ) {
            lobby.winner = sender;
            lobbyIdsByAddress[lobby.playerOne] = 0;
            lobbyIdsByAddress[lobby.playerTwo] = 0;
            return;
        }
        if (
            lobby.board[6] == lobby.currentPlayer &&
            lobby.board[7] == lobby.currentPlayer &&
            lobby.board[8] == lobby.currentPlayer
        ) {
            lobby.winner = sender;
            lobbyIdsByAddress[lobby.playerOne] = 0;
            lobbyIdsByAddress[lobby.playerTwo] = 0;
            return;
        }
        if (
            lobby.board[0] == lobby.currentPlayer &&
            lobby.board[3] == lobby.currentPlayer &&
            lobby.board[6] == lobby.currentPlayer
        ) {
            lobby.winner = sender;
            lobbyIdsByAddress[lobby.playerOne] = 0;
            lobbyIdsByAddress[lobby.playerTwo] = 0;
            return;
        }
        if (
            lobby.board[1] == lobby.currentPlayer &&
            lobby.board[4] == lobby.currentPlayer &&
            lobby.board[7] == lobby.currentPlayer
        ) {
            lobby.winner = sender;
            lobbyIdsByAddress[lobby.playerOne] = 0;
            lobbyIdsByAddress[lobby.playerTwo] = 0;
            return;
        }
        if (
            lobby.board[2] == lobby.currentPlayer &&
            lobby.board[5] == lobby.currentPlayer &&
            lobby.board[8] == lobby.currentPlayer
        ) {
            lobby.winner = sender;
            lobbyIdsByAddress[lobby.playerOne] = 0;
            lobbyIdsByAddress[lobby.playerTwo] = 0;
            return;
        }
        if (
            lobby.board[0] == lobby.currentPlayer &&
            lobby.board[4] == lobby.currentPlayer &&
            lobby.board[8] == lobby.currentPlayer
        ) {
            lobby.winner = sender;
            lobbyIdsByAddress[lobby.playerOne] = 0;
            lobbyIdsByAddress[lobby.playerTwo] = 0;
            return;
        }
        if (
            lobby.board[2] == lobby.currentPlayer &&
            lobby.board[4] == lobby.currentPlayer &&
            lobby.board[6] == lobby.currentPlayer
        ) {
            lobby.winner = sender;
            lobbyIdsByAddress[lobby.playerOne] = 0;
            lobbyIdsByAddress[lobby.playerTwo] = 0;
            return;
        }
    }
}

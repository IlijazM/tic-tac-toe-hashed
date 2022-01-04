// Source code to interact with smart contract

// web3 provider with fallback for old version
if (window.ethereum) {
  window.web3 = new Web3(window.ethereum);
  try {
    // ask user for permission
    ethereum.enable();
    // user approved permission
  } catch (error) {
    // user rejected permission
    console.log("user rejected permission");
  }
} else if (window.web3) {
  window.web3 = new Web3(window.web3.currentProvider);
  // no need to ask for permission
} else {
  window.alert(
    "Non-Ethereum browser detected. You should consider trying MetaMask!"
  );
}
console.log(window.web3.currentProvider);

// contractAddress and abi are setted after contract deploy
var contractAddress = "0x83008328eFDbbef4ad924093268CdC3ca12fEBd7";
var abi = JSON.parse(
  `[
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [],
      "name": "getCurrentLobby",
      "outputs": [
        {
          "components": [
            {
              "internalType": "bool",
              "name": "nonDefault",
              "type": "bool"
            },
            {
              "internalType": "address",
              "name": "playerOne",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "playerTwo",
              "type": "address"
            },
            {
              "internalType": "address",
              "name": "winner",
              "type": "address"
            },
            {
              "internalType": "bytes1",
              "name": "currentPlayer",
              "type": "bytes1"
            },
            {
              "internalType": "bytes1[9]",
              "name": "board",
              "type": "bytes1[9]"
            }
          ],
          "internalType": "struct TicTacToe.Lobby",
          "name": "",
          "type": "tuple"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "joinLobby",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "leaveLobby",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "lobbiesById",
      "outputs": [
        {
          "internalType": "bool",
          "name": "nonDefault",
          "type": "bool"
        },
        {
          "internalType": "address",
          "name": "playerOne",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "playerTwo",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "winner",
          "type": "address"
        },
        {
          "internalType": "bytes1",
          "name": "currentPlayer",
          "type": "bytes1"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "lobbyCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "name": "lobbyIdsByAddress",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint8",
          "name": "position",
          "type": "uint8"
        }
      ],
      "name": "requestPlay",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]`
);

//contract instance
contract = new web3.eth.Contract(abi, contractAddress);

// Accounts
var account;

web3.eth.getAccounts(function (err, accounts) {
  if (err != null) {
    alert("Error retrieving accounts.");
    return;
  }
  if (accounts.length == 0) {
    alert(
      "No account found! Make sure the Ethereum client is configured properly."
    );
    return;
  }
  account = accounts[0];
  console.log("Account: " + account);
  web3.eth.defaultAccount = account;

  setInterval(() => {
    getCurrentLobby();
  }, 1000);
});

function getCurrentLobby() {
  console.log("Calling: TicTacToe.getCurrentLobby()");
  contract.methods
    .getCurrentLobby()
    .call({ from: account })
    .then((res) => {
      console.log("[TicTacToe.getCurrentLobby.res]: ", res);
      player_one.textContent = res.playerOne;
      player_two.textContent = res.playerTwo;
      player_one_you.innerHTML = res.playerOne == account ? "(You)" : "";
      player_two_you.innerHTML = res.playerTwo == account ? "(You)" : "";
      current_player.textContent =
        res.currentPlayer == "0x00" ? "Player one" : "Player two";
      if (res.currentPlayer == "0x00" && res.playerOne == account) {
        current_player_indicator.classList.add("current");
      } else {
        current_player_indicator.classList.remove("current");
      }
      res.board.forEach((field, index) => {
        const fieldEl = document.querySelector(`.ifield-${index}`);
        fieldEl.classList.remove("x");
        fieldEl.classList.remove("o");
        if (field == "0x00") {
          fieldEl.classList.add("x");
        } else if (field == "0xff") {
          fieldEl.classList.add("o");
        }
      });
    });
}

function joinLobby() {
  console.log("Calling: TicTacToe.joinLobby()");
  contract.methods
    .joinLobby()
    .send({ from: account })
    .then((res) => {
      console.log("[TicTacToe.joinLobby.res]: ", res);
    });
}

function leaveLobby() {
  console.log("Calling: TicTacToe.leaveLobby()");
  contract.methods
    .leaveLobby()
    .send({ from: account })
    .then((res) => {
      console.log("[TicTacToe.leaveLobby.res]: ", res);
    });
}

function requestPlay(index) {
  console.log(`Calling: TicTacToe.requestPlay(${index})`);
  contract.methods
    .requestPlay(index)
    .send({ from: account })
    .then((res) => {
      console.log("[TicTacToe.requestPlay.res]: ", res);
      getCurrentLobby();
    });
}

function fieldClicked(fieldIndex) {
  requestPlay(fieldIndex);
}

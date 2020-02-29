const path = require("path");
const HDWalletProvider = require('truffle-hdwallet-provider');

module.exports = {
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    rinkeby: {
      provider: function () {
        return new HDWalletProvider("76be542abb27f49ce2be661351d2a0463642c317a6694f38d9b6d648811d18d0", "https://rinkeby.infura.io/v3/c165e182bccd41a39ccec19e29830d77")
      },
      network_id: 4
    }
  }
};
const ExchangeToken = artifacts.require('ExchangeToken')

module.exports = async function (deployer, network, accounts) {
    await deployer.deploy(ExchangeToken)
    const exchangeToken = await ExchangeToken.deployed()
    console.log(exchangeToken.address)
}

var MiroToken = artifacts.require("./MiroToken.sol");

contract('MiroToken', function(accounts) {

    beforeEach(async function() {
        this.token = await MiroToken.deployed();
    })

    it('Should name equals Mirocana Token', async function() {
        assert(this.token.name.call(), "Mirocana Token", "Token name is wrong");
    });

    it('Should symbol equals MIRO', async function() {
        assert(this.token.symbol.call(), "MIRO", "Token symbol is wrong");
    });

    it('Should decimals is 18', async function() {
        assert(this.token.decimals.call(), 18, "Token decimals is wrong");
    });

});

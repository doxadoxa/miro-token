var MiroPresale = artifacts.require("./MiroPresale.sol");
var MiroToken = artifacts.require("./MiroToken.sol");


contract('MiroPresale', function(accounts) {

    this.multisigStartBalance = 0;

    before(async function() {

        this.multisig = accounts[1];
        this.rate = 1000;

        this.startAt = Math.round(Date.now()/1000)-5*24*60*60;
        this.period = 21;

        this.token = await MiroToken.new();
        this.presale = await MiroPresale.new(this.token.address, this.multisig, this.startAt, this.period, this.rate);

        this.investor = accounts[3];
        this.investmentAmount = 1;//1 ether
    });

    it('Should multisig address equals this.multisig', async function() {
        var multisig = await this.presale.multisig.call();

        assert.equal(multisig, this.multisig, "Multisig address is wrong");
    });

    it('Should contains right startAt', async function() {
        var startAt = await this.presale.startAt.call();

        assert.equal(startAt, this.startAt, "Start date is wrong");
    });

    it('Should contains right endAt', async function() {
        var endAt = await this.presale.endAt.call();
        var calculatedEndAt = this.startAt + this.period*24*60*60;

        assert.equal(endAt, calculatedEndAt, "End date is wrong");
    });

    it('Should be active', async function() {
        var startAt = await this.presale.startAt.call();
        var endAt = await this.presale.endAt.call();

        var now = Math.round(Date.now()/1000);

        assert.equal( (now > startAt ) && (now <= endAt), true, "Presale not active" );
    });

    it('Should send tokens to purchaser', async function() {
        this.multisigStartBalance = await web3.eth.getBalance(this.multisig);

        await this.presale.sendTransaction({
            value: this.investmentAmount * 10 ** 18,
            from: this.investor
        });

        const balance = await this.token.balanceOf(this.investor);

        assert.equal(balance.valueOf(), this.investmentAmount * this.rate );
    });

    it('Should be change multisig balance in ether', async function() {
        const balance = await web3.eth.getBalance(this.multisig);

        assert.equal(balance.valueOf(), this.multisigStartBalance.add(this.investmentAmount * 10 ** 18).valueOf());
    });

    it('Try to call mint and some tokens. Should be 0 tokens.', async function() {
        var result = await this.token.mint.call(accounts[5], 5199);

        const balance = await this.token.balanceOf(accounts[5]);

        assert.equal(balance.valueOf(), 0 );
    });
});

/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { ChaincodeStub, ClientIdentity } = require('fabric-shim');
const { LandContract } = require('..');
const winston = require('winston');

const chai = require('chai');
const chaiAsPromised = require('chai-as-promised');
const sinon = require('sinon');
const sinonChai = require('sinon-chai');

chai.should();
chai.use(chaiAsPromised);
chai.use(sinonChai);

class TestContext {

    constructor() {
        this.stub = sinon.createStubInstance(ChaincodeStub);
        this.clientIdentity = sinon.createStubInstance(ClientIdentity);
        this.logger = {
            getLogger: sinon.stub().returns(sinon.createStubInstance(winston.createLogger().constructor)),
            setLevel: sinon.stub(),
        };
    }

}

describe('LandContract', () => {

    let contract;
    let ctx;

    beforeEach(() => {
        contract = new LandContract();
        ctx = new TestContext();
        ctx.stub.getState.withArgs('1001').resolves(Buffer.from('{"value":"land 1001 value"}'));
        ctx.stub.getState.withArgs('1002').resolves(Buffer.from('{"value":"land 1002 value"}'));
    });

    describe('#landExists', () => {

        it('should return true for a land', async () => {
            await contract.landExists(ctx, '1001').should.eventually.be.true;
        });

        it('should return false for a land that does not exist', async () => {
            await contract.landExists(ctx, '1003').should.eventually.be.false;
        });

    });

    describe('#createLand', () => {

        it('should create a land', async () => {
            await contract.createLand(ctx, '1003', 'land 1003 value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1003', Buffer.from('{"value":"land 1003 value"}'));
        });

        it('should throw an error for a land that already exists', async () => {
            await contract.createLand(ctx, '1001', 'myvalue').should.be.rejectedWith(/The land 1001 already exists/);
        });

    });

    describe('#readLand', () => {

        it('should return a land', async () => {
            await contract.readLand(ctx, '1001').should.eventually.deep.equal({ value: 'land 1001 value' });
        });

        it('should throw an error for a land that does not exist', async () => {
            await contract.readLand(ctx, '1003').should.be.rejectedWith(/The land 1003 does not exist/);
        });

    });

    describe('#updateLand', () => {

        it('should update a land', async () => {
            await contract.updateLand(ctx, '1001', 'land 1001 new value');
            ctx.stub.putState.should.have.been.calledOnceWithExactly('1001', Buffer.from('{"value":"land 1001 new value"}'));
        });

        it('should throw an error for a land that does not exist', async () => {
            await contract.updateLand(ctx, '1003', 'land 1003 new value').should.be.rejectedWith(/The land 1003 does not exist/);
        });

    });

    describe('#deleteLand', () => {

        it('should delete a land', async () => {
            await contract.deleteLand(ctx, '1001');
            ctx.stub.deleteState.should.have.been.calledOnceWithExactly('1001');
        });

        it('should throw an error for a land that does not exist', async () => {
            await contract.deleteLand(ctx, '1003').should.be.rejectedWith(/The land 1003 does not exist/);
        });

    });

});

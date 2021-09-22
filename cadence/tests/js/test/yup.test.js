import path from "path";

import {emulator, getAccountAddress, init, shallPass, shallResolve, shallRevert} from "flow-js-testing";

import {getYUPAdminAddress} from "../src/common";
import {
	deployYUP,
	getYUPCount,
	getYUPSupply,
	mintYUP,
	setupYUPOnAccount,
	transferYUP,
	influencerID,
	editionID,
	serialNumber,
	url, createYUPAccount
} from "../src/yup";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("YUP", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 7002;
		init(basePath, port);
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall deploy YUP contract", async () => {
		await deployYUP();
	});

	it("supply shall be 0 after contract is deployed", async () => {
		// Setup
		await deployYUP();
		const YUPAdmin = await getYUPAdminAddress();
		await shallPass(setupYUPOnAccount(YUPAdmin));

		await shallResolve(async () => {
			const supply = await getYUPSupply();
			expect(supply).toBe(0);
		});
	});

	it("shall be able to create account a yup", async () => {
		// Setup
		await deployYUP();
		const YUPAdmin = await getYUPAdminAddress();
		const account = await createYUPAccount(YUPAdmin);
		let Alice = account.events[5].data.address
		const influencerIdToMint = influencerID;
		const editionIdToMint = editionID;
		const serialNumberToMint = serialNumber;
		const urlToMint =  url;
		// Mint instruction for Alice account shall be resolved
		await shallPass(mintYUP(influencerIdToMint,editionIdToMint, serialNumberToMint, urlToMint, Alice));
	});

	it("shall be able to mint a yup", async () => {
		// Setup
		await deployYUP();
		const Alice = await getAccountAddress("Alice");
		await setupYUPOnAccount(Alice);
		const influencerIdToMint = influencerID;
		const editionIdToMint = editionID;
		const serialNumberToMint = serialNumber;
		const urlToMint =  url;

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintYUP(influencerIdToMint,editionIdToMint, serialNumberToMint, urlToMint, Alice));
	});

	it("shall be able to create a new empty NFT Collection", async () => {
		// Setup
		await deployYUP();
		const Alice = await getAccountAddress("Alice");
		await setupYUPOnAccount(Alice);

		// shall be able te read Alice collection and ensure it's empty
		await shallResolve(async () => {
			const itemCount = await getYUPCount(Alice);
			expect(itemCount).toBe(0);
		});
	});

	it("shall not be able to withdraw an NFT that doesn't exist in a collection", async () => {
		// Setup
		await deployYUP();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupYUPOnAccount(Alice);
		await setupYUPOnAccount(Bob);

		// Transfer transaction shall fail for non-existent item
		await shallRevert(transferYUP(Alice, Bob, 1337));
	});

	it("shall be able to withdraw an NFT and deposit to another accounts collection", async () => {
		await deployYUP();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupYUPOnAccount(Alice);
		await setupYUPOnAccount(Bob);

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintYUP(influencerID, editionID, serialNumber, url, Alice));

		// Transfer transaction shall pass
		await shallPass(transferYUP(Alice, Bob, 0));
	});
});

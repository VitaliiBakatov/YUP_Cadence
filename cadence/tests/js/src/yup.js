import {deployContractByName, executeScript, mintFlow, sendTransaction} from "flow-js-testing";

import {getYUPAdminAddress} from "./common";
import * as rlp from "rlp";
let EC = require('elliptic').ec

const ec = new EC("p256");

export const influencerID = 1;
export const editionID = 1
export const serialNumber = 1
export const url = "https://yandex.ru/images/search?text=%D0%A1%D0%BE%D0%B1%D0%B0%D0%BA%D0%B0%20%D0%9A%D0%BE%D1%80%D0%B3%D0%B8&nl=1&source=morda&pos=2&img_url=https%3A%2F%2Fduckstories.net%2Fwp-content%2Fuploads%2F2020%2F08%2Fkorzhik-1536x1072.jpg&rpt=simage"

export const deployYUP = async () => {
	const YUPAdmin = await getYUPAdminAddress();
	await mintFlow(YUPAdmin, "10.0");

	await deployContractByName({to: YUPAdmin, name: "NonFungibleToken"});

	const addressMap = {NonFungibleToken: YUPAdmin};
	return deployContractByName({to: YUPAdmin, name: "YUP", addressMap});
};

export const setupYUPOnAccount = async (account) => {
	const name = "yup/setup_account";
	const signers = [account];

	return sendTransaction({name, signers});
};

export const createYUPAccount = async (flowKey, account) => {
	const name = "yup/create_account";
	const args = [await encodePublicKeyForFlow(await genKey())]
	const signers = [account];

	return sendTransaction({name, args, signers});
};

export const getYUPSupply = async () => {
	const name = "yup/get_yup_supply";

	return executeScript({name});
};
export const mintYUP = async (influencerID, editionID, serialNumber, url, recipient) => {
	const YUPAdmin = await getYUPAdminAddress();

	const name = "yup/mint_yup";
	const args = [recipient, influencerID, editionID, serialNumber, url];
	const signers = [YUPAdmin];

	return sendTransaction({name, args, signers});
};


export const transferYUP = async (sender, recipient, itemId) => {
	const name = "yup/transfer_yup";
	const args = [recipient, itemId];
	const signers = [sender];

	return sendTransaction({name, args, signers});
};


export const getYUP = async (account, itemID) => {
	const name = "yup/get_yup";
	const args = [account, itemID];

	return executeScript({name, args});
};


export const getYUPCount = async (account) => {
	const name = "yup/get_collection_length";
	const args = [account];

	return executeScript({name, args});
};

const genKey = async () => {
	const keys = ec.genKeyPair()
	const publicKey = keys.getPublic('hex').replace(/^04/, '')
	return publicKey
}

const encodePublicKeyForFlow = async (publicKey) => {
	return rlp.encode([Buffer.from(publicKey, 'hex'), 2, 3, 1000]).toString('hex')
}
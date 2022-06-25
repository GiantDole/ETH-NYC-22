"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const nft_storage_1 = require("nft.storage");
const web3_storage_1 = require("web3.storage");
const mime_1 = __importDefault(require("mime"));
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
//
//---------------------------------Using web3.storage from here--------------------------------------------
//
function getAccessTokenWeb3Storage() {
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweGY2ZDU5MmM4OTcxMTNFQURkOEFhQzdBN0JGYjU4YjU3YzA5Mzk3Y0MiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2NTYxODAxNDQxMDUsIm5hbWUiOiJORlQgTllDIERlbW8ifQ.lhg2PyivAgees3IeojQ-cDDfpHRJ77JlSQQnUI2LdBM';
    //return process.env.WEB3STORAGE_TOKEN!
}
function makeStorageClient() {
    return new web3_storage_1.Web3Storage({ token: getAccessTokenWeb3Storage(), endpoint: new URL('https://api.web3.storage') });
}
/**
 * @title creates a file object from form input
 * @param obj a dictionary of the submitted form to be stored
 * @returns
 */
function makeFileObjects(obj) {
    const buffer = Buffer.from(JSON.stringify(obj));
    const files = [
        new nft_storage_1.File([buffer], 'data.json')
    ];
    return files;
}
/**
 * @title stores files in decentralized storage at web3.storage
 * @param files input files to store
 * @returns
 */
function storeFiles(files) {
    return __awaiter(this, void 0, void 0, function* () {
        const client = makeStorageClient();
        const cid = yield client.put(files);
        console.log('stored files with cid:', cid);
        return cid;
    });
}
/**
 * @title stores a form on web3storage. First creates a file object and then saves
 * @param obj dictionary of form fields and their value
 * @returns cid
 */
function storeForm(obj) {
    return __awaiter(this, void 0, void 0, function* () {
        var files = makeFileObjects(obj);
        return yield storeFiles(files);
    });
}
/**
 * @title retrieves stored data by cid
 * @param cid cid of stored data to retrieve
 * @returns stored data under entered cid
 */
function retrieve(cid) {
    return __awaiter(this, void 0, void 0, function* () {
        const client = makeStorageClient();
        const res = yield client.get(cid);
        console.log(`Got a response! [${res.status}] ${res.statusText}`);
        if (!res.ok) {
            throw new Error(`failed to get ${cid}`);
        }
        return res;
    });
}
//
//---------------------------------Using NFT.storage from here--------------------------------------------
//
function getAccessTokenNFTStorage() {
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDA0MTg1QjNjMzhjNGNmMjg5RjJlM0RFYzNDMTUwOTIzZWI0ZGRjNTkiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTY1NjE3MzIxMTQzNCwibmFtZSI6IkRFdmVudHMifQ.m_RwXa47mye6ewKYKaNUhEqMp5kaKdOZDzMN5xyq_BA';
    //return process.env.NFTSTORAGE_TOKEN!
}
/**
  * Reads an image file from `imagePath` and stores an NFT with the given name and description.
  * First, upload the file to the backend and then include the imagePath in this API call
  * Alternative to createMetadata()
  * @param {string} imagePath the path to an image file
  * @param {string} name a name for the NFT
  * @param {string} description a text description for the NFT
  * @param {dictionary} proprties a dictionary of additional metadata to include
  */
function storeNFT(imagePath, name, description, properties) {
    return __awaiter(this, void 0, void 0, function* () {
        // load the file from disk
        const image = yield fileFromPath(imagePath);
        // create a new NFTStorage client using our API key
        const nftstorage = new nft_storage_1.NFTStorage({ token: getAccessTokenNFTStorage() });
        // call client.store, passing in the image & metadata
        return nftstorage.store({
            image,
            name,
            description,
            properties
        });
    });
}
/**
  * A helper to read a file from a location on disk and return a File object.
  * Note that this reads the entire file into memory and should not be used for
  * very large files.
  * @param {string} filePath the path to a file to store
  * @returns {File} a File object containing the file content
  */
function fileFromPath(filePath) {
    return __awaiter(this, void 0, void 0, function* () {
        const content = yield fs_1.default.promises.readFile(filePath);
        const type = mime_1.default.getType(filePath);
        return new nft_storage_1.File([content], path_1.default.basename(filePath), { type });
    });
}
//# sourceMappingURL=storeData.js.map
import { NFTStorage, File } from "nft.storage";
import { Web3Storage} from 'web3.storage'
import mime from "mime";
import fs from "fs";
import path from "path";


//
//---------------------------------Using web3.storage from here--------------------------------------------
//

function getAccessTokenWeb3Storage() {
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweGY2ZDU5MmM4OTcxMTNFQURkOEFhQzdBN0JGYjU4YjU3YzA5Mzk3Y0MiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2NTYxODAxNDQxMDUsIm5hbWUiOiJORlQgTllDIERlbW8ifQ.lhg2PyivAgees3IeojQ-cDDfpHRJ77JlSQQnUI2LdBM'

    //return process.env.WEB3STORAGE_TOKEN!
}

function makeStorageClient () {
    return new Web3Storage({ token: getAccessTokenWeb3Storage(), endpoint: new URL('https://api.web3.storage') })
} 

/**
 * @title creates a file object from form input
 * @param obj a dictionary of the submitted form to be stored
 * @returns 
 */
function makeFileObjects (obj:any) {
    const buffer = Buffer.from(JSON.stringify(obj))
    const files = [
        new File([buffer], 'data.json')
    ]
    return files
}

/**
 * @title stores files in decentralized storage at web3.storage
 * @param files input files to store
 * @returns 
 */
async function storeFiles (files:File[]) {
    const client = makeStorageClient()
    const cid = await client.put(files)
    console.log('stored files with cid:', cid)
    return cid
    }

/**
 * @title stores a form on web3storage. First creates a file object and then saves
 * @param obj dictionary of form fields and their value
 * @returns cid
 */
async function storeForm(obj:any) {
    var files = makeFileObjects(obj);
    return await storeFiles(files);
}

/**
 * @title retrieves stored data by cid
 * @param cid cid of stored data to retrieve
 * @returns stored data under entered cid
 */
async function retrieve (cid:string) {
    const client = makeStorageClient()
    const res = await client.get(cid)
    console.log(`Got a response! [${res!.status}] ${res!.statusText}`)
    if (!res!.ok) {
        throw new Error(`failed to get ${cid}`)
    }
    
    return res;
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
 async function storeNFT(imagePath:string, name:string, description:string, properties:any) {
    // load the file from disk
    const image = await fileFromPath(imagePath)

    // create a new NFTStorage client using our API key
    const nftstorage = new NFTStorage({ token: getAccessTokenNFTStorage() })

    // call client.store, passing in the image & metadata
    return nftstorage.store({
        image,
        name,
        description,
        properties
    })
}

/**
  * A helper to read a file from a location on disk and return a File object.
  * Note that this reads the entire file into memory and should not be used for
  * very large files. 
  * @param {string} filePath the path to a file to store
  * @returns {File} a File object containing the file content
  */
 async function fileFromPath(filePath:string) {
    const content = await fs.promises.readFile(filePath)
    const type = mime.getType(filePath)!
    return new File([content], path.basename(filePath), { type })
}
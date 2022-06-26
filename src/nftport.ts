//import Web3 from "web3";

import axios from "axios";
import { NFTStorage, File } from "nft.storage";
import { Web3Storage, getFilesFromPath } from 'web3.storage'
import mime from "mime";
import fs from "fs";
import path from "path";
const FormData = require('form-data');


//import dotenv from "dotenv";
require("dotenv").config;
const Web3 = require("web3");
const web3_utils = require('web3-utils');
const HDWalletProvider = require("@truffle/hdwallet-provider");

const POLYGON_NETWORK = "rinkeby"
const INFURA_PROJECT_ID = "3731edea87c143b5b50500ff7a591cc7"
const SIGNER_PRIVATE_KEY = "0x40f8113b359c2514a12b515d4a5c8be16d3dd35cefbf778a88ddd06dd04f82c6"
const mnemonic = "maple path spot chaos present sick citizen item example valley dentist add";
const nft_contract_address = "0x6840a21b5a83dd3e9724ccd3636c3ed92799cc43";
const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";
const AUTH_KEY = "687aadce-8f40-45f7-910a-60c865f38bce";
const NFT_STORAGE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDA0MTg1QjNjMzhjNGNmMjg5RjJlM0RFYzNDMTUwOTIzZWI0ZGRjNTkiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTY1NjE3MzIxMTQzNCwibmFtZSI6IkRFdmVudHMifQ.m_RwXa47mye6ewKYKaNUhEqMp5kaKdOZDzMN5xyq_BA";
const Web3_STORAGE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweGY2ZDU5MmM4OTcxMTNFQURkOEFhQzdBN0JGYjU4YjU3YzA5Mzk3Y0MiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2NTYxODAxNDQxMDUsIm5hbWUiOiJORlQgTllDIERlbW8ifQ.lhg2PyivAgees3IeojQ-cDDfpHRJ77JlSQQnUI2LdBM";
const chain = "polygon";
//const mnemonic = "twist scorpion knock sponsor blade bless grocery enforce alley liar prize prepare";
async function test() {
  // Configuring the connection to the Polygon node
  //const network = process.env.POLYGON_NETWORK;
  let infura = `https://${POLYGON_NETWORK}.infura.io/v3/${INFURA_PROJECT_ID}`;
  let ganache = "http://127.0.0.1:7545";

  let provider = new HDWalletProvider(mnemonic,infura);

  const web3 = new Web3(provider);
  
  const address = web3.currentProvider.addresses[0];

  console.log(address);

  web3.eth.getBalance(address, function(error:any, balance:BigInt){
    if(!error){
        //console.log(web3_utils.fromWei(balance));
        console.log(balance.toString());

    } else {
        console.log(error);
    }
})
}

function getAccessToken() {
    // If you're just testing, you can paste in a token
    // and uncomment the following line:
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweGY2ZDU5MmM4OTcxMTNFQURkOEFhQzdBN0JGYjU4YjU3YzA5Mzk3Y0MiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2NTYxODAxNDQxMDUsIm5hbWUiOiJORlQgTllDIERlbW8ifQ.lhg2PyivAgees3IeojQ-cDDfpHRJ77JlSQQnUI2LdBM'
  
    // In a real app, it's better to read an access token from an
    // environement variable or other configuration that's kept outside of
    // your code base. For this to work, you need to set the
    // WEB3STORAGE_TOKEN environment variable before you run your code.
    //return process.env.WEB3STORAGE_TOKEN!
  }

function makeStorageClient () {
    return new Web3Storage({ token: getAccessToken(), endpoint: new URL('https://api.web3.storage') })
  }

  async function getFiles (path:string) {
    const files = await getFilesFromPath(path)
    console.log(`read ${files.length} file(s) from ${path}`)
    return files
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

  async function storeFiles (files:File[]) {
    const client = makeStorageClient()
    const cid = await client.put(files)
    console.log('stored files with cid:', cid)
    return cid
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
    const nftstorage = new NFTStorage({ token: NFT_STORAGE_KEY })

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


//TODO hier file input
//TODO ipfs_url aus response (is dictionary)
function createMetadata(_file:File, _name:string, _description:string, _properties:any) {

    var formData = new FormData();
    formData.append("file", _file);
    axios.post("upload_file", formData, {
        method: "post",
        url: "https://api.nftport.xyz/v0/files",
        headers: {
            "Authorization": AUTH_KEY,
            "Content-Type": "multipart/form-data",
            "content-type": "content-type: multipart/form-data; boundary=---011000010111000001101001"
        }
    }).then(function(response){
        axios({
            method: "post",
            url: "https://api.nftport.xyz/v0/metadata",
            headers: {"Authorization": AUTH_KEY},
            data: {
                "name": _name,
                "description": _description,
                "properties": _properties,
                "file_url": response.ipfs_url
            }
        }).then(function (response) {
            return response;
          })
          .catch(function (error) {
            console.log(error);
            return;
          });
    })


}

/**
 * @title create a new event by minting an erc721 event NFT
 * @param _name The event name
 * @param _symbol The event symbol
 * @param _owner The event owner
 */
//TODO: correct input format _owner
async function mintEventNFT751(_name:string, _symbol:string, _owner:string, _chain:string) {
    const options = {
    method: 'POST',
    url: 'https://api.nftport.xyz/v0/contracts',
    headers: {
        'Content-Type': 'application/json',
        Authorization: AUTH_KEY
    },
    data: {
        chain: _chain,
        name: _name,
        symbol: _symbol,
        owner_address: _owner,
        metadata_updatable: false,
        type: 'erc721',
        roles: [{role: 'mint', addresses: [owner_address, _owner], freeze: false}]
    }
    };
    
    const ret = await axios.request(options).then(function (response) {
    return response.data;
    }).catch(function (error) {
    console.error(error);
    });

    return ret;
}

/**
 * @title create a new event by minting an erc1155 event NFT
 * @param _name The event name
 * @param _symbol The event symbol
 * @param _owner The event owner
 */
//TODO: correct input format _owner
async function mintEventNFT1155(_name:string, _symbol:string, _owner:string, _chain:string) {
    const options = {
    method: 'POST',
    url: 'https://api.nftport.xyz/v0/contracts',
    headers: {
        'Content-Type': 'application/json',
        Authorization: AUTH_KEY
    },
    data: {
        chain: _chain,
        name: _name,
        symbol: _symbol,
        owner_address: _owner,
        metadata_updatable: false,
        type: 'erc721',
        roles: [{role: 'mint', addresses: [owner_address, _owner], freeze: false}]
    }
    };
    
    const ret = await axios.request(options).then(function (response) {
    return response.data;
    }).catch(function (error) {
    console.error(error);
    });

    return ret;
}

/**
 * @title mint a new ticket on an existing event ERC1155 NFT
 * @param _metadata_uri after creating a metadata link fo the file, the NFT can be minted with the URI
 * @param _address the address the NFT should be minted to
 * @param _event_contract the event NFT contract address
 * @param _token_id an id for the ticket type in this particular event
 * @param _quantity a preset number of tickets available for this ticket type
 * @dev TODO: conditional NFT ticket minting
 */
 async function mintTicketType(_metadata_uri:string, _address:string, _event_contract:string, _token_id:string, _quantity:string) {
    const options = {
        method: 'POST',
        url: 'https://api.nftport.xyz/v0/mints/customizable/batch',
        headers: {
          'Content-Type': 'application/json',
          Authorization: AUTH_KEY
        },
        data: {
          chain: chain,
          contract_address: _event_contract,
          tokens: [
            {
              mint_to_address: _address,
              token_id: _token_id,
              metadata_uri: _metadata_uri,
              quantity: _quantity
            }
          ]
        }
      };
      
      let ret = await axios.request(options).then(function (response) {
        return response.data;
      }).catch(function (error) {
        console.error(error);
      });

      return ret;
}

/**
 * @title mint a new ticket on an existing event ERC721 NFT
 * @param _metadata_uri after creating a metadata link fo the file, the NFT can be minted with the URI
 * @param _address the address the NFT should be minted to
 * @param _event_contract the event NFT contract address
 * @dev TODO: conditional NFT ticket minting
 */
async function mintNFT(_metadata_uri:string, _address:string, _event_contract:string) {
      const options = {
        method: 'POST',
        url: 'https://api.nftport.xyz/v0/mints/customizable',
        headers: {
          'Content-Type': 'application/json',
          Authorization: AUTH_KEY
        },
        data: {
          chain: chain,
          contract_address: _event_contract,
          metadata_uri: _metadata_uri,
          mint_to_address: _address
        }
      };
      
      const ret = await axios.request(options).then(function (response) {
        return response.data;
      }).catch(function (error) {
        console.error(error);
      });

      return ret;
}

/**
 * @title get the details of a ticket
 * @param _contract_address the contract address of the event
 * @param _token_id the token id of the ticket
 */
//nft.file_url contains the url to the nft picture
async function getTicketDetails(_contract_address:string, _token_id:string) {

    const options = {
    method: 'GET',
    url: `https://api.nftport.xyz/v0/nfts/${_contract_address}/${_token_id}`,
    params: {chain: chain, refresh_metadata: 'false'},
    headers: {
        'Content-Type': 'application/json',
        Authorization: AUTH_KEY
    }
    };
    
    const ret = await axios.request(options).then(function (response) {
        return response.data;
    }).catch(function (error) {
        console.error(error);
    });

    return ret;
}

/**
 * @title get all tickets of an event
 * @param _contract_address the Event contract address you want to retrieve all tickets from
 */
async function getAllTickets(_contract_address:string){
      const options = {
        method: 'GET',
        url: `https://api.nftport.xyz/v0/nfts/${_contract_address}`,
        params: {chain: chain, refresh_metadata: 'false'},
        headers: {
          'Content-Type': 'application/json',
          Authorization: AUTH_KEY
        }
      };
      
      const ret = await axios.request(options).then(function (response) {
        return response.data;
      }).catch(function (error) {
        console.error(error);
      });

      return ret;
}

async function transferTicket(_contract_address:string, _token_id:string, _target_address:string) {
    const options = {
        method: 'POST',
        url: 'https://api.nftport.xyz/v0/mints/transfers',
        headers: {
          'Content-Type': 'application/json',
          Authorization: AUTH_KEY
        },
        data: {
          chain: chain,
          contract_address: _contract_address,
          token_id: _token_id,
          transfer_to_address: _target_address
        }
      };
      
      let ret = await axios.request(options).then(function (response) {
        return response.data;
      }).catch(function (error) {
        console.error(error);
      });

      return ret;
}

/**
 * @title gets all the event nfts this address has created
 * @param _address the address to be queried
 * @returns 
 */
async function getCreatedEvents(_address:string) {
    const options = {
        method: 'GET',
        url: `https://api.nftport.xyz/v0/accounts/contracts/${_address}`,
        params: {chain: chain, type: 'owns_contract_nfts'},
        headers: {
          'Content-Type': 'application/json',
          Authorization: AUTH_KEY
        }
      };
      
      let ret = await axios.request(options).then(function (response) {
        return response.data;
      }).catch(function (error) {
        console.error(error);
      });

      return ret;
}

async function getOwnedTickets(_address:string){
    const options = {
        method: 'GET',
        url: `https://api.nftport.xyz/v0/accounts/${_address}`,
        params: {chain: chain},
        headers: {
          'Content-Type': 'application/json',
          Authorization: AUTH_KEY
        }
      };
      
      let ret = await axios.request(options).then(function (response) {
        return response.data;
      }).catch(function (error) {
        console.error(error);
      });

      return ret;
}


async function mainGET() {

    //Get all tickets (tokens) of an event NFT
    var responseOne = await getAllTickets(nft_contract_address);

    //Get details of the first ticket (token) of the requested event NFT
    var responseTwo = await getTicketDetails(responseOne.nfts[0].contract_address, responseOne.nfts[0].token_id);
    console.log(responseTwo);
}

async function mainPOST() {
    var responseOne = await mintEventNFT751("test", "test", owner_address, "rinkeby");
    console.log(responseOne);
}

async function main() {
    //var responseOne = await transferTicket("0x6840a21b5a83dd3e9724ccd3636c3ed92799cc43", "253276539733843594746", owner_address);
    var response = await getOwnedTickets("0x43b812d1c204ab9df3b863b8e72dc196aa50c3d1");
    console.log(response);
}

//main();
//console.log(storeForm());

async function storeForm() {
    const obj = {
        name: "Test",
        description: "Test"
    }

    var files = makeFileObjects(obj);
    return await storeFiles(files);
}

async function retrieve (cid:string) {
    const client = makeStorageClient()
    const res = await client.get(cid)
    console.log(`Got a response! [${res!.status}] ${res!.statusText}`)
    if (!res!.ok) {
      throw new Error(`failed to get ${cid}`)
    }
  
    return res;
  }

//dotenv.config();
//mainGET();
//mainGET();


//const content = fs.readFileSync("C:/Users/Adrian/Downloads/Marc.jpeg");
//const file:File = await fs.readFile('./my-image.jpg');
//const file:File = new File([content], "Marc.jpeg", {type: "image/jpeg"});
//console.log(createMetadata(content,"Marc's Face #2","Another interpretation of Marc's face!"));

async function somewhatmain() {
    let ret = await storeNFT("C:/Users/Adrian/Downloads/marc.jpeg", "Test", "This is a test", {"TestKey1": "Value1", "TestKey2": "Value2"});
    console.log(ret);
    return ret;
}

somewhatmain();

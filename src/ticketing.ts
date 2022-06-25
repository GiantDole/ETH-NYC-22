import axios from "axios";
import mime from "mime";
import fs from "fs";
import path from "path";
import { NFTStorage } from "nft.storage";
const FormData = require('form-data');

const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";
const NFT_STORAGE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDA0MTg1QjNjMzhjNGNmMjg5RjJlM0RFYzNDMTUwOTIzZWI0ZGRjNTkiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTY1NjE3MzIxMTQzNCwibmFtZSI6IkRFdmVudHMifQ.m_RwXa47mye6ewKYKaNUhEqMp5kaKdOZDzMN5xyq_BA";
const AUTH_KEY = "687aadce-8f40-45f7-910a-60c865f38bce";
const chain = "polygon";


//
//---------------------------------Using NFTPort to manage ticketing--------------------------------------------
//


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
function createMetadata(_file:File, _name:string, _description:string) {

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
                //"file_url": response.ipfs_url
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

//
//---------------------------------Using NFT.storage to upload files and metadata--------------------------------------------
//

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
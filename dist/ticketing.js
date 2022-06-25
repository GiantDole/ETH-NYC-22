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
const axios_1 = __importDefault(require("axios"));
const mime_1 = __importDefault(require("mime"));
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
const FormData = require('form-data');
const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";
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
function fileFromPath(filePath) {
    return __awaiter(this, void 0, void 0, function* () {
        const content = yield fs_1.default.promises.readFile(filePath);
        const type = mime_1.default.getType(filePath);
        return new File([content], path_1.default.basename(filePath), { type });
    });
}
//TODO hier file input
//TODO ipfs_url aus response (is dictionary)
function createMetadata(_file, _name, _description) {
    var formData = new FormData();
    formData.append("file", _file);
    axios_1.default.post("upload_file", formData, {
        method: "post",
        url: "https://api.nftport.xyz/v0/files",
        headers: {
            "Authorization": AUTH_KEY,
            "Content-Type": "multipart/form-data",
            "content-type": "content-type: multipart/form-data; boundary=---011000010111000001101001"
        }
    }).then(function (response) {
        (0, axios_1.default)({
            method: "post",
            url: "https://api.nftport.xyz/v0/metadata",
            headers: { "Authorization": AUTH_KEY },
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
    });
}
/**
 * @title create a new event by minting an erc721 event NFT
 * @param _name The event name
 * @param _symbol The event symbol
 * @param _owner The event owner
 */
//TODO: correct input format _owner
function mintEventNFT751(_name, _symbol, _owner, _chain) {
    return __awaiter(this, void 0, void 0, function* () {
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
                roles: [{ role: 'mint', addresses: [owner_address, _owner], freeze: false }]
            }
        };
        const ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
}
/**
 * @title create a new event by minting an erc1155 event NFT
 * @param _name The event name
 * @param _symbol The event symbol
 * @param _owner The event owner
 */
//TODO: correct input format _owner
function mintEventNFT1155(_name, _symbol, _owner, _chain) {
    return __awaiter(this, void 0, void 0, function* () {
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
                roles: [{ role: 'mint', addresses: [owner_address, _owner], freeze: false }]
            }
        };
        const ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
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
function mintTicketType(_metadata_uri, _address, _event_contract, _token_id, _quantity) {
    return __awaiter(this, void 0, void 0, function* () {
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
        let ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
}
/**
 * @title mint a new ticket on an existing event ERC721 NFT
 * @param _metadata_uri after creating a metadata link fo the file, the NFT can be minted with the URI
 * @param _address the address the NFT should be minted to
 * @param _event_contract the event NFT contract address
 * @dev TODO: conditional NFT ticket minting
 */
function mintNFT(_metadata_uri, _address, _event_contract) {
    return __awaiter(this, void 0, void 0, function* () {
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
        const ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
}
/**
 * @title get the details of a ticket
 * @param _contract_address the contract address of the event
 * @param _token_id the token id of the ticket
 */
//nft.file_url contains the url to the nft picture
function getTicketDetails(_contract_address, _token_id) {
    return __awaiter(this, void 0, void 0, function* () {
        const options = {
            method: 'GET',
            url: `https://api.nftport.xyz/v0/nfts/${_contract_address}/${_token_id}`,
            params: { chain: chain, refresh_metadata: 'false' },
            headers: {
                'Content-Type': 'application/json',
                Authorization: AUTH_KEY
            }
        };
        const ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
}
/**
 * @title get all tickets of an event
 * @param _contract_address the Event contract address you want to retrieve all tickets from
 */
function getAllTickets(_contract_address) {
    return __awaiter(this, void 0, void 0, function* () {
        const options = {
            method: 'GET',
            url: `https://api.nftport.xyz/v0/nfts/${_contract_address}`,
            params: { chain: chain, refresh_metadata: 'false' },
            headers: {
                'Content-Type': 'application/json',
                Authorization: AUTH_KEY
            }
        };
        const ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
}
function transferTicket(_contract_address, _token_id, _target_address) {
    return __awaiter(this, void 0, void 0, function* () {
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
        let ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
}
/**
 * @title gets all the event nfts this address has created
 * @param _address the address to be queried
 * @returns
 */
function getCreatedEvents(_address) {
    return __awaiter(this, void 0, void 0, function* () {
        const options = {
            method: 'GET',
            url: `https://api.nftport.xyz/v0/accounts/contracts/${_address}`,
            params: { chain: chain, type: 'owns_contract_nfts' },
            headers: {
                'Content-Type': 'application/json',
                Authorization: AUTH_KEY
            }
        };
        let ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
}
function getOwnedTickets(_address) {
    return __awaiter(this, void 0, void 0, function* () {
        const options = {
            method: 'GET',
            url: `https://api.nftport.xyz/v0/accounts/${_address}`,
            params: { chain: chain },
            headers: {
                'Content-Type': 'application/json',
                Authorization: AUTH_KEY
            }
        };
        let ret = yield axios_1.default.request(options).then(function (response) {
            return response.data;
        }).catch(function (error) {
            console.error(error);
        });
        return ret;
    });
}
//# sourceMappingURL=ticketing.js.map
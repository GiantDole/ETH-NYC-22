import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart';
import 'package:universal_html/html.dart';

class NFTPortRepository {
  final AUTH_KEY = "687aadce-8f40-45f7-910a-60c865f38bce";
  final owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

/**
 * @title create a new event by minting an erc1155 event NFT
 * @param _name The event name
 * @param _symbol The event symbol
 * @param _owner The event owner
 */
  mintEventNFT1155(
      String _name, String _symbol, String _owner, String _chain) async {
    String url = 'https://api.nftport.xyz/v0/contracts';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': AUTH_KEY
    };
    var body = jsonEncode({
      "chain": _chain,
      "name": _name,
      "symbol": _symbol,
      "owner_address": _owner,
      "metadata_updatable": false,
      "type": 'erc1155',
      "roles": [
        {
          "role": 'mint',
          "addresses": [owner_address, _owner],
          "freeze": false
        }
      ]
    });

    Response res = await post(Uri.parse(url), body: body, headers: headers);

    var response = jsonDecode(res.body);
    String transaction_hash = response["transaction_hash"];

    if (res.statusCode == 200) {
      return getContractAddress(transaction_hash, "polygon");
      // return res.body;
    } else {
      print(res.body);
      throw "Unable to retrieve posts.";
    }
  }

  getContractAddress(String _tx_hash, String _chain) async {
    String url =
        "https://api.nftport.xyz/v0/contracts/${_tx_hash}?chain=${_chain}";

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': AUTH_KEY
    };
    Response res = await get(Uri.parse(url), headers: headers);
    print(res);
    // print(res.contract_address)
    return res;
  }

  getTicketDetails(String _contract_address, String _token_id) async {
    String url = 'https://api.nftport.xyz/v0/contracts';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': AUTH_KEY
    };

    var body = jsonEncode({"chain": "polygon", "refresh_metadata": 'false'});

    Response res = await post(Uri.parse(url), body: body, headers: headers);

    if (res.statusCode == 200) {
      return res.body;
    } else {
      print(res.body);
      throw "Unable to retrieve posts.";
    }
  }

/**
 * @title mint a new ticket on an existing event ERC721 NFT
 * @param _metadata_uri after creating a metadata link fo the file, the NFT can be minted with the URI
 * @param _address the address the NFT should be minted to
 * @param _event_contract the event NFT contract address
 * @dev TODO: conditional NFT ticket minting
 */
  mintNFT(String _metadata_uri, String _address, String _event_contract) async {
    String url = 'https://api.nftport.xyz/v0/mints/customizable';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': AUTH_KEY
    };

    var body = jsonEncode({
      "chain": "polygon",
      "contract_address": _event_contract,
      "metadata_uri": _metadata_uri,
      "mint_to_address": _address
    });

    Response res = await post(Uri.parse(url), body: body, headers: headers);

    if (res.statusCode == 200) {
      return res.body;
    } else {
      print(res.body);
      throw "Unable to retrieve posts.";
    }
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
  mintTicketType(String _metadata_uri, String _address, String _event_contract,
      String _token_id, String _quantity) async {
    String url = 'https://api.nftport.xyz/v0/mints/customizable/batch';

    String chain = "polygon";

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': AUTH_KEY
    };

    var body = jsonEncode({
      "chain": chain,
      "contract_address": _event_contract,
      "tokens": [
        {
          "metadata_uri": _metadata_uri,
          "mint_to_address": _address,
          "token_id": _token_id,
          "quantity": _quantity
        }
      ]
    });

    Response res = await post(Uri.parse(url), body: body, headers: headers);

    if (res.statusCode == 200) {
      return res.body;
    } else {
      print(res.body);
      throw "Unable to retrieve posts.";
    }
  }

  Future<dynamic> createMetadata(
      io.File _file, String _name, String _description) async {
    String url = "https://api.nftport.xyz/v0/files";
    String chain = "polygon";

    print("creating Metadata...");

    var headers = {
      'Content-Type': 'application/json',
      "content-type":
          "content-type: multipart/form-data; boundary=---011000010111000001101001",
      'Authorization': AUTH_KEY
    };

    final Completer<String> c = new Completer<String>();
    var request = MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(MultipartFile(
        'file', _file.readAsBytes().asStream(), _file.lengthSync(),
        filename: "test-file"));

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      print("finished creating Metadata");
      print(value);
      var value_json = jsonDecode(value);

      var headers = {
        'Content-Type': 'application/json', // ?? Adrian vergessen
        'Authorization': AUTH_KEY
      };

      var body = jsonEncode({
        "name": _name,
        "description": _description,
        "file_url": value_json["ipfs_url"]
      });
      print("uploading Metadata...");
      String url = "https://api.nftport.xyz/v0/metadata";
      Response res = await post(Uri.parse(url), body: body, headers: headers);
      print("finished uploading Metadata");

      print(res.body);

      c.complete(res.body);
    });

    return c.future;
  }
}

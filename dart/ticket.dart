createEventTicketingNFT(
    String _name, String _symbol, String _owner, String _chain) async {
  String url = 'https://api.nftport.xyz/v0/contracts';

  const AUTH_KEY = "687aadce-8f40-45f7-910a-60c865f38bce";
  const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

  var headers = {'Content-Type': 'application/json', 'Authorization': AUTH_KEY};
  var body = {
    'chain': _chain,
    'name': _name,
    'symbol': _symbol,
    'owner_address': _owner,
    'metadata_updatable': false,
    'type': 'erc1155',
    'roles': [
      {
        'role': 'mint',
        'addresses': [owner_address, _owner],
        'freeze': false
      }
    ]
  };

  Response res = await post(Uri.parse(url), body: body, headers: headers);

  if (res.statusCode == 200) {
    return res.body;
  } else {
    throw "Unable to retrieve posts.";
  }
}

createMetaData(

) async {
  String url = 'https://api.nftport.xyz/v0/mints/customizable/batch';

  const AUTH_KEY = "687aadce-8f40-45f7-910a-60c865f38bce";
  const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

  var headers = {'Content-Type': 'application/json', 'Authorization': AUTH_KEY};
  var body = {
    'chain': "polygon",
    'contract_address': _contract_address,
    'tokens': [
      {
        'mint_to_address': _owner,
        'token_id': _token_id,
        'metadata_uri': _metadata_uri,
        'quantity': _quantity
      }
    ]
  };

  Response res = await post(Uri.parse(url), body: body, headers: headers);

  if (res.statusCode == 200) {
    return res.body;
  } else {
    throw "Unable to retrieve posts.";
  }
}

createTicketType(String _contract_address, String _owner, String _token_id,
    String _metadata_uri, String _quantity) async {
  String url = 'https://api.nftport.xyz/v0/mints/customizable/batch';

  const AUTH_KEY = "687aadce-8f40-45f7-910a-60c865f38bce";
  const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

  var headers = {'Content-Type': 'application/json', 'Authorization': AUTH_KEY};
  var body = {
    'chain': "polygon",
    'contract_address': _contract_address,
    'tokens': [
      {
        'mint_to_address': _owner,
        'token_id': _token_id,
        'metadata_uri': _metadata_uri,
        'quantity': _quantity
      }
    ]
  };

  Response res = await post(Uri.parse(url), body: body, headers: headers);

  if (res.statusCode == 200) {
    return res.body;
  } else {
    throw "Unable to retrieve posts.";
  }
}

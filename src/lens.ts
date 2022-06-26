
exports.testLensAuth = functions.https.onCall(async (data, context) =>  {

    var web3 = new Web3('http://localhost:8545'); // your geth
    var acc = web3.eth.accounts.create();
    const address = acc.address;
    
    const result = await _lens_authenticate(address, acc.sign)
    
      return {
        accessToken: result.accessToken,
        refreshToken: result.refreshToken
      }
    });
    
    exports.testLensAuth = functions.https.onCall(async (data, context) =>  {
    
      return _lens_authenticate
    });
    
    async function _lens_authenticate(address:any, sign:any){
    
      const APIURL = 'https://api-mumbai.lens.dev/';
    
      const GET_CHALLENGE = `
      query($request: ChallengeRequest!) {
        challenge(request: $request) { text }
      }`
      
      const get_challenge = await axios.post(APIURL, {
        headers: {
          "Content-Type": "application/json",
        },
        query: GET_CHALLENGE,
        variables: {
          request: { address: address },
        },
      });
    
    console.log("received challenge")
    const challenge= get_challenge.data.data.challenge.text
    const signed_msg = sign(challenge)
    const signature = signed_msg.signature
    console.log("signed challenge")
    
    
      const AUTHENTICATION = `
      mutation($request: SignedAuthChallenge!) { 
        authenticate(request: $request) {
          accessToken
          refreshToken
        }
     }
    `
    console.log("waiting for access token")
    
     const result = await axios.post(
       APIURL,{
        headers: {
          "Content-Type": "application/json",
        },
      query: AUTHENTICATION,
      variables: {
        request: {
          address: address,
          signature:signature
        },
      },
    });
    
    console.log("access token: "+result.data.data.authenticate.accessToken)
    
    
    return {
      accessToken: result.data.data.authenticate.accessToken,
      refreshToken: result.data.data.authenticate.refreshToken
    }
    
    
    }
    
    exports.test_lens_create_profile = functions.https.onCall(async (data, context) =>  {
    
    console.log("creating new wallet...")
    var web3 = new Web3('http://localhost:8545'); // your geth
    var acc = web3.eth.accounts.create();
    const address = acc.address;
    
    console.log("authenticating...")
    
    const auth_result = await _lens_authenticate(address, acc.sign)
    
    return _lens_create_profile(auth_result.accessToken)
    
    });
    
    exports.lens_create_profile = functions.https.onCall(async (data, context) =>  {
    
      return _lens_create_profile(data.token);
    
    })
    
    async function _lens_create_profile(token:any)  {
      const APIURL = 'https://api-mumbai.lens.dev/';
      console.log(token)
    
    
      const query = `mutation CreateProfile {
        createProfile(request:{ 
                      handle: "marciboy4201",
                      profilePictureUri: null,
                      followNFTURI: null,
                      followModule: null
                      }) {
          ... on RelayerResult {
            txHash
          }
          ... on RelayError {
            reason
          }
          __typename
        }
      }`
      
      const result = await axios.post(
        APIURL,{
         headers: {
           "Content-Type": "application/json",
           'x-access-token': `Bearer ${token}`
    
         },
       query: query,
      
     });
    
     console.log(result.data)
     console.log(result.data.errors)
    
     const logs = result.data.txReceipt.logs;
     
     const topicId = utils.id(
      'ProfileCreated(uint256,address,address,string,string,address,bytes,string,uint256)'
     );
    
    
     const profileCreatedLog = logs.find((l: any) => l.topics[0] === topicId);
     console.log('profile created log', profileCreatedLog);
    
     let profileCreatedEventLog = profileCreatedLog.topics;
     console.log('profile created event logs', profileCreatedEventLog);
    
     const profileId = utils.defaultAbiCoder.decode(['uint256'], profileCreatedEventLog[1])[0];
    
     console.log('profile id', BigNumber.from(profileId).toHexString());
    
    
     return {message:"OK",
      profileId:profileId
    }
    
    }
    
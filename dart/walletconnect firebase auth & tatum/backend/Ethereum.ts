import { gql } from "apollo-server-express";
import { Context } from "../types";
import { Session } from "neo4j-driver";
import * as admin from "firebase-admin";
import { recoverPersonalSignature } from "@metamask/eth-sig-util";
export const typeDefs = gql`
  type Mutation {
    getNonceToSign(address: String!): String!

    verifySignedMessage(address: String!, signature: String!): String!

  }

`;

export const mutationResolvers = {
  getNonceToSign,
  verifySignedMessage,
};

export const queryResolvers = {};

export interface GetNonceToSignArgs {
  address: string;
}

async function getNonceToSign(
  _root: any,
  args: GetNonceToSignArgs,
  context: Context
) {
  console.log(args);
  try {
    if (!args.address) {
      console.log("Error: Wrong Data");
      throw new Error("Wrong Data");
    }

    // Get the user document for that address
    const User = context.ogm.model("User");
    const userSelectionSet = `
    {
  
        __typename
        id
        ethNounce
        ethWalletAddress
      
    }`;

    const [user] = await User.find({
      selectionSet: userSelectionSet,
      where: {
        ethWalletAddress: args.address,
      },
    })
      .then((resp: any) => {
        console.log(resp);
        return resp;
      })
      .catch(async (e: any) => console.log(e));

    if (user != null) {
      // The user document exists already, so just return the nonce
      console.log("Returning data: " + user.ethNounce);
      return `0x${toHex(user.ethNounce)}`;
    } else {
      // The user document does not exist, create it first
      const generatedNonce = Math.floor(Math.random() * 1000000).toString();
      // Create an Auth user
      console.log("Creating user");
      const createdUser: admin.auth.UserRecord = await admin
        .auth()
        .createUser({});
      // Associate the nonce with that user

      //Create Neo4J Session
      const session: Session = context.driver.session();

      const res = await session
        .run(
          "MERGE (e: User {id: $userID}) SET e.ethNounce = $ethNounce SET e.ethWalletAddress = $ethWalletAddress return e",
          {
            userID: createdUser.uid,
            ethNounce: generatedNonce,
            ethWalletAddress: args.address,
          }
        )
        .catch((error) => {
          console.log(error);
        });
      //Close Session
      session.close();

      // const [users] = await User.update({
      //   selectionSet: userSelectionSet,
      //   where: { id: createdUser.uid },
      //   update: {
      //     ethNounce: generatedNonce,
      //   },
      // })
      //   .then((resp: any) => resp)
      //   .catch(async (e: any) => console.log(e));

      if(res != undefined && res.records[0] != undefined){
        console.log("Res: " + JSON.stringify(res));
      const singleRecord = res.records[0];
      console.log("singleRecord: " + JSON.stringify(singleRecord));
    
        
        const node = singleRecord.get(0);
        console.log("node: " + JSON.stringify(node));

      console.log("Success: Added Nounce to user " + node.id);

      console.log("Returning data: " + node.ethNounce);

      return `0x${toHex(generatedNonce)}`; //TODO

      }else{
        throw new Error("Could not set nounce");
      }

    }
  } catch (err) {
    console.log(err);
    throw new Error("Error");
  }
}

export interface VerifySignedMessageArgs {
  address: string;
  signature: string;
}

async function verifySignedMessage(
  _root: any,
  args: VerifySignedMessageArgs,
  context: Context
) {
  try {
    if (!args.address || !args.signature) {
      console.log("Error: Wrong Data");
      throw new Error("Wrong Data");
    }
    const address = args.address;
    const sig = args.signature;

    // Get the user document for that address
    const User = context.ogm.model("User");
    const userSelectionSet = `
     {
   
         __typename
         id
         ethNounce
         ethWalletAddress
       
     }`;

    const [user] = await User.find({
      selectionSet: userSelectionSet,
      where: {
        ethWalletAddress: args.address,
      },
    })
      .then((resp: any) => {
        console.log(resp);
        return resp;
      })
      .catch(async (e: any) => console.log(e));

    if (user != null) {
      const existingNonce = user.ethNounce;
      // Recover the address of the account used to create the given Ethereum signature.
      const recoveredAddress = recoverPersonalSignature({
        data: `0x${toHex(existingNonce)}`,
        signature: sig,
      });
      // See if that matches the address the user is claiming the signature is from
     if (recoveredAddress === address) {
        
        // The signature was verified - update the nonce to prevent replay attacks
        // update nonce
        const users = await User.update({
          selectionSet: userSelectionSet,
          where: { id: user.id },
          update: {
            ethNounce: Math.floor(Math.random() * 1000000).toString(),
          },
        })
          .then((resp: any) => {
            console.log(resp);
            return resp;
          } )
          .catch(async (e: any) => console.log(e));

        console.log("Success: Added Nounce to user " + user.id);
        // Create a custom token for the specified address
        const firebaseToken = await admin.auth().createCustomToken(user.id);

        // Return the token
        var resp = firebaseToken;
        console.log("Returning data: " + resp);
        return resp;
      } else {
        // The signature could not be verified
        console.log("Error: Signature could not be verified");
        throw new Error("Signature could not be verified");
      }
    } else {
      console.log("user doc does not exist");
      throw new Error("No User");
    }
  } catch (err) {
    console.log(err);
    throw new Error("Error");
  }
}

const toHex = (stringToConvert: string) =>
  stringToConvert
    .split("")
    .map((c) => c.charCodeAt(0).toString(16).padStart(2, "0"))
    .join("");

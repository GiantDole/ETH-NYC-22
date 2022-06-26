

### Table of Contents

[Polygon](#Polygon)

[WalletConnect](#WalletConnect)

[NFTPort](#NFTPort)

[IPFS & Filecoin](#Filecoin)

[Lens](#Lens)

---

<a name="Polygon"/></a>
### Polygon
All our event and social profiles NFTs are deployed on Polygon. When an event is created we mint an ERC1155, where each token id refers to a ticket type. Whenever a ticket type is created, the provided capacity of that ticket type is minted. 
Furthermore, as we incorporate Lens's social profiles, all the user data and activity is captured on Polygon. In the future, we intend to provide functionalities through social graph analytics, such as recommending events based on previously attended ones or connecting users more intentionally based on their experience, previous attended events (especially hackathons), and their success in those activites.

---

<a name="WalletConnect"/></a>
### WalletConnect
Wallet address is our new authentication method. We are extending the firebase auth module for flutter to create an OAUTH token from the ethereum wallet id and private key. Logging into our platform through WalletConnect allows for maximal flexibility of wallet types and services. To authenticate users for any critical functionality (such as buying a ticket, applying for a hackathon, etc.), we use WalletConnect to sign the transactions.
(dart/authentication/wallet_connect.dart)

---

<a name="NFTPort"/></a>
### NFTPort
NFTPort made our life at ETH NYC much easier. With simple API calls we're using NFTPort to upload files and metadata, mint new event and ticket NFTs, and retrieve data about an event or user. Without writing any contracts, we were able to set up the whole (sophisticated) NFT component of our project in no time! :)
(dart/ticketing/repository.dart)

---

<a name="Filecoin"/></a>
### Filecoin & IPFS
For each ticket type we require an image and metadata. We use NFT.storage to persist images for our NFT tickets and their metadata.
Furthermore, we want to store student data decentralized and with user-managed access-control. This allows students to, e.g., apply for hackathons or travel sponsorship while giving only the organizers viewing rights. Students can rest assured that their data is not sold. :) 
(dart/ticketing/repository.dart)

---

<a name="Lens"/></a>
### Lens

With lens we save user profiles on chain. Users can connect with their wallet and create a profile with lens. We implemented the challenge request and authentication process. (src/lens.ts)


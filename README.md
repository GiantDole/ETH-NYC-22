### Table of Contents

[Polygon](#Polygon)

[WalletConnect](#WalletConnect)

[NFTPort](#NFTPort)

[Filecoin](#Filecoin)

[Chainlink](#Chainlink)

---

<a name="Polygon"/></a>
### Polygon
All our event and social profiles NFTs are deployed on Polygon. When an event is created we mint an ERC1155, where each token id refers to a ticket type. Whenever a ticket type is created, the provided capacity of that ticket type is minted. 
Furthermore, as we incorporate Lens's social profiles, all the user data and activity is captured on Polygon. In the future, we intend to provide functionalities through social graph analytics, such as recommending events based on previously attended ones or connecting users more intentionally based on their experience, previous attended events (especially hackathons), and their success in those activites.

---

<a name="WalletConnect"/></a>
### WalletConnect
Wallet address is our new user id. Logging into our platform through WalletConnect allows for maximal flexibility of wallet types and services. To authenticate users for any critical functionality (such as buying a ticket, applying for a hackathon, etc.), we use WalletConnect to sign the transactions.

---

<a name="NFTPort"/></a>
### NFTPort
NFTPort made our life at NFT NYC much easier. With simple API calls we're using NFTPort to upload files and metadata, mint new event and ticket NFTs, and retrieve data about an event or user. 

---

<a name="Filecoin"/></a>
### Filecoin / IPFS

---

<a name="Chainlink"/></a>
### Chainlink

---


NPM packages:
- Web3
- dotenv (securely store private keys in frontend)

Functions:
- buyTicket
- createTicket
- createEventTickets
- checkPosessiom

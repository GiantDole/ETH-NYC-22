"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const privy_node_1 = require("@privy-io/privy-node");
const client = new privy_node_1.PrivyClient(process.env.PRIVY_API_KEY, process.env.PRIVY_API_SECRET);
const session = new PublicSession(apiKey, PRIVY_API_KEY);
const client = new privy_node_1.PrivyClient({
    session: session,
});
//# sourceMappingURL=encryptData.js.map
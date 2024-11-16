import type { SkillGroup } from "@xmtp/message-kit";
import { handler as baseHandler } from "./handler/base.js";
import { chainConfigs } from "./utils/chains.js";

export const skills: SkillGroup[] = [
  {
    name: "Stablecoin Operations",
    tag: "@wtf",
    description: "Cross-chain stablecoin operations",
    skills: [
      {
        skill: "/balance [token] [chain]",
        examples: [
          "/balance USDT TRON",
          "/balance USDC Ethereum"
        ],
        handler: baseHandler,
        description: "Check token balance on specific chain",
        params: {
          token: {
            default: "USDC",
            type: "string",
            values: ["USDC"]
          },
          chain: {
            default: "Base",
            type: "string",
            values: Object.keys(chainConfigs)
          }
        }
      },
      {
        skill: "/transfer [amount] [token] [recipientAddress] [chain]",
        examples: [
          "/transfer 100 USDT 0x123... TRON",
          "/transfer 1 USDC vitalik.eth Ethereum",
          "/transfer 2 USDC to dorara.eth Arbitrum",
          "/transfer 100 USDC to 0x123... TRON",
          "/transfer 100 USDC to 0x123... Base",
        ],
        handler: baseHandler,
        description: "Transfer tokens to a recipient address on a specific chain",
        params: {
          amount: {
            default: 1,
            type: "number"
          },
          token: {
            default: "USDT",
            type: "string",
            values: ["USDT", "USDC"]
          },
          recipientAddress: {
            default: "0x0a7a51B8887ca23B13d692eC8Cb1CCa4100eda4B",
            type: "address"
          },
          chain: {
            default: "Arbitrum",
            type: "string",
            values: ["Ethereum", "Base", "Arbitrum", "Tron"]
          }
        }
      }
    ]
  }
];
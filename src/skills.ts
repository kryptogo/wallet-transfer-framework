import { handler as baseHandler } from "./handler/base.js";
import { chainConfigs } from "./utils/chains.js";
import type { SkillGroup } from "@xmtp/message-kit";

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
        skill: "/transfer [amount] [token] [recipient] [chain]",
        examples: [
          "/transfer 100 USDT 0x123... TRON",
          "/transfer 1 USDC vitalik.eth Ethereum"
        ],
        handler: baseHandler,
        description: "Transfer tokens across any supported blockchain",
        params: {
          amount: {
            default: 10,
            type: "number"
          },
          token: {
            default: "USDT",
            type: "string",
            values: ["USDT", "USDC"]
          },
          recipient: {
            default: "",
            type: "string"
          },
          chain: {
            default: "Ethereum",
            type: "string",
            values: Object.keys(chainConfigs)
          }
        }
      }
    ]
  }
];
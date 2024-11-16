import type { SkillGroup } from "@xmtp/message-kit";
import { handler as baseHandler } from "./handler/base.js";
import { chainConfigs } from "./utils/chains.js";
 
export const skills: SkillGroup[] = [
  {
    name: "Stablecoin Transfer",
    tag: "@wtf",
    description: "Cross-chain stablecoin transfers",
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
            default: "USDT",
            type: "string",
            values: ["USDT", "USDC"]
          },
          chain: {
            default: "Ethereum",
            type: "string",
            values: Object.keys(chainConfigs)
          }
        }
      },
      {
        skill: "/transfer [amount] [token] [recipient] [chain]",
        examples: [
          "/transfer 100 USDT alice.eth TRON",
          "/transfer 50 USDC bob.eth Ethereum"
        ],
        handler: baseHandler,
        description: "Transfer stablecoins across chains",
        params: {
          amount: {
            default: 10,
            type: "number"
          },
          token: {
            default: "USDT",
            type: "string",
            values: ["USDT", "USDC"] // 支援的穩定幣
          },
          recipient: {
            default: "",
            type: "string"
          },
          chain: {
            default: "Ethereum",
            type: "string",
            values: ["Ethereum", "TRON", "Base"] // 支援的鏈
          }
        }
      }
    ]
  }
];
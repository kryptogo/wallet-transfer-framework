import { HandlerContext, SkillResponse } from "@xmtp/message-kit";
import { getUserInfo } from "@xmtp/message-kit";
import { isAddress } from "viem";
import { chainConfigs } from "../utils/chains.js";

export const handler = async (
  context: HandlerContext
): Promise<SkillResponse | undefined> => {
  const {
    message: {
      content: { skill, params },
    },
  } = context;

  switch (skill) {
    case "swap": {
      const { amount, token_from, token_to } = params;
      if (!amount || !token_from || !token_to) {
        return {
          code: 400,
          message: "Missing required parameters. Please provide amount, token_from, and token_to.",
        };
      }
      
      // Here you would integrate with actual swap functionality
      return {
        code: 200,
        message: `Swapping ${amount} ${token_from} to ${token_to}...`,
      };
    }

    case "drip": {
      const { network, address } = params;
      if (!network || !address) {
        return {
          code: 400,
          message: "Missing required parameters. Please provide network and address.",
        };
      }

      if (!isAddress(address)) {
        return {
          code: 400,
          message: "Invalid address format.",
        };
      }

      // Here you would integrate with actual faucet functionality
      return {
        code: 200,
        message: `Dripping testnet tokens to ${address} on ${network}...`,
      };
    }

    case "url_mint": {
      const { url } = params;
      if (!url) {
        return {
          code: 400,
          message: "Missing required parameter: url",
        };
      }

      // Validate if it's a Zora or Coinbase Wallet URL
      if (!url.includes("zora.co") && !url.includes("coinbase.com")) {
        return {
          code: 400,
          message: "Invalid URL. Must be a Zora or Coinbase Wallet URL.",
        };
      }

      // Here you would integrate with actual minting functionality
      return {
        code: 200,
        message: `Preparing to mint from URL: ${url}`,
      };
    }

    case "mint": {
      const { collection, token_id } = params;
      if (!collection || !token_id) {
        return {
          code: 400,
          message: "Missing required parameters. Please provide collection and token_id.",
        };
      }

      if (!isAddress(collection)) {
        return {
          code: 400,
          message: "Invalid collection address format.",
        };
      }

      // Here you would integrate with actual minting functionality
      return {
        code: 200,
        message: `Minting token ${token_id} from collection ${collection}...`,
      };
    }

    case "pay": {
      const { amount, token, username } = params;
      if (!amount || !token || !username) {
        return {
          code: 400,
          message: "Missing required parameters. Please provide amount, token, and username.",
        };
      }

      // Resolve username to address if needed
      const userInfo = await getUserInfo(username);
      if (!userInfo?.address) {
        return {
          code: 404,
          message: "Could not resolve username to address.",
        };
      }

      // Here you would integrate with actual payment functionality
      return {
        code: 200,
        message: `Sending ${amount} ${token} to ${username} (${userInfo.address})...`,
      };
    }

    case "show": {
      // Return base URL or relevant information
      return {
        code: 200,
        message: "Base URL: https://base.org",
      };
    }

    case "/transfer": {
      const { amount, token, recipient, chain } = params;
      
      // Validate chain and get config
      const chainConfig = chainConfigs[chain];
      if (!chainConfig) {
        return {
          code: 400,
          message: `Unsupported chain: ${chain}. Supported chains: ${Object.keys(chainConfigs).join(", ")}`,
        };
      }

      // Validate token
      if (!chainConfig.supportedTokens.includes(token)) {
        return {
          code: 400,
          message: `Token ${token} not supported on ${chain}. Supported tokens: ${chainConfig.supportedTokens.join(", ")}`,
        };
      }

      // Validate address format
      if (!chainConfig.validateAddress(recipient)) {
        return {
          code: 400,
          message: `Invalid ${chain} address format`,
        };
      }

      // Get estimated fee
      const fee = await chainConfig.estimateFee();

      return {
        code: 200,
        message: `Transfer initiated:\nAmount: ${amount} ${token}\nTo: ${recipient}\nChain: ${chain}\nEstimated fee: ${fee} ${chainConfig.nativeToken}`,
      };
    }

    case "route_options": {
      const { amount, token, recipient } = params;
      // Get transfer options across different chains
      const routes = [
        {
          chain: "TRON",
          fee: "0.2 USDT",
          time: "2 seconds",
        },
        {
          chain: "Ethereum",
          fee: "5.0 USDT",
          time: "30 seconds", 
        }
      ];
      
      return {
        code: 200,
        message: `Available routes:\n${routes.map(r => 
          `${r.chain}: Fee ${r.fee}, Time ${r.time}`).join('\n')}`,
      };
    }

    default:
      return {
        code: 400,
        message: "Unsupported skill.",
      };
  }
};

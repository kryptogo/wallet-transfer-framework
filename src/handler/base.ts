import { HandlerContext } from "@xmtp/message-kit";
import { chainConfigs } from "../utils/chains.js";

// Base URL for the TxPay frame
const TX_PAY_BASE_URL = "https://base-tx-frame.vercel.app/transaction/";

// Default token addresses for supported chains
const TOKEN_ADDRESSES = {
  "ethereum": "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", // USDC on Ethereum
  "base": "0x833589fcd6edb6e08f4c7c32d4f71b54bda02913", // USDC on Base
  "arbitrum": "0xaf88d065e77c8cC2239327C5EDb3A432268e5831", // USDC on Arbitrum
};

// Chain IDs mapping 
const CHAIN_IDS = {
  "ethereum": 1,
  "base": 8453,
};

function generateTxPayURL(params: {
  recipientAddress?: string,
  tokenAddress?: string,
  chainId?: number,
  amount?: number,
  transactionType: 'send' | 'swap' | 'mint'
}) {
  const queryParams = new URLSearchParams();

  queryParams.append('transaction_type', params.transactionType);
  queryParams.append('buttonName', params.transactionType.charAt(0).toUpperCase() + params.transactionType.slice(1));

  if (params.recipientAddress) {
    queryParams.append('receiver', params.recipientAddress);
  }
  if (params.amount) {
    queryParams.append('amount', params.amount.toString());
  }
  if (params.tokenAddress) {
    queryParams.append('token', 'USDC');
  }

  return `${TX_PAY_BASE_URL}?${queryParams.toString()}`;
}

export async function handler(context: HandlerContext) {
  const {
    message: {
      content,
      sender,
    },
  } = context;

  const skill = content.skill;

  switch (skill) {
    case "balance": {
      const { token = "USDT", chain = "Ethereum" } = content.params;

      // Validate chain support
      if (!chainConfigs[chain]) {
        await context.reply(`Chain ${chain} is not supported. Supported chains: ${Object.keys(chainConfigs).join(", ")}`);
        return;
      }

      // Generate balance check URL using TxPay
      const balanceUrl = generateTxPayURL({
        tokenAddress: TOKEN_ADDRESSES[chain.toLowerCase() as keyof typeof TOKEN_ADDRESSES],
        chainId: CHAIN_IDS[chain.toLowerCase() as keyof typeof CHAIN_IDS],
        transactionType: 'send'
      });

      await context.reply(`Check your ${token} balance on ${chain}:
${balanceUrl}`);
      break;
    }

    case "transfer": {
      const { amount, recipientAddress, chain } = content.params;

      console.log(content.params);
      console.log(content.text);

      // Validate chain support
      if (!chainConfigs[chain]) {
        await context.reply(`Chain ${chain} is not supported. Supported chains: ${Object.keys(chainConfigs).join(", ")}`);
        return;
      }

      let chainId = chain.toLowerCase();
      let userMsg = content.text?.toLocaleLowerCase();
      console.log("userMsg", userMsg);
      console.log("userMsg contains base", userMsg?.includes("base"));
      if (chainId === "base" || userMsg?.includes("base")) {
        chainId = "base";
      } else if (chainId === "tron" || userMsg?.includes("tron")) {
        chainId = "TRON";
      } else if (chainId === "ethereum" || userMsg?.includes("ethereum")) {
        chainId = "eth";
      } else if (chainId === "arbitrum" || userMsg?.includes("arbitrum")) {
        chainId = "arb";
      } else {
        chainId = chainId
      }

      var url = "";

      if (chainId.toLowerCase() === "base") {
        url = `https://txpay.vercel.app/?recipientAddress=${recipientAddress}&amount=${amount}&chainId=8453`;
      } else {
        url = `https://kryptogo.page.link/send?to=${recipientAddress}&chainId=${chainId}&assetGroup=${TOKEN_ADDRESSES[chain.toLowerCase() as keyof typeof TOKEN_ADDRESSES]}&amount=${amount}`;
      }




      await context.reply(`Transfer initiated:
        Amount: ${amount} USDC
        To: ${recipientAddress}
        Chain: ${chainId.toUpperCase()}

        Click to proceed with transfer:
        ${url}`);
      break;
    }

    default:
      await context.reply("Unknown command. Available commands: balance, transfer");
      break;
  }
}

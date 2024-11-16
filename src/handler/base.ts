import { HandlerContext, SkillResponse } from "@xmtp/message-kit";
import { chainConfigs } from "../utils/chains.js";

const baseUrl = "https://base-frame-lyart.vercel.app/transaction";

// Helper function to generate transaction URL
function generateFrameURL(
  transaction_type: string,
  params: { [key: string]: string | number | undefined },
) {
  // Filter out undefined parameters
  const filteredParams: { [key: string]: string | number } = {};
  for (const key in params) {
    if (params[key] !== undefined) {
      filteredParams[key] = params[key] as string | number;
    }
  }
  
  const queryParams = new URLSearchParams({
    transaction_type,
    ...filteredParams,
  }).toString();
  
  return `${baseUrl}?${queryParams}`;
}

export const handler = async (context: HandlerContext): Promise<SkillResponse> => {
  const {
    message: {
      content: { skill, params },
      sender,
    },
  } = context;

  switch (skill) {
    case "/balance": {
      const { token, chain } = params;
      
      // 1. 驗證參數
      const chainConfig = chainConfigs[chain];
      if (!chainConfig?.supportedTokens.includes(token)) {
        return {
          code: 400,
          message: `${token} is not supported on ${chain}`,
        };
      }

      // 2. 生成查詢餘額的 URL
      const url = generateFrameURL("balance", {
        token,
        chain,
        address: sender.address
      });

      return {
        code: 200,
        message: `Checking balance:
Token: ${token}
Chain: ${chain}
Address: ${sender.address}

View balance:
${url}`
      };
    }

    case "/transfer": {
      const { amount, token, recipient, chain } = params;
      
      // 1. 驗證參數
      const chainConfig = chainConfigs[chain];
      if (!chainConfig?.supportedTokens.includes(token)) {
        return {
          code: 400,
          message: `${token} is not supported on ${chain}`,
        };
      }

      // 2. 檢查發送者餘額
      const balanceUrl = generateFrameURL("balance", {
        token,
        chain,
        address: sender.address
      });

      // 3. 估算費用
      const fee = await chainConfig.estimateFee();
      
      // 4. 生成交易 URL
      const transferUrl = generateFrameURL("transfer", {
        amount,
        token,
        recipient,
        chain,
        fee
      });

      return {
        code: 200,
        message: `Transfer initiated:
Amount: ${amount} ${token}
To: ${recipient}
Chain: ${chain}
Estimated fee: $${fee}

Check your balance first:
${balanceUrl}

Then click to confirm transfer:
${transferUrl}`
      };
    }

    default:
      return {
        code: 400,
        message: "Unsupported skill"
      };
  }
};

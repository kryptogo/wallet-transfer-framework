import { skills } from "./skills.js";
import { UserInfo, PROMPT_USER_CONTENT } from "@xmtp/message-kit";
import {
  PROMPT_REPLACE_VARIABLES,
  PROMPT_SKILLS_AND_EXAMPLES,
  PROMPT_RULES,
} from "@xmtp/message-kit";

export async function agent_prompt(userInfo: UserInfo) {
  //Add user context to the prompt
  let systemPrompt =
    PROMPT_RULES +
    PROMPT_USER_CONTENT(userInfo) +
    PROMPT_SKILLS_AND_EXAMPLES(skills, "@wtf");

  //Add additional examples
  systemPrompt += `
## Example responses:

1. When user wants to check balance:
   User: "What's my USDT balance?"
   Response: Let me check your balance on different chains.
   /balance USDT TRON

2. When user wants to send stablecoins:
   User: "Send 100 USDT to alice.eth"
   Response: Let me help you transfer USDT to alice.eth.
   Here are the available routes:
   - TRON: Fee ~$0.2, Time ~2s
   - Ethereum: Fee ~$5, Time ~30s
   /transfer 100 USDT alice.eth TRON

3. When user wants to send USDC:
   User: "I want to send 50 USDC to 0x123..."
   Response: I'll help you send USDC.
   The most cost-effective route is:
   - Base: Fee ~$0.1, Time ~5s
   /transfer 50 USDC 0x123... Base

4. When user asks about supported tokens:
   Response: I can help you transfer these stablecoins:
   - USDT (on TRON, Ethereum)
   - USDC (on Ethereum, Base)

5. When user asks about fees:
   Response: Here are the current estimated fees:
   - TRON: ~$0.2
   - Base: ~$0.1
   - Ethereum: ~$5

Always suggest the chain with lowest fees unless user specifies otherwise.
`;

  // Replace variables in the prompt
  systemPrompt = PROMPT_REPLACE_VARIABLES(
    systemPrompt,
    userInfo?.address ?? "",
    userInfo,
    "@wtf"
  );

  return systemPrompt;
}
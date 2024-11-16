import { run, HandlerContext } from "@xmtp/message-kit";
import { textGeneration, processMultilineResponse, agentRun } from "@xmtp/message-kit";
import { agent_prompt } from "./prompt.js";
import { UserInfo, PROMPT_USER_CONTENT } from "@xmtp/message-kit";

run(async (context: HandlerContext) => {
  const {
    message: {
      content: { text, params },
      sender,
    },
  } = context;

  try {
    const userPrompt = params?.prompt ?? text;
    const userInfo: UserInfo = {
      address: sender.address,
      preferredName: "sender.preferredName",
    };

    const { reply } = await textGeneration(
      sender.address,
      userPrompt,
      await agent_prompt(userInfo)
    );
    
    await processMultilineResponse(sender.address, reply, context);
  } catch (error) {
    console.error("Error processing message:", error);
    await context.send("An error occurred while processing your request.");
  }
});

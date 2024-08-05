//
//  tools1.swift
//  OpenAIBuildHours
//
//  Created by James Rochabrun on 8/3/24.
//

import Foundation
import SwiftOpenAI

let model = "gpt-4o-mini"

private let systemMessage = """
    "You are a customer support agent for ACME Inc."
    "Always answer in a sentence or less."
    "Follow the following routine with the user:"
    "1. First, ask probing questions and understand the user's problem deeper.\n"
    " - unless the user has already provided a reason.\n"
    "2. Propose a fix (make one up).\n"
    "3. ONLY if not satesfied, offer a refund.\n"
    "4. If accepted, search for the ID and then execute refund."
    ""
   """

private var tools: [ChatCompletionParameters.Tool] =
[
   .init(function: .init(
      name: "execute_refund",
      description: nil,
      parameters: .init(
         type: .object,
         properties: [
            "item_id": .init(type: .string),
            "reason": .init(type: .string)
         ],
         required: ["item_id"]))),
   .init(function: .init(
      name: "look_up_item",
      description: "Use to find item ID.\n    Search query can be a description or keywords.",
      parameters: .init(
         type: .object,
         properties: [
            "search_query": .init(type: .string),
         ],
         required: ["search_query"]))),
]

/*
 def run_full_turn(system_message, tools, messages):
     response = client.chat.completions.create(
         model=model,
         messages=[{"role": "system", "content": system_message}] + messages,
         tools=tools,
     )
     message = response.choices[0].message
     messages.append(message)

     if message.content:
         print(color("Assistant:", "yellow"), message.content)

     if not message.tool_calls:
         return message

     # print tool calls
     for tool_call in message.tool_calls:
         name = tool_call.function.name
         args = json.loads(tool_call.function.arguments)
         print(
             color("Assistant:", "yellow"),
             color(f"Executing tool call: {tool_call.function.name}({args})", "magenta"),
         )

     return message
 */

extension Client {
  
   func runFullTurn(
      systemMessage: String,
      tools: [ChatCompletionParameters.Tool],
      messages: [ChatCompletionParameters.Message])
      async throws -> ChatCompletionParameters.Message
   {
      
      let finalMessages = [ChatCompletionParameters.Message(role: .system, content: .text(systemMessage))] + messages
      let parameters = ChatCompletionParameters(
         messages: finalMessages,
         model: .gpt4o,
         tools: tools)
      
      let response = try await service.startChat(parameters: parameters)
      let assistantMessage
      
   }
}


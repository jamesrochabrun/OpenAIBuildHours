//
//  Setup.swift
//  OpenAIBuildHours
//
//  Created by James Rochabrun on 8/3/24.
//

import Foundation
import SwiftUI
import SwiftOpenAI

@Observable
final class Client {
   
   var messageHistory: [ChatCompletionParameters.Message] = []
   
   init(service: OpenAIService) {
      self.service = service
   }
   
   let service: OpenAIService
   
   func addUserMessage(_ input: String) async throws {
      let userMessage = ChatCompletionParameters.Message(role: .user, content: .text(input))
      messageHistory.append(userMessage)
      
      let messages = [
         .init(role: .system, content: .text("You are a helpful Assistant."))
      ] + messageHistory
      
      let parameters = ChatCompletionParameters(
         messages: messages,
         model: .gpt4o)
      
      let response = try await service.startChat(parameters: parameters)
      let messageResponse = response.choices[0].message
      
      let assistantMessage = ChatCompletionParameters.Message(role: .assistant, content: .text(messageResponse.content ?? ""))
      
      messageHistory.append(assistantMessage)
   }
}

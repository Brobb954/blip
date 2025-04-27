//
//  AIProviderProtocol.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import Foundation

struct AIChunk {
  let text: String
  let blipID: String
}

/// Configuration for a single AI request.
struct ProviderConfig {
  let blipID: String
  let modelID: String
  let temperature: Double
  let tokenBudget: Int
  let historyDepth: Int
  let systemPrompt: String
  let customInstructions: String
}

protocol AIProviderProtocol {
  func send(
    messages: [ChatMessage],
    config: ProviderConfig
  ) -> AsyncThrowingStream<AIChunk, Error>
}


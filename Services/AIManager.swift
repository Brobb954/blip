//
//  AIManager.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import Foundation

@MainActor
final class AIManager {
  static let shared = AIManager()

  private let providers: [AIProviderProtocol]

  private init() {
    providers = [OpenAIProvider()]
  }

  /// Now returns an AsyncThrowingStream to match the provider protocol.
  func send(
    messages: [ChatMessage],
    using config: ProviderConfig
  ) -> AsyncThrowingStream<AIChunk, Error> {
    providers[0].send(messages: messages, config: config)
  }
}

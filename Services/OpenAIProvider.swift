//
//  OpenAIProvider.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import Foundation

private struct ChatCompletionRequest: Codable {
  let model: String
  let messages: [Message]
  let temperature: Double
  let max_tokens: Int
  let stream: Bool

  struct Message: Codable {
    let role: String
    let content: String
  }
}

private struct ChatCompletionChunk: Decodable {
  let choices: [Choice]
  struct Choice: Decodable { let delta: Delta }
  struct Delta: Decodable { let content: String? }
}

final class OpenAIProvider: AIProviderProtocol {
  private let apiKey: String
  private let session = URLSession.shared

  init() {
    guard let key = DotEnv.value(for: "OPENAI_API_KEY") else {
      fatalError("OPENAI_API_KEY missing from .env")
    }
    apiKey = key
  }

  func send(
    messages: [ChatMessage],
    config: ProviderConfig
  ) -> AsyncThrowingStream<AIChunk, Error> {
    return AsyncThrowingStream<AIChunk, Error> { continuation in
      Task {
        do {
          // Build request
          var req = URLRequest(
            url: URL(string: "https://api.openai.com/v1/chat/completions")!
          )
          req.httpMethod = "POST"
          req.setValue("Bearer \(apiKey)",
                       forHTTPHeaderField: "Authorization")
          req.setValue("application/json",
                       forHTTPHeaderField: "Content-Type")

          // Prepare body
          let recent = messages.suffix(config.historyDepth)
          let apiMsgs = recent.map {
            ChatCompletionRequest.Message(
              role: $0.role == .user ? "user" : "assistant",
              content: $0.text
            )
          }
          let body = ChatCompletionRequest(
            model: config.modelID,
            messages: apiMsgs,
            temperature: config.temperature,
            max_tokens: config.tokenBudget,
            stream: true
          )
          req.httpBody = try JSONEncoder().encode(body)

          // Stream response
          let (stream, _) = try await session.bytes(for: req)
          for try await line in stream.lines {
            guard line.hasPrefix("data: ") else { continue }
            let payload = line.dropFirst(6)
            if payload == "[DONE]" { break }
            let chunk = try JSONDecoder()
              .decode(ChatCompletionChunk.self,
                      from: Data(payload.utf8))
            if let text = chunk.choices.first?.delta.content {
              continuation.yield(
                AIChunk(text: text,
                        blipID: config.blipID)
              )
            }
          }
          continuation.finish()
        } catch {
          continuation.finish(throwing: error)
        }
      }
    }
  }
}


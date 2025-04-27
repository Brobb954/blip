//
//  BlipAssistant.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import Foundation

struct BlipAssistant: Identifiable, Codable {
  let id: String
  var name: String
  var model: String
  var category: String
  var isFavorite: Bool
  var description: String

  var behavior: BehaviorSettings
  var expertise: ExpertiseSettings
  var advanced: AdvancedSettings

  struct BehaviorSettings: Codable {
    var temperature: Double
    var participationMode: String
    var responseFreq: Double
    var relevanceThresh: Double 
    var personalityStyle: String
  }

  struct ExpertiseSettings: Codable {
    var domain: String
    var systemPrompt: String
    var customInstructions: String
  }

  struct AdvancedSettings: Codable {
    var historyDepth: Int
    var tokenBudget: Int
  }
}

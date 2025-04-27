//
//  DotEnv.swift
//  blip
//
//  Created by Brandon Robb on 4/24/25.
//

import Foundation

/// Loads a bundled “env” file into process env variables.
struct DotEnv {
  /// Call at app startup to read “env” from bundle
  static func load() {
    guard let url = Bundle.main.url(forResource: "env", withExtension: nil),
          let content = try? String(contentsOf: url, encoding: .utf8)
    else { return }

    for line in content.split(whereSeparator: \.isNewline) {
      let parts = line.split(separator: "=", maxSplits: 1).map(String.init)
      guard parts.count == 2 else { continue }
      setenv(parts[0], parts[1], 1)
    }
  }

  /// Retrieve an env value
  static func value(for key: String) -> String? {
    guard let c = getenv(key) else { return nil }
    return String(cString: c)
  }
}

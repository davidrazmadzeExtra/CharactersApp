//
//  Character.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit

/// A character that has a name, description, and icon URL
/// The characters are fetched from the DuckDuckGo Free API
struct Character {
  
  // MARK: - Properties
  
  /// The name of the character
  let name: String
  
  /// The image of the character that will be displayed
  /// Apu Nahasapeemapetilon example: https://duckduckgo.com/i/99b04638.png
  var iconURL: String? = nil
  
  /// A paragraph description of the character
  let description: String
  
  // MARK: - Enum Keys
  
  enum CodingKeys: String, CodingKey {
    case icon = "Icon"
    case url = "URL"
    case result = "Result"
    case text = "Text"
  }
  
  // MARK: - Init
  
  init(name: String, iconUrl: String, description: String) {
    self.name = name
    self.description = description
    if !iconUrl.isEmpty {
      self.iconURL = "https://duckduckgo.com\(iconUrl)"
    }
  }
  
}

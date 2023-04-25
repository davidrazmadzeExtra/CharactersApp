//
//  Character.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit

struct Character {
  
  // MARK: - Properties
  
  let name: String
  let title: String
  var iconURL: String? = nil
  let description: String
  
  // MARK: - Enum Keys
  
  enum CodingKeys: String, CodingKey {
    case firstURL = "FirstURL"
    case icon = "Icon"
    case url = "URL"
    case result = "Result"
    case text = "Text"
  }
  
  // MARK: - Lifecycle
  
  init(name: String, iconUrl: String, title: String, description: String) {
    self.name = name
    self.title = title
    self.description = description
    
    /// Apu Nahasapeemapetilon example: https://duckduckgo.com/i/99b04638.png
    /// iconURL = `/i/bc74928e.jpg`
    if !iconUrl.isEmpty {
      self.iconURL = "https://duckduckgo.com\(iconUrl)"
    }
  }
}

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
  let iconURL: String
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
    self.iconURL = iconUrl
    self.title = title
    self.description = description
  }
}

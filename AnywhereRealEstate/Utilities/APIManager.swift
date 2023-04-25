//
//  APIManager.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import Foundation

class APIManager {
  
  // MARK: - Properties
  
  private static let simpsonsEndpoint = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
  private static let wireEndpoint = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"
  
  // MARK: - Decodable structs
  
  private struct ApiResponse: Decodable {
    let relatedTopics: [RelatedTopic]
    
    private enum CodingKeys: String, CodingKey {
      case relatedTopics = "RelatedTopics"
    }
  }
  
  private struct RelatedTopic: Decodable {
    let firstURL: String
    let icon: Icon
    let result: String
    let text: String
    
    private enum CodingKeys: String, CodingKey {
      case firstURL = "FirstURL"
      case icon = "Icon"
      case result = "Result"
      case text = "Text"
    }
    
    struct Icon: Decodable {
      let height: String
      let url: String
      let width: String
      
      private enum CodingKeys: String, CodingKey {
        case height = "Height"
        case url = "URL"
        case width = "Width"
      }
    }
  }
  
  // MARK: - Functions
  
  func fetchCharacters(from endpoint: String, completion: @escaping (Result<[Character], Error>) -> Void) {
    guard let url = URL(string: endpoint) else {
      completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let data = data else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
        return
      }
      
      do {
        var uniqueCharacterNames = Set<String>()
        let jsonResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        let characters = jsonResponse.relatedTopics.compactMap { relatedTopic -> Character? in
          // Get the full name by extracting it before the "-" dash character
          let fullName = relatedTopic.text
          let dashIndex = relatedTopic.text.firstIndex(of: "-") ?? fullName.endIndex
          var characterName = fullName[..<dashIndex].trimmingCharacters(in: .whitespacesAndNewlines)
          
          // Remove any parentheses from the character name ()
          characterName = characterName.replacingOccurrences(of: "\\([^\\)]+\\)", with: "", options: .regularExpression)
          characterName = characterName.trimmingCharacters(in: .whitespacesAndNewlines)
          
          
          // Get the description which is all the text after the extracted character name
          let characterNameRange = relatedTopic.text.range(of: characterName)
          let descriptionStartIndex = characterNameRange?.upperBound ?? relatedTopic.text.startIndex
          let offset = 2
          var characterDescription = ""
          
          // move past the "-" dash to get the character's description
          if relatedTopic.text.distance(from: descriptionStartIndex, to: relatedTopic.text.endIndex) > offset {
              let updatedDescriptionStartIndex = relatedTopic.text.index(descriptionStartIndex, offsetBy: offset)
              characterDescription = relatedTopic.text[updatedDescriptionStartIndex...].trimmingCharacters(in: .whitespacesAndNewlines)
          }
          
          // Remove any character duplicates
          if !uniqueCharacterNames.contains(characterName) {
            uniqueCharacterNames.insert(characterName)
            return Character(name: characterName, iconUrl: relatedTopic.icon.url, title: relatedTopic.firstURL, description: characterDescription)
          }
          
          return nil
        }
        completion(.success(characters))
      } catch {
        completion(.failure(error))
      }
    }
    
    task.resume()
  }
  
  func fetchSimpsonsCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
    fetchCharacters(from: APIManager.simpsonsEndpoint, completion: completion)
  }
  
  func fetchWireCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
    fetchCharacters(from: APIManager.wireEndpoint, completion: completion)
  }
  
}

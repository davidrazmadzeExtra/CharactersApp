//
//  APIManager.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import Foundation

/// APIManager that communicates with DuckDuckGo's RESTful API using `URLSession`
class APIManager {
  
  // MARK: - Enums
  
  enum FetchCharactersError: Error {
    case invalidURL
    case noDataReceived
  }
  
  // MARK: - Decodable structs
  
  private struct ApiResponse: Decodable {
    
    /// Out of all the data, we are only interested in the `RelatedTopics` field
    let relatedTopics: [RelatedTopic]
    
    // TODO: "Heading": "The Simpsons characters" - we could have used this for the nav title
    // But I decided not to use it because I wanted full control over the title
    
    private enum CodingKeys: String, CodingKey {
      case relatedTopics = "RelatedTopics"
    }
  }
  
  /// Extracting the `icon` and `text` from each `RelatedTopic` item in the array of topics
  private struct RelatedTopic: Decodable {
    let icon: Icon
    let text: String
    
    private enum CodingKeys: String, CodingKey {
      case icon = "Icon"
      case text = "Text"
    }
    
    struct Icon: Decodable {
      let url: String
      
      private enum CodingKeys: String, CodingKey {
        case url = "URL"
      }
    }
  }
  
  // MARK: - Functions
  
  func fetchCharacters(from endpoint: String, completion: @escaping (Result<[Character], FetchCharactersError>) -> Void) {
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidURL))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      /// ❌ Handle Errors using custom `FetchCharactersError` enum
      if let error = error {
        completion(.failure(.invalidURL))
        return
      }
      
      guard let data = data else {
        completion(.failure(.noDataReceived))
        return
      }
      
      do {
        var uniqueCharacterNames = Set<String>()
        let jsonResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        
        let characters = jsonResponse.relatedTopics.compactMap { relatedTopic -> Character? in
          // 1. Get the full name by extracting it before the "-" dash character
          let fullName = relatedTopic.text
          let dashIndex = relatedTopic.text.firstIndex(of: "-") ?? fullName.endIndex
          var characterName = fullName[..<dashIndex].trimmingCharacters(in: .whitespacesAndNewlines)
          
          // Remove any parentheses from the character name ()
          characterName = characterName.replacingOccurrences(of: "\\([^\\)]+\\)", with: "", options: .regularExpression)
          characterName = characterName.trimmingCharacters(in: .whitespacesAndNewlines)
          
          // 2. Get the description which is all the text after the extracted character name
          let characterNameRange = relatedTopic.text.range(of: characterName)
          let descriptionStartIndex = characterNameRange?.upperBound ?? relatedTopic.text.startIndex
          let offset = 2
          var characterDescription = ""
          
          // move past the "-" dash to get the character's description
          if relatedTopic.text.distance(from: descriptionStartIndex, to: relatedTopic.text.endIndex) > offset {
            let updatedDescriptionStartIndex = relatedTopic.text.index(descriptionStartIndex, offsetBy: offset)
            characterDescription = relatedTopic.text[updatedDescriptionStartIndex...].trimmingCharacters(in: .whitespacesAndNewlines)
          }
          
          // 3. ✅ Remove any character duplicates
          if !uniqueCharacterNames.contains(characterName) {
            uniqueCharacterNames.insert(characterName)
            return Character(name: characterName, iconUrl: relatedTopic.icon.url, description: characterDescription)
          }
          
          // ❌ If there is a duplicate, then don't add it to the characters array
          return nil
        }
        completion(.success(characters))
      } catch {
        // ❌ Catching any errors
        print("JSON decoding error: \(error.localizedDescription)")
        completion(.failure(.noDataReceived))
      }
    }
    
    task.resume()
  }
  
}

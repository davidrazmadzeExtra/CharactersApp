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
        let jsonResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        let characters = jsonResponse.relatedTopics.map { relatedTopic -> Character in
          return Character(name: relatedTopic.text, iconUrl: relatedTopic.icon.url, title: relatedTopic.firstURL, description: relatedTopic.result)
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

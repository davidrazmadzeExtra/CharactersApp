//
//  CharacterViewController.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit

class CharacterViewController: UIViewController {
  
  // MARK: - Properties
  
  /// Character passed along from the Table View
  var character: Character?
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var characterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCharacterDetails()
  }
  
  // MARK: - Helper Functions
  
  func setupCharacterDetails() {
    guard let character else { return }
    titleLabel.text = character.name
    descriptionTextView.text = character.description
    
    // Load the image, display missing image icon if it doesn't exist
    guard let iconURL = character.iconURL else {
      characterImageView.image = UIImage(named: "image_missing")
      return
    }
    let imageURL = URL(string: iconURL)
    let imageData = try? Data(contentsOf: imageURL!)
    characterImageView.image = UIImage(data: imageData!)
  }
  
}

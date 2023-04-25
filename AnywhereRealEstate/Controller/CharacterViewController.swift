//
//  CharacterViewController.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit
import SDWebImage

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
    
    // Show an activity indicator while downloading the image
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.center = characterImageView.center
    activityIndicator.startAnimating()
    characterImageView.addSubview(activityIndicator)
    
    // Load the character image, display missing image icon if it doesn't exist
    let missingImage = UIImage(named: "image_missing")
    guard let iconURL = character.iconURL else {
      characterImageView.image = missingImage
      activityIndicator.stopAnimating()
      return
    }
    
    // ✅ Image loaded successfully
    characterImageView.sd_setImage(with: URL(string: iconURL), placeholderImage: missingImage) { (_, _, _, _) in
      activityIndicator.stopAnimating()
    }
  }
  
}

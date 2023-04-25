//
//  CharacterViewController.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit

class CharacterViewController: UIViewController {
  
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
    let imageURL = URL(string: "https://pngimg.com/uploads/simpsons/simpsons_PNG6.png")
    let imageData = try? Data(contentsOf: imageURL!)
    characterImageView.image = UIImage(data: imageData!)
    
    titleLabel.text = "Homer Simpson"
    descriptionTextView.text = "Homer Jay Simpson is a fictional character and the main protagonist of the American animated sitcom The Simpsons. He is voiced by Dan Castellaneta and first appeared, along with the rest of his family, in The Tracey Ullman Show short \"Good Night\" on April 19, 1987."
  }
  
}

//
//  Extensions.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit

extension UIViewController {
  
  /// Remove the text of the back button in the Navigation Stack
  open override func awakeAfter(using coder: NSCoder) -> Any? {
    navigationItem.backButtonDisplayMode = .minimal
    return super.awakeAfter(using: coder)
  }
  
}

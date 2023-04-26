//
//  SceneDelegate.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
    
    guard let splitViewController = window?.rootViewController as? UISplitViewController else { fatalError("Failed to get SplitViewController") }
    
    if let navigationController = splitViewController.viewControllers.first as? UINavigationController,
       let characterListViewController = navigationController.viewControllers.first as? CharacterListViewController {
      
      characterListViewController.delegate = self
      
      // Check if the device is an iPhone
      if UIDevice.current.userInterfaceIdiom == .phone {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let newCharacterListViewController = storyboard.instantiateViewController(withIdentifier: "CharacterListViewController") as? CharacterListViewController else {
          fatalError("Failed to instantiate CharacterListViewController")
        }
        
        // Set the new instance of CharacterListViewController as the root view controller
        window?.rootViewController = UINavigationController(rootViewController: newCharacterListViewController)
      }
    }
    
    
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  
}

// MARK: - CharacterListViewControllerDelegate

extension SceneDelegate: CharacterListViewControllerDelegate {
  
  func didSelectCharacter(_ character: Character) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      guard let splitViewController = window?.rootViewController as? UISplitViewController,
            let secondaryNavigationController = splitViewController.viewControllers.last as? UINavigationController,
            let characterViewController = secondaryNavigationController.viewControllers.first as? CharacterViewController else {
        return
      }
      
      characterViewController.character = character
      characterViewController.setupCharacterDetails()
    }
  }
  
}

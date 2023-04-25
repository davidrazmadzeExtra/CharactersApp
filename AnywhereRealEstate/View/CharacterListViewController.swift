//
//  ViewController.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit

/// Contains a `UITableView` containing different characters coming from a RESTful API
/// This is the initial view controller that gets loaded when the app is launched.
class CharacterListViewController: UITableViewController {
  
  // MARK: - Properties
  
  private let characters = ["Bart", "Homer", "Lisa", "Phil", "Jack"]
  private let cellReuseIdentifier = "CharacterCell"
  private let showDetailSegue = "ShowCharacterDetail"
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}

// MARK: - UITableViewDelegate/UITableViewDataSource

extension CharacterListViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return characters.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
    cell.textLabel?.text = characters[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: showDetailSegue, sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSegue,
       let characterViewController = segue.destination as? CharacterViewController,
       let selectedIndex = tableView.indexPathForSelectedRow {
      // Pass along character to the Detail Controller
      // TODO: characterViewController.character = characters[selectedIndex.row]
      //
    }
  }
  
}

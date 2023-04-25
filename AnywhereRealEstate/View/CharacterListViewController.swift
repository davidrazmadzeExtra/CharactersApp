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
  
  private var allCharacters: [Character] = []
  
  private var characters: [Character] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  private let cellReuseIdentifier = "CharacterCell"
  private let showDetailSegue = "ShowCharacterDetail"
  
  // MARK: - UIViews
  
  private let activityIndicator = UIActivityIndicatorView(style: .large)
  private let searchBar = UISearchBar()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupActivityIndicator()
    setupSearchBar()
    fetchCharacters()
  }
  
  // MARK: - Helper Functions
  
  private func setupActivityIndicator() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.color = .gray
    activityIndicator.hidesWhenStopped = true
    
    // Add the activity indicator to the view
    view.addSubview(activityIndicator)
    
    // Set up the constraints
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  /// Fetches the characters using the `APIManager` class
  private func fetchCharacters() {
    activityIndicator.startAnimating()
    
    // Fetch the character data
    let apiManager = APIManager()
    apiManager.fetchSimpsonsCharacters { [weak self] result in
      DispatchQueue.main.async {
        self?.activityIndicator.stopAnimating()
        switch result {
        case .success(let characters):
          self?.allCharacters = characters
          self?.characters = characters
          self?.title = "Simpsons Characters - \(characters.count)"
        case .failure(let error):
          print("Error fetching characters: \(error)")
          // TODO: display an error message to the user
        }
      }
    }
  }
  
  private func setupSearchBar() {
    searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
    searchBar.showsCancelButton = true
    searchBar.searchBarStyle = .default
    searchBar.sizeToFit()
    
    searchBar.delegate = self
    searchBar.placeholder = "Search characters..."
    tableView.tableHeaderView = searchBar
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
    let character = characters[indexPath.row]
    cell.textLabel?.text = character.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: showDetailSegue, sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: - Prepare for segue
  
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

// MARK: - UISearchBarDelegate

extension CharacterListViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      characters = allCharacters
    } else {
      // Filter the characters by name
      characters = allCharacters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.text = nil
    characters = allCharacters
    tableView.reloadData()
  }
}


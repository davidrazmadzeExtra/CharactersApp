//
//  CharacterListViewController.swift
//  AnywhereRealEstate
//
//  Created by David Razmadze on 4/25/23.
//

import UIKit

/// Protocol used to communicate with the left side of the iPad with the right side for which character was selected
protocol CharacterListViewControllerDelegate: AnyObject {
  func didSelectCharacter(_ character: Character)
}

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
  
  weak var delegate: CharacterListViewControllerDelegate?
  
  // MARK: - UIViews
  
  private let activityIndicator = UIActivityIndicatorView(style: .large)
  private let searchBar = UISearchBar()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupActivityIndicator()
    setupSearchBar()
    fetchCharacters()
    
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
    guard let apiURL = Bundle.main.infoDictionary?["API_URL"] as? String else {
      print("❌ Error: The API_URL in the 'Info' Section of the target does not exist.")
      // 💡 The reason why I am passing the URL here is so we can change the UI more easily in the next iteration
      return
    }
    let apiManager = APIManager()
    apiManager.fetchCharacters(from: apiURL) { [weak self] result in
      DispatchQueue.main.async {
        self?.activityIndicator.stopAnimating()
        switch result {
        case .success(let characters):
          self?.allCharacters = characters
          self?.characters = characters
          
          guard let appTitle = Bundle.main.infoDictionary?["APP_TITLE"] as? String else { return }
          self?.title = "\(appTitle) - \(characters.count) results"
          
          // Select the first character for iPad
          if UIDevice.current.userInterfaceIdiom == .pad {
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            self?.tableView((self?.tableView)!, didSelectRowAt: indexPath)
          }
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
    searchBar.backgroundImage = UIImage()
    searchBar.backgroundColor = .clear
    searchBar.sizeToFit()
    
    searchBar.delegate = self
    
    searchBar.placeholder = UIDevice.current.userInterfaceIdiom == .pad ? "Search characters..." : "Search characters/description..."
    
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
    let character = characters[indexPath.row]
    delegate?.didSelectCharacter(character)
    
    if UIDevice.current.userInterfaceIdiom == .phone {
      performSegue(withIdentifier: showDetailSegue, sender: self)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: - Prepare for segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSegue,
       let characterViewController = segue.destination as? CharacterViewController,
       let selectedIndex = tableView.indexPathForSelectedRow {
      characterViewController.character = characters[selectedIndex.row]
    }
  }
  
}

// MARK: - UISearchBarDelegate

extension CharacterListViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      characters = allCharacters
      tableView.reloadData()
    } else {
      // Filter the characters by name or description
      characters = allCharacters.filter { character in
        character.name.localizedCaseInsensitiveContains(searchText) ||
        character.description.localizedCaseInsensitiveContains(searchText)
      }
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.text = nil
    characters = allCharacters
    tableView.reloadData()
  }
  
}


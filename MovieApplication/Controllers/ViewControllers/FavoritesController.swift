//
//  FavoritesController.swift
//  MovieApplication
//
//  Created by João Ângelo on 23/10/24.
//

import UIKit

class FavoritesController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {

    var favoriteMovies: [Movies] = []
    var filteredMovies: [Movies] = [] // Array to hold filtered movies
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Initialize and configure the search bar
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for movies..."
        searchBar.delegate = self
        navigationItem.titleView = searchBar // Add search bar to the navigation bar
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 225)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        loadFavoriteMovies()
        
        FavoritesManager.shared.favoritesChanged = { [weak self] in
            self?.loadFavoriteMovies()
        }
    }

    private func loadFavoriteMovies() {
        favoriteMovies = FavoritesManager.shared.getFavoriteMovies()
        filteredMovies = favoriteMovies // Initially, all movies are shown
        collectionView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = favoriteMovies // Show all movies if search text is empty
        } else {
            filteredMovies = favoriteMovies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased()) // Filter based on title
            }
        }
        collectionView.reloadData() // Reload collection view with filtered results
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count // Return count of filtered movies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.item] // Get the movie from filtered array
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie.poster_path {
            let completeURLString = baseURL + posterPath
            let title = movie.title
            let releaseYear = movie.release_date
            cell.configure(with: completeURLString, title: title, releaseYear: releaseYear)
        }
        
        // Add tap gesture to the poster
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePosterTap(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.isUserInteractionEnabled = true // Enable interaction with the cell

        return cell
    }
    
    @objc func handlePosterTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? MovieCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let selectedMovie = filteredMovies[indexPath.item] // Use filtered movies
        let detailsController = DetailsController(movie: selectedMovie)
        navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

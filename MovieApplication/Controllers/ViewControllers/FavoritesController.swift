//
//  FavoritesController.swift
//  MovieApplication
//
//  Created by João Ângelo on 23/10/24.
//

import UIKit

class FavoritesController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {

    var favoriteMovies: [Movies] = []
    var filteredMovies: [Movies] = []
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "NavyBackground")

        searchBar = UISearchBar()
        searchBar.placeholder = "Search for movies..."
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(named: "NavyBackground")
        searchBar.searchTextField.textColor = UIColor(named: "VibrantYellow")
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        navigationItem.titleView = searchBar
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 400)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "NavyBackground") // Usando Navy Background
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
        filteredMovies = favoriteMovies
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = favoriteMovies
        } else {
            filteredMovies = favoriteMovies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.item]
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie.poster_path {
            let completeURLString = baseURL + posterPath
            let title = movie.title
            let releaseYear = movie.release_date
            
            cell.configure(with: completeURLString, title: title, releaseYear: releaseYear)
            cell.titleLabel.textColor = UIColor(named: "VibrantYellow")
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePosterTap(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.isUserInteractionEnabled = true

        return cell
    }
    
    @objc func handlePosterTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? MovieCell,
              let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let selectedMovie = filteredMovies[indexPath.item]
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

//
//  FavoritesController.swift
//  MovieApplication
//
//  Created by João Ângelo on 23/10/24.
//

import UIKit

class FavoritesController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var favoriteMovies: [Movies] = []
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // Altere para a cor que desejar
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 225)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        loadFavoriteMovies()
    }

    private func loadFavoriteMovies() {
        // Carrega os filmes favoritos do FavoritesManager
        favoriteMovies = FavoritesManager.shared.loadFavoriteMovies()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = favoriteMovies[indexPath.item]
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie.poster_path {
            let completeURLString = baseURL + posterPath
            let title = movie.title
            let releaseYear = movie.release_date
            cell.configure(with: completeURLString, title: title, releaseYear: releaseYear)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

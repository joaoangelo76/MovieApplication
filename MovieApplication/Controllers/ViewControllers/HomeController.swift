//
//  ViewController.swift
//  MovieApplication
//
//  Created by João Ângelo on 22/10/24.
//

import UIKit

class HomeController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var movies: [Movies] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 225)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        Decoding.fetchMovies{ [weak self] movies in
            if let movies = movies{
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else {
                print("No movies found or an error occurred.")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = movies[indexPath.item]
            
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAddToFavorites))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        
        self.collectionView.addGestureRecognizer(tapGestureRecognizer)
        self.collectionView.isUserInteractionEnabled = true
            
        if let posterPath = movie.poster_path {
            let completeURLString = baseURL + posterPath
            let title = movie.title
            let releaseYear = movie.release_date
            cell.configure(with: completeURLString, title: title, releaseYear: releaseYear)
        } else {
            print("Not a valid poster path.")
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 30
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
    }
    
    @objc func handleAddToFavorites(){
        let dvc = DetailsController()
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}



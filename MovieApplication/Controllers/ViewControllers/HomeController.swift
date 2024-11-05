//
//  ViewController.swift
//  MovieApplication
//
//  Created by João Ângelo on 22/10/24.
//

import UIKit

class HomeController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var movies: [Movies] = []
    private var filteredMovies: [Movies] = []
    
    private let searchBar = UISearchBar()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 400)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "NavyBackground")
        setupSearchBar()
        setupCollectionView()
        loadMovies()
    }

    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Buscar Filmes"
        searchBar.searchTextField.textColor = UIColor(named: "VibrantYellow")
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Buscar Filmes",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "VibrantYellow")!]
        )
        searchBar.barTintColor = UIColor(named: "NavyBackground")
        searchBar.searchTextField.backgroundColor = UIColor(named: "DarkGrey")
        navigationItem.titleView = searchBar
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "NavyBackground") 
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadMovies() {
        Decoding.fetchMovies { [weak self] fetchedMovies in
            DispatchQueue.main.async {
                self?.movies = fetchedMovies ?? []
                self?.filteredMovies = self?.movies ?? []
                self?.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        let title = filteredMovies[indexPath.row].title
        let poster = filteredMovies[indexPath.row].poster_path!
        let releaseDate = filteredMovies[indexPath.row].release_date
        
        cell.configure(with: poster, title: title, releaseYear: releaseDate)
        
        cell.titleLabel.textColor = UIColor(named: "VibrantYellow")

        cell.onPosterTap = { [weak self] in
            let detailsController = DetailsController(movie: movie)
            self?.navigationController?.pushViewController(detailsController, animated: true)
        }
        
        return cell
    }
    
    @objc func navigateToDetails(_ sender: UIButton) {
        let selectedMovie = movies[sender.tag]
        let detailsController = DetailsController(movie: selectedMovie)
        navigationController?.pushViewController(detailsController, animated: true)
    }
}

extension HomeController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased()) ||
                movie.overview.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
    }
}

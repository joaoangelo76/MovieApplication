//
//  DetailsController.swift
//  MovieApplication
//
//  Created by João Ângelo on 24/10/24.
//

import UIKit

class DetailsController: UIViewController {
    
    var movie: Movies? 
    private var isFavorite: Bool {
        get { movie?.isFavorite ?? false }
        set { movie?.isFavorite = newValue }
    }
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let ratingLabel = UILabel()
    private let genreLabel = UILabel()
    private let favoriteButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayMovieDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Configure poster image view
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(posterImageView)
        
        // Configure title label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Configure overview label
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overviewLabel)
        
        // Configure rating label
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingLabel)
        
        // Configure genre label
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genreLabel)
        
        // Configure favorite button
        favoriteButton.setTitle("Favoritar", for: .normal)
        favoriteButton.setTitleColor(.blue, for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoriteButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 150),
            posterImageView.heightAnchor.constraint(equalToConstant: 225),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            genreLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func displayMovieDetails() {
        guard let movie = movie else {
            // Handle error for empty movie data
            titleLabel.text = "Filme não encontrado"
            return
        }
        
        if let posterPath = movie.poster_path {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let completeURLString = baseURL + posterPath
            loadImage(from: completeURLString)
        }
        
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        ratingLabel.text = "Nota: \(movie.vote_average)"
        genreLabel.text = "Gêneros: \(getGenresString(from: movie.genre_ids))"
        
        favoriteButton.setTitle(isFavorite ? "Desfavoritar" : "Favoritar", for: .normal)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Show loading indicator (optional)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                // Handle loading error
                DispatchQueue.main.async {
                    self.posterImageView.image = nil
                }
                return
            }
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    private func getGenresString(from genreIds: [Int]) -> String {
        let genreNames = [
            28: "Ação",
            12: "Aventura",
            16: "Animação",
            35: "Comédia",
            80: "Crime",
            99: "Documentário",
            18: "Drama",
            10751: "Família",
            14: "Fantasia",
            27: "Terror",
            10402: "Música",
            9648: "Mistério",
            10749: "Romance",
            878: "Ficção Científica",
            10770: "Filme de TV",
            53: "Thriller",
            10752: "Guerra",
            37: "Faroeste"
        ]
        
        let names = genreIds.compactMap { genreNames[$0] }
        return names.joined(separator: ", ")
    }
    
    @objc private func toggleFavorite() {
        guard var movie = movie else { return }
        
        isFavorite.toggle()
        
        if isFavorite {
            // Adiciona o filme aos favoritos
            FavoritesManager.shared.saveFavoriteMovie(movie)
        } else {
            // Remove o filme dos favoritos
            FavoritesManager.shared.removeFavoriteMovie(movie)
        }
        
        // Atualiza o título do botão
        favoriteButton.setTitle(isFavorite ? "Desfavoritar" : "Favoritar", for: .normal)
    }
}

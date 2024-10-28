//
//  FavoritesManager.swift
//  MovieApplication
//
//  Created by João Ângelo on 27/10/24.
//

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private var favoriteMovies: [Movies] = []

    private init() {
        favoriteMovies = Decoding.loadMovies() ?? []
    }

    func saveFavoriteMovie(_ movie: Movies) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
        }
        Decoding.saveMovies(favoriteMovies) 
    }
    
    func removeFavoriteMovie(_ movie: Movies) {
        favoriteMovies.removeAll { $0.id == movie.id }
        Decoding.saveMovies(favoriteMovies)
    }
    
    func getFavoriteMovies() -> [Movies] {
        return favoriteMovies
    }
}

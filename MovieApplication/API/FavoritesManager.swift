//
//  FavoritesManager.swift
//  MovieApplication
//
//  Created by João Ângelo on 27/10/24.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private var favoriteMovies: [Movies] = []

    func saveFavoriteMovie(_ movie: Movies) {
        // Adiciona o filme aos favoritos se não estiver na lista
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
        }
        saveFavoriteMovies()
    }
    
    func removeFavoriteMovie(_ movie: Movies) {
        favoriteMovies.removeAll { $0.id == movie.id }
        saveFavoriteMovies()
    }
    
    func saveFavoriteMovies() {
        Decoding.saveMovies(favoriteMovies) // Salva no File Storage
    }
    
    func loadFavoriteMovies() -> [Movies] {
        if let movies = Decoding.loadMovies() {
            // Filtra os filmes que são favoritos
            return movies.filter { $0.isFavorite }
        }
        return []
    }
}

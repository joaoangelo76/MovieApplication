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
    
    var favoritesChanged: (() -> Void)?
    
    private let fileURL: URL
    
    private init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("favoriteMovies.json")
        
        loadFavoriteMovies()
    }
    
    func saveFavoriteMovie(_ movie: Movies) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
            saveToFile()
            favoritesChanged?()
        }
    }
    
    func removeFavoriteMovie(_ movie: Movies) {
        favoriteMovies.removeAll { $0.id == movie.id }
        saveToFile()
        favoritesChanged?()
    }
    
    func isMovieFavorite(_ movie: Movies) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }
    
    func getFavoriteMovies() -> [Movies] {
        return favoriteMovies
    }
    
    private func saveToFile() {
        do {
            let data = try JSONEncoder().encode(favoriteMovies)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save favorites: \(error.localizedDescription)")
        }
    }
    
    private func loadFavoriteMovies() {
        do {
            let data = try Data(contentsOf: fileURL)
            favoriteMovies = try JSONDecoder().decode([Movies].self, from: data)
        } catch {
            print("Failed to load favorites: \(error.localizedDescription)")
            favoriteMovies = []
        }
    }
}

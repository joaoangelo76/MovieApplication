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
    
    // Closure to notify favorites change
    var favoritesChanged: (() -> Void)?
    
    private let fileURL: URL
    
    private init() {
        // Get the file URL for storing favorites
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("favoriteMovies.json")
        
        loadFavoriteMovies() // Load the favorites from file on initialization
    }
    
    func saveFavoriteMovie(_ movie: Movies) {
        // Check if the movie is already in the favorites
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
            saveToFile() // Save to file after adding
            favoritesChanged?() // Notify that favorites have changed
        }
    }
    
    func removeFavoriteMovie(_ movie: Movies) {
        favoriteMovies.removeAll { $0.id == movie.id } // Ensure you have an ID for comparison
        saveToFile() // Save to file after removing
        favoritesChanged?() // Notify that favorites have changed
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
            favoriteMovies = [] // Start with an empty array if loading fails
        }
    }
}

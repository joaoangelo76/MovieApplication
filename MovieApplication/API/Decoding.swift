//
//  Decoding.swift
//  MovieApplication
//
//  Created by João Ângelo on 22/10/24.
//

import UIKit

struct Decoding {
    static let scheme = "https"
    static let baseURL = "api.themoviedb.org/3/movie/popular?language=en-US&page=1"
    static let API_KEY = "122e035d175278ed92b8f71b2d120d3c"
    
    static func fetchMovies(completion: @escaping ([Movies]?) -> Void) {
        let urlString = "\(scheme)://\(baseURL)&api_key=\(API_KEY)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network request failed with error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received from network request.")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MoviesResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }

    static func saveMovies(_ movies: [Movies]) {
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(movies)
            let fileURL = getDocumentsDirectory().appendingPathComponent("favorites.json")
            try data.write(to: fileURL)
            print("Movies saved to \(fileURL)")
        } catch {
            print("Error saving movies: \(error)")
        }
    }

    static func loadMovies() -> [Movies]? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("favorites.json")

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let movies = try decoder.decode([Movies].self, from: data)
            print("Movies loaded to: \(movies)")
            return movies
        } catch {
            print("Error loading movies: \(error)")
            return nil
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        return paths[0]
    }
}

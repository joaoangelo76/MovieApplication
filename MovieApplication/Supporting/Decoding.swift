//
//  Constants.swift
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
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                // Decode the parent response first, and then access 'results'
                let response = try decoder.decode(MoviesResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}

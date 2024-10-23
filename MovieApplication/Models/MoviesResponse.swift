//
//  MoviesResponse.swift
//  MovieApplication
//
//  Created by João Ângelo on 23/10/24.
//

import Foundation

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movies]
}

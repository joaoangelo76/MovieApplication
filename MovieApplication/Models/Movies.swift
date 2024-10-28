//
//  Movies.swift
//  MovieApplication
//
//  Created by João Ângelo on 22/10/24.
//

import Foundation

struct Movies: Codable{
    var adult: Bool
    var backdrop_path: String?
    var genre_ids: [Int]
    var id: Int
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String?
    var release_date: String
    var title: String
    var video: Bool
    var vote_average: Double
    var vote_count: Int
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdrop_path
        case genre_ids
        case id
        case original_language
        case original_title
        case overview
        case popularity
        case poster_path
        case release_date
        case title
        case video
        case vote_average
        case vote_count
    }
}

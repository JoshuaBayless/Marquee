//
//  PopularMovies.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 5/1/22.
//

import UIKit

struct Movies: Decodable {
    var results = [Movie]()
}

struct Movie: Decodable {
    var originalTitle: String
    var overview: String
    var posterPath: String
    var releaseDate: String
    var title: String
    var voteAverage: Double
}

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
    var original_title: String
    var overview: String
    var poster_path: String?
    var release_date: String
    var title: String
    var vote_average: Double
}

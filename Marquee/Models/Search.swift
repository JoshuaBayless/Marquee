//
//  Search.swift
//  Marquee
//
//  Created by Josh  Bayless on 5/6/22.
//

import UIKit

struct SearchResults: Decodable {
    var results: [SearchObject]
}

struct SearchObject: Decodable {
    var name: String?
    var overview: String?
    var posterPath: String?
    var voteAverage: Double?
    var releaseDate: String?
    var title: String?
    var firstAirDate: String?
}

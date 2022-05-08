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
    var poster_path: String?
    var vote_average: Double?
    var release_date: String?
    var title: String?
    var first_air_date: String?
}

//
//  PopularTVShows.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 5/1/22.
//

import UIKit


struct TVShows: Decodable {
    var results = [TVdata]()
}

struct TVdata: Decodable {
    var firstAirDate: String
    var name: String
    var overview: String
    var posterPath: String?
    var voteAverage: Double
}

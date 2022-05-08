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
    var first_air_date: String
    var name: String
    var overview: String
    var poster_path: String?
    var vote_average: Double
}

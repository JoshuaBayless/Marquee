//
//  JSONManager.swift
//  Drank
//
//  Created by Josh  Bayless on 3/22/22.
//

import UIKit



struct JSONManager {
    
    func fetchSearchData(for query: String, completion: @escaping (Result<SearchResults, Error>) -> ())  {
        let searched = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.themoviedb.org/3/search/multi?api_key=0faa2dd79e14d0f827ee82f44f4918ca&language=en-US&page=1&include_adult=false&query=\(searched)"
        performRequest(with: urlString, completion: completion)
    }
    
    func fetchPopularMovies( completion: @escaping (Result<Movies, Error>) -> ())  {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=0faa2dd79e14d0f827ee82f44f4918ca&language=en-US&page=1"
        performRequest(with: urlString, completion: completion)
    }
    
    func fetchPopularTVShows( completion: @escaping (Result<TVShows, Error>) -> ())  {
        let urlString = "https://api.themoviedb.org/3/tv/popular?api_key=0faa2dd79e14d0f827ee82f44f4918ca&language=en-US&page=1"
        performRequest(with: urlString, completion: completion)
    }
    
    func fetchComingSoon( completion: @escaping (Result<Movies, Error>) -> ())  {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=0faa2dd79e14d0f827ee82f44f4918ca&language=en-US&page=1"
        performRequest(with: urlString, completion: completion)
    }
    
    
    func performRequest<T:Decodable>(with urlString: String, completion: @escaping (Result<T, Error>) -> ()) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let safeData = data {
                    if let movieData = self.parseJSON(safeData) as T? {
                        completion(.success(movieData))
                        
                    }}
            }
            task.resume()
        }
    }
    
    func parseJSON<T:Decodable>(_ movieData: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: movieData)
            return decodedData
            
            
        } catch {
            print(error)
            return nil
        }
    }
}


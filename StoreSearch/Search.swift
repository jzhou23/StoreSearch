//
//  Search.swift
//  StoreSearch
//
//  Created by Jiahuang Zhou on 12/4/17.
//  Copyright © 2017 jhzhou. All rights reserved.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {
    
    // MARK:- variables
    var searchResults: [SearchResult] = []
    var hasSearched = false
    var isLoading = false
    private var dataTask: URLSessionDataTask? = nil
    
    // MARK:- methods
    func performSearch(for text: String, category: Int, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()
            
            isLoading = true
            hasSearched = true
            searchResults = []
            
            let url = iTunesURL(searchText: text, category: category)
            let session = URLSession.shared
            
            dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                var success = false
                if let error = error as NSError?, error.code == -999 {
                    return
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    // parse JSON
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sort(by: <)
                    
                    print("Success!")
                    self.isLoading = false
                    success = true
                }
                
                if !success {
                    print("Failure! \(response!)")
                    self.hasSearched = false
                    self.isLoading = false
                }
                
                DispatchQueue.main.sync {
                    completion(success)
                }
            })
            dataTask?.resume()
        }
    }
    
    private func iTunesURL(searchText: String, category: Int) -> URL {
        let kind: String
        switch category {
        case 1:
            kind = "musicTrack"
        case 2:
            kind = "software"
        case 3:
            kind = "ebook"
        default:
            kind = ""
        }
        
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(encodedText)&limit=200&entity=\(kind)"
        let url = URL(string: urlString)
        return url!
    }
    
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}

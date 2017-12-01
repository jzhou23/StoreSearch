//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Jiahuang Zhou on 11/30/17.
//  Copyright © 2017 jhzhou. All rights reserved.
//

import Foundation

class ResultArray:Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult:Codable, CustomStringConvertible {
    var kind:String?
    var artistName = ""
    var currency = ""
    
    var trackName:String?
    var trackViewUrl:String?
    var trackPrice:Double?
    
    var collectionName:String?
    var collectionViewUrl:String?
    var collectionPrice:Double?
    
    var imageSmall = ""
    var imageLarge = ""
    
    var itemGenre:String?
    var bookGenre:[String]?
    
    var itemPrice:Double?
    
    enum CodingKeys: String, CodingKey {
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
        
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
    }
    
    var name:String {
        return trackName ?? collectionName ?? ""
    }
    
    var storeURL:String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    
    var price:Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    
    var type:String {
        let kind = self.kind ?? "audiobook"
        switch kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "E-Book"
        case "feature-movie": return "Movie"
        case "music-video": return "Music Video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: break
        }
        return "Unknown"
    }
    
    var genre:String {
        if let genre = itemGenre {
            return genre    // not e-books
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")       // for e-books
        }
        return ""
    }
    
    var description: String {
        return "Kind: \(kind ?? ""), Name: \(name), Artist Name: \(artistName)"
    }
}

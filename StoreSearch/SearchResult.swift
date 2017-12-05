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
        case "album":
            return NSLocalizedString("Album", comment: "Localized kind: Album")
        case "audiobook":
            return NSLocalizedString("Audio Book", comment: "Localized kind: Audio Book")
        case "book":
            return NSLocalizedString("Book", comment: "Localized kind: Book")
        case "ebook":
            return NSLocalizedString("E-Book", comment: "Localized kind: E-Book")
        case "feature-movie":
            return NSLocalizedString("Movie", comment: "Localized kind: Feature Movie")
        case "music-video":
            return NSLocalizedString("Music Video", comment: "Localized kind: Music Video")
        case "podcast":
            return NSLocalizedString("Podcast", comment: "Localized kind: Podcast")
        case "software":
            return NSLocalizedString("App", comment: "Localized kind: Software")
        case "song":
            return NSLocalizedString("Song", comment: "Localized kind: Song")
        case "tv-episode":
            return NSLocalizedString("TV Episode", comment: "Localized kind: TV Episode")
        default:
            return kind
        }
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

//
//  ResponseItem.swift
//  Movies
//
//  Created by Eugene Kurapov on 13.11.2020.
//

import Foundation

struct ResponseItem: Codable {
    var element: Element

    struct Element: Codable {
        var id: String
        var type: String
        var name: String?
        var description: String?
        var promoText: String?
        var okkoRating: Double?
        var basicCovers: Covers?
        var collectionItems: ItemsCollection?
        
        struct Covers: Codable {
            var items: [Cover]
            
            struct Cover: Codable {
                var url: String
            }
        }
        
        struct ItemsCollection: Codable {
            var items: [ResponseItem]
        }
    }
    
    var collections: [Collection] {
        var collections = [Collection]()
        if var collectionItems = self.element.collectionItems?.items {
            var index = 0
            while index < collectionItems.count {
                var movies = [Movie]()
                if let movieItems = collectionItems[index].element.collectionItems?.items {
                    guard movieItems.first?.element.type != "SUBSCRIPTION" else { index += 1; continue }
                    if movieItems.first?.element.type == "COLLECTION" {
                        collectionItems.append(contentsOf: movieItems)
                        index += 1
                        continue
                    }
                    for movieItem in movieItems {
                        if ["MOVIE","SERIAL"].contains(movieItem.element.type) {
                            let movie = Movie(name: movieItem.element.name!,
                                              subtitle: movieItem.element.promoText ?? "",
                                              description: movieItem.element.description ?? "",
                                              imagePath: movieItem.element.basicCovers!.items[0].url,
                                              rate: movieItem.element.okkoRating!)
                            movies.append(movie)
                        }
                    }
                }
                let collection = Collection(name: collectionItems[index].element.name ?? "", movies: movies)
                collections.append(collection)
                index += 1
            }
        }
        return collections
    }
    
}

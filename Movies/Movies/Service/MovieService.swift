//
//  MovieService.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import Foundation
import UIKit.UIImage

enum MovieServiceError: Error {
    case server
    case badRequest
    case parsing
}

struct Item: Codable {
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
            var items: [Item]
        }
    }
}

class MovieService {
    
    static let shared = MovieService()

    private let collectionsPath = "https://ctx.playfamily.ru/screenapi/v1/noauth/mainpage/web/1?sid=2dyoA3AOfKedLVmD0Aui6Q"
    
    func fetchImageFrom(path: String, completion: @escaping (Result<UIImage,Error>) -> Void) {
        guard let url = URL(string: path) else { completion(Result.failure(MovieServiceError.badRequest)); return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(Result.failure(MovieServiceError.server))
                }
                return
            }
            if let data = data,
               let image = UIImage(data: data)?.decodedImage() {
                DispatchQueue.main.async {
                    completion(Result.success(image))
                }
                return
            } else {
                DispatchQueue.main.async {
                    completion(Result.failure(MovieServiceError.parsing))
                }
                return
            }
        }
        task.resume()
    }
    
    func fetchCellections(completion: @escaping (Result<[Collection],Error>) -> Void) {
        guard let url = URL(string: collectionsPath) else { completion(Result.failure(MovieServiceError.badRequest)); return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(Result.failure(MovieServiceError.server))
                }
                return
            }
            if let data = data,
               let moviesResult = try? JSONDecoder().decode(Item.self, from: data) {
                var collections = [Collection]()
                if var collectionItems = moviesResult.element.collectionItems?.items {
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
                DispatchQueue.main.async {
                    completion(Result.success(collections))
                }
                return
            } else {
                DispatchQueue.main.async {
                    completion(Result.failure(MovieServiceError.parsing))
                }
                return
            }
        }
        task.resume()
    }
    
}

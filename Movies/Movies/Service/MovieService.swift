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

class MovieService {
    
    static let shared = MovieService()
    
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
               let image = UIImage(data: data) {
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
    
}
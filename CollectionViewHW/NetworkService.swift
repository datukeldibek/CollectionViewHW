//
//  NetworkService.swift
//  CollectionViewHW
//
//  Created by Jarae on 4/5/23.
//

import Foundation
class NetworkService {
    private let baseURL = URL(string: "https://dummyjson.com/products")!
    
    func requestUsers(    
        completion: @escaping (Result<Products, Error>) -> Void
    ) {
        let request = URLRequest(url: baseURL)
        
        URLSession(
            configuration: .default
        )
        .dataTask(
            with: request
        ) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let model: Products = try self.decode(data: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}


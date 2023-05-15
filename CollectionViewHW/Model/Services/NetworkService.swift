//
//  NetworkService.swift
//  CollectionViewHW
//
//  Created by Jarae on 4/5/23.
//

import Foundation
class NetworkService {
    
    @available(iOS 15.0.0, *)
    func requestProducts() async throws -> Products {
        let request = URLRequest(url: Constants.API.baseURL)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try self.decode(data: data)
    }
    
    func requestProducts(completion: @escaping (Result<Products, Error>) -> Void) {
        let request = URLRequest(url: Constants.API.baseURL)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            completion(.success(try! self.decode(data: data)))
        }
        .resume()
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}


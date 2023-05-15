//
//  ProductsViewModel.swift
//  CollectionViewHW
//
//  Created by Jarae on 11/5/23.
//

import Foundation

class ProductsViewModel {
    let networkService: NetworkService

    init() {
        self.networkService = NetworkService()
    }
    
    @available(iOS 15.0.0, *)
    func fetchProductProducts() async throws -> [Product] {
        try await networkService.requestProducts().products
    }
    
    func requestProduct(completion: @escaping (Result<Products, Error>) -> Void) {
        networkService.requestProducts(completion: completion)
    }
}


//
//  ViewController.swift
//  CollectionViewHW
//
//  Created by Jarae on 4/5/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var collectionViewA: UICollectionView!
    @IBOutlet private weak var collectionViewB: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tabBar: UITabBar!
    
    private let images: [UIImage?] = [
        UIImage(named: "pic1"),
        UIImage(named: "pic2"),
        UIImage(named: "pic3"),
        UIImage(named: "pic4"),
        UIImage(named: "pic1"),
        UIImage(named: "pic2")
    ]
    private let cvBText: [String] = [
        "Takeaway",
        "Grociery",
        "Convince",
        "Pharmacy",
        "Takeaway",
        "Grociery"
    ]
    private let networkService = NetworkService()
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    private var isFiltered: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTableView()
        fetchProducts()
    }
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: CustomCell.nibName,
                bundle: nil
            ),
            forCellReuseIdentifier: CustomCell.reuseId
        )
        
        //searchBar delegate
        searchBar.delegate = self
    }
    private func configureCollectionView() {
        collectionViewA.dataSource = self
        collectionViewB.dataSource = self
        collectionViewA.delegate = self
        collectionViewB.delegate = self
        collectionViewA.register(
            UINib(
                nibName: CustomCellA.nibName,
                bundle: nil
            ),
            forCellWithReuseIdentifier: CustomCellA.reuseId
        )
        collectionViewB.register(
            UINib(
                nibName: CustomCellB.nibName,
                bundle: nil
            ),
            forCellWithReuseIdentifier: CustomCellB.reuseId
        )
    }
    private func fetchProducts() {
        networkService.requestUsers { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.products = response.products
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UICollecionViewDataSource / DelegateFlowLayout
extension ViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewA {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomCellA.reuseId,
                for: indexPath
            ) as? CustomCellA else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomCellB.reuseId,
                for: indexPath
            ) as? CustomCellB else {
                return UICollectionViewCell()
            }
            cell.display(
                image: images[indexPath.row]!,
                text: cvBText[indexPath.row]
        )
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewA {
            return CGSize(width: 100, height: 40)
        } else {
            return CGSize(width: 80, height: 110)
        }
    }
}

//MARK: - UITableViewDataSource / Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltered ? filteredProducts.count : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseId, for: indexPath) as! CustomCell
        let model = isFiltered ? filteredProducts[indexPath.row] : products[indexPath.row]
        cell.display(item: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        330
    }
}

//MARK: - extension for searchbar
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isFiltered = false
        } else {
            isFiltered = true
            filteredProducts = products.filter{ $0.title.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}


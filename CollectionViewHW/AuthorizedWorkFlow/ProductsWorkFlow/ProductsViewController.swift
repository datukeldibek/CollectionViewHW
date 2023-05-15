//
//  ViewController.swift
//  CollectionViewHW
//
//  Created by Jarae on 4/5/23.
//

import UIKit

class ProductsViewController: UIViewController {

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
    private let viewModel: ProductsViewModel
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    private var isFiltered: Bool = false
    
    init() {
        viewModel = ProductsViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = ProductsViewModel()
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        configureCollectionView()
        configureTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(products)
        fetchProduct()
        print(products)
    }
    private func fetchProduct() {
        viewModel.networkService.requestProducts(){ result in
            if case .success(let data) = result {
                DispatchQueue.global(qos: .userInteractive).async {
                    UIView.animate(withDuration: 2) {
                        self.products = data.products
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
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
}

//MARK: - UICollecionViewDataSource / DelegateFlowLayout
extension ProductsViewController:
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
extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
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
extension ProductsViewController: UISearchBarDelegate {
    
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



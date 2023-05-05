//
//  TableViewCell.swift
//  CollectionViewHW
//
//  Created by Jarae on 4/5/23.
//

import UIKit

class CustomCell: UITableViewCell {
    static let reuseId = String(describing: CustomCell.self)
    static let nibName = String(describing: CustomCell.self)
    
    @IBOutlet weak var imageTV: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    func display(item: Product) {
        let data = try? Data(contentsOf: URL(string: item.thumbnail)!)
        imageTV.image = UIImage(data: data!)
        title.text = item.title
        rating.text = String(item.rating)
        price.text = "\(item.price)$"
        desc.text = item.description
    }
}

//        let url = URL(string: item.thumbnail)!
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//            DispatchQueue.main.async {
//                self.imageTV.image = UIImage(data: data!)
//            }
//        }

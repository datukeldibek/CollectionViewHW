//
//  CustomCellA.swift
//  CollectionViewHW
//
//  Created by Jarae on 4/5/23.
//

import UIKit

class CustomCellA: UICollectionViewCell {
    static let reuseId = String(describing: CustomCellA.self)
    static let nibName = String(describing: CustomCellA.self)
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!

    override func layoutSubviews() {
        setUpSubViews()
        imageView.image = UIImage(systemName: "star.fill")
        textLabel.text = "Delivery"
    }
    func setUpSubViews() {
        contentView.layer.cornerRadius = CGFloat(Constants.Corners.cornerRadius)
        contentView.backgroundColor = .orange
        imageView.tintColor = .white
        textLabel.textColor = .white
    }
}

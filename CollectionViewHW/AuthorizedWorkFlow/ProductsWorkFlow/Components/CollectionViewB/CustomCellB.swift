//
//  CustomCellB.swift
//  CollectionViewHW
//
//  Created by Jarae on 4/5/23.
//

import UIKit

class CustomCellB: UICollectionViewCell {
    static let reuseId = String(describing: CustomCellB.self)
    static let nibName = String(describing: CustomCellB.self)
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    func display(image: UIImage, text: String) {
        imageView.image = image
        textLabel.text = text
    }
}

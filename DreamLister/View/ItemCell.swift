//
//  ItemCell.swift
//  DreamLister
//
//  Created by Herbert Dodge on 6/10/21.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureCell(_ item: Item) {
        thumb.image = item.image?.image as? UIImage ?? UIImage(named: "imagePick")
        title.text = item.name
        price.text = "$ \(item.price)"
        details.text = item.details
    }

}

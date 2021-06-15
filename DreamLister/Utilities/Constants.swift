//
//  Constants.swift
//  DreamLister
//
//  Created by Herbert Dodge on 6/15/21.
//

import UIKit

enum Constants {
    static var materialKey: Bool = false
    static let ad = UIApplication.shared.delegate as! AppDelegate
    static let context = ad.persistentContainer.viewContext
    static let cellReuseId = "ItemCell"
    
    enum Segues {
        static let AddNewItem = "SegueAddNewItem"
        static let EditItem = "SegueEditItem"
    }
}

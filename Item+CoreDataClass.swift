//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Herbert Dodge on 6/10/21.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = Date()
    }
}

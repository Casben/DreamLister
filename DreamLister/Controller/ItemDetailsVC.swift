//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Herbert Dodge on 6/15/21.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var storePicker: UIPickerView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        storePicker.delegate = self
        storePicker.dataSource = self
//        generateStores()
        getStores()
        
        if itemToEdit != nil {
            loadExsistingData()
        }
    }

}

//MARK: - Actions

extension ItemDetailsVC {
    
    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        if itemToEdit != nil {
            item = itemToEdit
        } else {
            item = Item(context: Constants.context)
        }
        
        guard let title = titleField.text, !title.isEmpty, let price = priceField.text, !price.isEmpty else { return }
        
        item.name = title
        item.price = Double(price) ?? 0.0
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.store = stores[storePicker.selectedRow(inComponent: 0)]
        Constants.ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        if itemToEdit != nil {
            Constants.context.delete(itemToEdit!)
            Constants.ad.saveContext()
            navigationController?.popViewController(animated: true)
        } else {
            titleField.text = ""
            priceField.text = ""
            detailsField.text = ""
            storePicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
    }
}

//MARK: - UIPicker Setup

extension ItemDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
}

//MARK: - Retrieve Stores

extension ItemDetailsVC {
    func generateStores() {
        let store = Store(context: Constants.context)
        store.name = "Best Buy"
        
        let store1 = Store(context: Constants.context)
        store1.name = "Apple"
        
        let store2 = Store(context: Constants.context)
        store2.name = "Tesla Motors"
        
        let store3 = Store(context: Constants.context)
        store3.name = "CVS"
        
        let store4 = Store(context: Constants.context)
        store4.name = "Amazon"
        
        let store5 = Store(context: Constants.context)
        store5.name = "Lids"
        
        Constants.ad.saveContext()
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [nameSort]
        
        do {
            self.stores = try Constants.context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            print(error)
        }
    }
    
    func loadExsistingData() {
        if let item = itemToEdit {
            titleField.text = item.name
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumb.image = item.image?.image as? UIImage
            
            if let store = item.store {
                var index = 0
                repeat {
                    let storeName = stores[index]
                    if storeName.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }
}

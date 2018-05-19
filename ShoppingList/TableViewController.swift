//
//  TableViewController.swift
//  ShoppingList
//
//  Created by Ayla Fernandes on 5/19/18.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {

    var shoppingList: [ShoppingItem] = []
    let firestore = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = firestore.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestore.settings = settings
        loadShoppingItems()
        
//        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (timer) in
//            self.addShoppingItem()
//        }
    }
    
    func addShoppingItem() {
        
        print("Adicionando Uva")
        
        let data: [String: Any] = [
            "name": "Uva",
            "quantity": 5
        ]
        
        firestore.collection("ShoppingItem").addDocument(data: data) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func loadShoppingItems() {
        firestore.collection("ShoppingItem").order(by: "name", descending: false).addSnapshotListener { [weak self] (snapshot, error) in
            self?.showItems(snapshot: snapshot)
        }
    }
    
    func showItems(snapshot: QuerySnapshot?) {
        shoppingList.removeAll()
        guard let snapshot = snapshot else {return}
        print("Total de itens na lista: \(snapshot.documents.count)")
        for document in snapshot.documents {
            guard let name = document["name"] as? String else {return}
            guard let quantity = document["quantity"] as? Int else {return}
            let shoppingItem = ShoppingItem(name: name, quantity: quantity, document: document)
            shoppingList.append(shoppingItem)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let shoopingItem = shoppingList[indexPath.row]
        cell.textLabel?.text = shoopingItem.name
        cell.detailTextLabel?.text = "\(shoopingItem.quantity)"
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let shoppingItem = shoppingList[indexPath.row]
            print(shoppingItem.document.documentID)
            firestore.collection("ShoppingItem").document(shoppingItem.document.documentID).delete { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shoppingItem = shoppingList[indexPath.row]
        let data: [String: Any] = [
            "name": "Pão",
            "quantity": 15
        ]
        let documentID = shoppingItem.document.documentID
        firestore.collection("ShoppingItem").document(documentID).setData(data)
        
        
    }
    
    
}











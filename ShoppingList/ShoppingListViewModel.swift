//
//  ShoppingListViewModel.swift
//  ShoppingList
//
//  Created by David Salmberg on 2023-04-17.
//

import Foundation
import Firebase

class ShoppingListVM : ObservableObject {
    let db = Firestore.firestore()
    
    @Published var items = [Item]()
    
    func toggle(item: Item) {
        if let id = item.id {
            db.collection("items").document(id).updateData(["done" : !item.done])
        }
    }
    
    func saveToFirestore(itemName: String) {
        let item = Item(name: itemName)
        do {
            try db.collection("items").addDocument(from: item)
        } catch {
            print("Error to save")
        }
    }
    func listenToFirestore(){
        
        db.collection("items").addSnapshotListener() {
            Snapshot, err in
            
            guard let snapshot = Snapshot else {return}
            
            if let err = err {
                print("Error getting document\(err)")
            } else {
                self.items.removeAll()
                for document in snapshot.documents {
                    do {
                        let item = try document.data(as : Item.self)
                        self.items.append(item)
                    } catch {
                        print("Error reading from db")
                    }
                }
                
                
            }
        }
        
    }
}

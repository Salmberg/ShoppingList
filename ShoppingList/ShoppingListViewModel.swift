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
    let auth = Auth.auth()
    
    @Published var items = [Item]()
    
    func delete(index : Int) {
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("items")
        
        
        let item = items[index]
        if let id = item.id {
            itemsRef.document(id).delete()
        }
    }
    
    func toggle(item: Item) {
        
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("items")
        
        if let id = item.id {
            itemsRef.document(id).updateData(["done" : !item.done])
        }
    }
    
    func saveToFirestore(itemName: String) {
        
        
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("items")
        
        let item = Item(name: itemName)
        do {
            try itemsRef.addDocument(from: item)
        } catch {
            print("Error to save")
        }
    }
    func listenToFirestore(){
        guard let user = auth.currentUser else {return}
        let itemsRef = db.collection("users").document(user.uid).collection("items")
        
        itemsRef.addSnapshotListener() {
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

//
//  ContentView.swift
//  ShoppingList
//
//  Created by David Salmberg on 2023-04-17.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
   @StateObject var shoppingListVM = ShoppingListVM()
    
    var body: some View {
        VStack {
          
            List {
                ForEach(shoppingListVM.items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Button(action: {
                            shoppingListVM.toggle(item: item)
                            
                        }) {
                            Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                        }
                        
                    }
                    
                }
            }
            
            
        }.onAppear(){
            shoppingListVM.listenToFirestore()
        }
    }
    
 
        
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

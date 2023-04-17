//
//  ContentView.swift
//  ShoppingList
//
//  Created by David Salmberg on 2023-04-17.
//

import SwiftUI
import Firebase

struct ContentView : View {
    
    @State var singedIn = false
    
    var body : some View {
        if !singedIn {
            SignInView(signedIn: $singedIn)
        }else {
            ShoppingListView()
        }
    }
}


struct SignInView : View {
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body : some View {
        Button(action: {
            auth.signInAnonymously { result, error in
                if let error = error {
                    print("Error signing in")
                    
                } else{
                    signedIn = true
                }
            }
            
        }) {
            Text("Sign in")
        }
    }
}

struct ShoppingListView: View {
    
   @StateObject var shoppingListVM = ShoppingListVM()
    
    var body: some View {
        VStack {
          
            List {
                ForEach(shoppingListVM.items) { item in
                    RowView(item: item, vm: shoppingListVM)
                }
            }
            
        }.onAppear(){
            shoppingListVM.listenToFirestore()
        }
    }

    }

struct RowView: View {
    let item : Item
    let vm : ShoppingListVM
    
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Button(action: {
                vm.toggle(item: item)
                
            }) {
                Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

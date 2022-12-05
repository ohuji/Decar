//
//  FurnitureMenu.swift
//  DecAR
//
//  Created by iosdev on 19.11.2022.
//

import SwiftUI

class SelectedFurniture: Codable {
    var modelName: String
    var id = UUID().uuidString
    
    init(_ modelName: String) {
        self.modelName = modelName
    }
    
}

struct FurnitureMenu: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var isPresented: Bool
    
    @State private var currentId = 0
    @State var currentObject: SelectedFurniture = SelectedFurniture("stool")
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Furniture.furnitureName , ascending: true)],
        animation: .default)
    private var furnitures: FetchedResults<Furniture>
        
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "arrow.backward")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(red: 187/255, green: 138/255, blue: 82/255))
                .frame(width: 32, height: 32)
            }
            .padding(.leading, 30)
            .padding(.top, 10)
            List {
                ForEach(furnitures) { furniture in
                    Button(furniture.furnitureName!, action: {
                        currentObject = SelectedFurniture( furniture.modelName!)
                        
                        let appFurniture = UserDefaults.standard
                        appFurniture.set(furniture.modelName, forKey: "AppCurrentObject")
     
                         isPresented = false
                    })
                    .foregroundColor(.white)
                }
                .listRowBackground(Color(red: 109/255, green: 151/255, blue: 115/255))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
       // .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 12/255, green: 59/255, blue: 46/255))
        //.listStyle(.automatic)
        .listStyle(.sidebar)
        .edgesIgnoringSafeArea(.all)
    }
}
/*
struct FurnitureMenu_Previews: PreviewProvider {
    static var previews: some View {
<<<<<<< Updated upstream
        FurnitureMenu(showFurMenu: .constant(true))
=======
//        FurnitureMenu()
>>>>>>> Stashed changes
    }
}
*/

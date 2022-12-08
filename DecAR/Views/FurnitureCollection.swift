//
//  FurnitureCollection.swift
//  DecAR
//
//  Created by iosdev on 23.11.2022.
//

import Foundation
import SwiftUI
import CoreData

let furnitureNameLoc = NSLocalizedString("FURNITURE_NAME", comment: "furnitureName")
let furnitureAlertAddFurniture = NSLocalizedString("FURNITURE_ALERT_ADD_FURNITURE", comment: "furnitureAlertAddFurniture")
let furnitureFurnitureName = NSLocalizedString("FURNITURE_FURNITURE_NAME", comment: "furnitureFurnitureName")
let furnitureEnterFurnitureDetails = NSLocalizedString("FURNITURE_ENTER_FURNITURE_DETAILS", comment: "furnitureEnterFurnitureDetails")
let furnitureSelectItem = NSLocalizedString("FURNITURE_SELECT_ITEM", comment: "furnitureSelectItem")
let furnitureAddBtn = NSLocalizedString("LISTINGS_ADD_BTN", comment: "listingsAddBtn")
let furnitureCancelBtn = NSLocalizedString("LISTINGS_CANCEL_BTN", comment: "listingsAddBtn")
let furniture3dModel = NSLocalizedString("FURNITURE_3D_MODEL", comment: "furniture3dModel")
let furnitureCategory = NSLocalizedString("FURNITURE_CATEGORY", comment: "furnitureCategory")
let furnitureFurnitureCategory = NSLocalizedString("FURNITURE_FURNITURE_CATEGORY", comment: "furnitureFurnitureCategory")
let furniture3dModelName = NSLocalizedString("FURNITURE_3D_MODEL_NAME", comment: "furniture3dModelName")

struct FurnitureCollectionView: View {
    @State private var presentAlert = false
    @State private var furnitureName: String = ""
    @State private var modelName: String = ""
    @State private var category: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Furniture.furnitureName , ascending: true)],
        animation: .default)
    private var furnitures: FetchedResults<Furniture>
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(named: "PrimaryColor")
        UITableView.appearance().backgroundColor = UIColor(named: "PrimaryColor")
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(furnitures) { furniture in
                    NavigationLink {
                        Text("\(furnitureNameLoc) \(furniture.furnitureName!)")
                        Text("\(furniture3dModel): \(furniture.modelName!)")
                        Text("\(furnitureCategory): \(furniture.category!)")
                    } label: {
                        Text(furniture.furnitureName!)
                    }
                }
                .onDelete(perform: deleteItems)
                .listRowBackground(Color("SecondaryColor"))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                        Button(furnitureAddBtn) {
                        presentAlert = true
                    }
                        .popover(isPresented: self.$presentAlert, arrowEdge: .bottom) {
                        Text(furnitureAlertAddFurniture)
                        TextField(furnitureFurnitureName, text: $furnitureName)
                        TextField(furnitureFurnitureCategory, text: $category)
                        TextField(furniture3dModelName, text: $modelName)

                        Button(furnitureAddBtn, action: {
                            let newFurniture = Furniture(context: viewContext)
                            newFurniture.furnitureName = furnitureName
                            newFurniture.category = category
                            newFurniture.modelName = modelName

                            do {
                                try viewContext.save()
                                self.presentAlert = false
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        })
                            Button(listingsBtnCancel, action: {
                                self.presentAlert = false
                            })
                    }
                    }
            }
            Text(furnitureSelectItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { furnitures[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct FurnitureCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentObject: .constant(SelectedFurniture("stool"))).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

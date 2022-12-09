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
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(furnitureNameLoc) \(furniture.furnitureName!)")
                                    .foregroundColor(Color.accentColor)
                                Text("\(furniture3dModel): \(furniture.modelName!)")
                                    .foregroundColor(Color.accentColor)
                                Text("\(furnitureCategory): \(furniture.category!)")
                                    .foregroundColor(Color.accentColor)
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color("PrimaryColor"))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
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
                            VStack() {
                                Text(furnitureAlertAddFurniture)
                                    .bold()
                                    .padding(.bottom, 100)
                                    .padding(.top, 100)
                                    .foregroundColor(Color.accentColor)
                                    .font(.system(size: 40))
                                Text(furnitureFurnitureName)
                                    .foregroundColor(Color.accentColor)
                                    .padding(.leading, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                TextField(furnitureFurnitureName, text: $furnitureName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(10)
                                Text(furnitureFurnitureCategory)
                                    .foregroundColor(Color.accentColor)
                                    .padding(.leading, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                TextField(furnitureFurnitureCategory, text: $category)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(10)
                                Text(furniture3dModelName)
                                    .foregroundColor(Color.accentColor)
                                    .padding(.leading, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                TextField(furniture3dModelName, text: $modelName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(10)
                                    .padding(.bottom, 50)
                                HStack {
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
                                    .padding(15)
                                    .background(Color.green)
                                    .foregroundColor(Color.white)
                                    .clipShape(Capsule())
                                    
                                    Button(listingsBtnCancel, action: {
                                        self.presentAlert = false
                                    })
                                    .padding(15)
                                    .background(Color.red)
                                    .foregroundColor(Color.white)
                                    .clipShape(Capsule())
                                }
                                Spacer()
                            }
                            .background(Color("PrimaryColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
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

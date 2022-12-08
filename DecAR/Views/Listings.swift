//
//  Listings.swift
//  DecAR
//
//  Created by iosdev on 20.11.2022.
//

import Foundation
import SwiftUI
import CoreData

let listingsClientName = NSLocalizedString("LISTINGS_CLIENT_NAME", comment: "listingsClientName")
let listingsClientAddress = NSLocalizedString("LISTINGS_CLIENT_ADDRESS", comment: "listingsClientAddress")
let listingsAddBtn = NSLocalizedString("LISTINGS_ADD_BTN", comment: "listingsAddBtn")
let listingsAlertAddListing = NSLocalizedString("LISTINGS_ALERT_ADD_LISTING", comment: "listingsAlertAddListing")
let listingsClientName2 = NSLocalizedString("LISTINGS_CLIENT_NAME_2", comment: "listingsClientName2")
let listingsClientAddress2 = NSLocalizedString("LISTINGS_CLIENT_ADDRESS_2", comment: "listingsClientAddress2")
let listingsBtnCancel = NSLocalizedString("LISTINGS_CANCEL_BTN", comment: "listingsBtnCancel")
let listingsDetails = NSLocalizedString("LISTINGS_DETAILS", comment: "listingsDetails")
let listingsSelectItem = NSLocalizedString("LISTINGS_SELECT_ITEM", comment: "listingsSelectItem")

struct ListingsView: View {
    @State private var presentAlert = false
    @State private var clientName: String = ""
    @State private var clientAddress: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Listing.clientName!, ascending: true)],
        animation: .default)
    private var listings: FetchedResults<Listing>
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(named: "PrimaryColor")
        UITableView.appearance().backgroundColor = UIColor(named: "PrimaryColor")
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(listings) { listing in
                    NavigationLink {
                        Text("\(listingsClientName) \(listing.clientName!)")
                        Text("\(listingsClientAddress) \(listing.clientAddress!)")
                    } label: {
                        Text(listing.clientName!)
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
                        Button(listingsAddBtn) {
                        presentAlert = true
                    }
                        .popover(isPresented: self.$presentAlert, arrowEdge: .bottom) {
                            Text(listingsAlertAddListing)
                            TextField(listingsClientName2, text: $clientName)
                            TextField(listingsClientAddress2, text: $clientAddress)
                            Button(listingsAddBtn, action: {
                                let newListing = Listing(context: viewContext)
                                newListing.clientName = clientName
                                newListing.clientAddress = clientAddress
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
                     
            Text(listingsSelectItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { listings[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ListingsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentObject: .constant(SelectedFurniture("stool"))).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

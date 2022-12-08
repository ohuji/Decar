//
//  Menu.swift
//  DecAR
//
//  Created by iosdev on 19.11.2022.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation
import Combine

let menuMapText:LocalizedStringKey = "MENU_MAP_TEXT"
let menuInstructionsText:LocalizedStringKey = "MENU_INSTRUCTIONS_TEXT"
let menuFurnitureText:LocalizedStringKey = "MENU_FURNITURE_TEXT"
let menuListingsText:LocalizedStringKey = "MENU_LISTINGS_TEXT"

struct Menu: View {
    @State private var showingAlert = false
    @State private var author = "No author :("
    @State private var quoteValue = "No Quote :("
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("decar_logo_1")
                .resizable()
                .scaledToFit()
                .padding(.top, 70)
            HStack {

              NavigationLink(destination: MapView()) {
                    Image(systemName: "map")
                        .foregroundColor(Color.accentColor)
                        .imageScale(.large)
                    Text(menuMapText)
                            .foregroundColor(.white)
                            .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {

                NavigationLink(destination: Instructions()) {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(Color.accentColor)
                        .imageScale(.large)
                    Text(menuInstructionsText)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {
                NavigationLink(destination: FurnitureCollectionView()) {
                    Image(systemName: "bed.double")
                        .foregroundColor(Color.accentColor)
                        .imageScale(.large)
                    Text(menuFurnitureText)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {
                NavigationLink(destination: ListingsView()) {
                    Image(systemName: "house")
                        .foregroundColor(Color.accentColor)
                        .imageScale(.large)
                    Text(menuListingsText)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {
                Image(systemName: "quote.bubble")
                    .foregroundColor(Color.accentColor)
                    .imageScale(.large)
                Button("Breaking Bad") {
                    self.showingAlert = true
                }
                .foregroundColor(.white)
                .alert(isPresented: $showingAlert) {
                    return Alert(title: Text(self.quoteValue).foregroundColor(.white), message: Text("- \(self.author)"), dismissButton: .default(Text("Got it!")))
                }
            }
            .padding(.top, 30)
            Spacer()
        }
        .onAppear {
            getQuote(quoteCompletionHandler: { quote, error in
                if let quote = quote {
                    self.author = quote.author
                    self.quoteValue = quote.quote
                }
                
            })
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("PrimaryColor"))
        .listStyle(.sidebar)
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}


//
//  Menu.swift
//  DecAR
//
//  Created by iosdev on 19.11.2022.
//

import SwiftUI

let menuMapText:LocalizedStringKey = "menuMapText"
let menuSettingsText:LocalizedStringKey = "menuSettingsText"
let menuFurnitureText:LocalizedStringKey = "menuFurnitureText"
let menuListingsText:LocalizedStringKey = "menuListingsText"


struct Menu: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("decar_logo_1")
                .resizable()
                .scaledToFit()
                .padding(.top, 70)
            HStack {

                NavigationLink(destination: MapView()) {
                    Image(systemName: "map")
                        .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                        .imageScale(.large)
                    Text(menuMapText)
                            .foregroundColor(.white)
                            .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {

                NavigationLink(destination: Settings()) {
                    Image(systemName: "gear")
                        .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                        .imageScale(.large)
                    Text(menuSettingsText)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            HStack {
                NavigationLink(destination: FurnitureCollectionView()) {
                    Image(systemName: "bed.double")
                        .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
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
                        .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                        .imageScale(.large)
                    Text(menuListingsText)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding(.top, 30)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 12/255, green: 59/255, blue: 46/255))
        .listStyle(.sidebar)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}


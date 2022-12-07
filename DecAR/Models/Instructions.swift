//
//  Settings.swift
//  DecAR
//
//  Created by iosdev on 20.11.2022.
//

import SwiftUI

struct Instructions: View {
    var body: some View {
        VStack(alignment: .leading) {
            
        }
        Spacer()
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 12/255, green: 59/255, blue: 46/255))
        .listStyle(.sidebar)
        .edgesIgnoringSafeArea(.all)
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        Instructions()
    }
}


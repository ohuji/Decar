//
//  Settings.swift
//  DecAR
//
//  Created by iosdev on 20.11.2022.
//

import SwiftUI

//Localization variables
let instructionAddTitle:LocalizedStringKey = "INSTRUCTIONS_ADD_TITLE"
let instructionAddDesc:LocalizedStringKey = "INSTRUCTIONS_ADD_DESC"
let instructionRemoveTitle:LocalizedStringKey = "INSTRUCTIONS_REMOVE_TITLE"
let instructionRemoveDesc:LocalizedStringKey = "INSTRUCTIONS_REMOVE_DESC"
let instructionMoveTitle:LocalizedStringKey = "INSTRUCTIONS_MOVE_TITLE"
let instructionMoveDesc:LocalizedStringKey = "INSTRUCTIONS_MOVE_DESC"
let instructionLoadTitle:LocalizedStringKey = "INSTRUCTIONS_LOAD_TITLE"
let instructionLoadDesc:LocalizedStringKey = "INSTRUCTIONS_LOAD_DESC"
let instructionSaveTitle:LocalizedStringKey = "INSTRUCTIONS_SAVE_TITLE"
let instructionSaveDesc:LocalizedStringKey = "INSTRUCTIONS_SAVE_DESC"

struct Instructions: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(menuInstructionsText)
                .foregroundColor(Color("DetailColor"))
                .bold()
                .font(.system(size: 23))
                .padding(.top, 37)
            
            Group {
                Text(instructionAddTitle)
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 20)
                Text(instructionAddDesc)
                    .foregroundColor(.white)
                    .padding(.top, 1)
                
                Text(instructionRemoveTitle)
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text(instructionRemoveDesc)
                    .foregroundColor(.white)
                    .padding(.top, 1)
                
                Text(instructionMoveTitle)
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text(instructionMoveDesc)
                    .foregroundColor(.white)
                    .padding(.top, 1)
                
                Text(instructionSaveTitle)
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text(instructionSaveDesc)
                    .foregroundColor(.white)
                    .padding(.top, 1)
                
                Text(instructionLoadTitle)
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text(instructionLoadDesc)
                    .foregroundColor(.white)
                    .padding(.top, 1)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("PrimaryColor"))
        .listStyle(.sidebar)
        .edgesIgnoringSafeArea(.all)
    }
}

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        Instructions()
    }
}


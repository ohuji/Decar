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
            Text("Instructions")
                .foregroundColor(Color(red: 187/255, green: 138/255, blue: 82/255))
                .bold()
                .font(.system(size: 23))
                .padding(.top, 37)
            
            Group {
                Text("Add furniture")
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 20)
                Text("Add furniture by tapping the screen")
                    .foregroundColor(.white)
                    .padding(.top, 1)
                
                Text("Remove furniture")
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text("Remove furniture by long pressing furniture object (No moving allowed)")
                    .foregroundColor(.white)
                    .padding(.top, 1)
                
                Text("Move furniture")
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text("Move furniture by touching the object and moving it with your finger")
                    .foregroundColor(.white)
                    .padding(.top, 1)
                
                Text("Save experince")
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text("Save current experience by touching the screen with two fingers and rotating them clock wise in a circular motion")
                    .foregroundColor(.white)
                    .padding(.top, 1)
                
                Text("Load experience")
                    .foregroundColor(Color(red: 255/255, green: 186/255, blue: 0/255))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                Text("Load the last saved experience by long pressing the screen with two fingers")
                    .foregroundColor(.white)
                    .padding(.top, 1)
            }
            
            Spacer()
        }
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


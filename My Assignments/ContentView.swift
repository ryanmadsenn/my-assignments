//
//  ContentView.swift
//  My Assignments
//
//  Created by Ryan Madsen on 9/19/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack() {
            HStack() {
                Image("Clipboard Symbol")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: 40.0)
                Text("My Assignments")
                    .font(.largeTitle)
            }
            List {
                HStack {
                Text("Thing")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3.0, x: 1.0, y: 1.0)
                HStack {
                    
                Text("Thing")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3.0, x: 1.0, y: 1.0)
                HStack {
                    
                Text("Thing")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3.0, x: 1.0, y: 1.0)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

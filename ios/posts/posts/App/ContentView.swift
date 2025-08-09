//
//  ContentView.swift
//  posts
//
//  Created by Willians Varela on 09/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .imageScale(.large)
                .foregroundStyle(.cyan)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

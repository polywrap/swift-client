//
//  ContentView.swift
//  HelloWorld
//
//  Created by Jure Granić-Skender on 07.08.2023..
//

import SwiftUI
import PolywrapClient

struct GetArgs: Codable {
    var url: String
}

struct Response: Codable {
    var body: String
    var status: Int
}

struct ContentView: View {
    @State private var url: String = "https://www.example.com/"
    @State private var respBody: String = ""
    
    func httpGet(msg: String) -> String {
        do {
            let client = BuilderConfig()
                .addSystemDefault()
                .addWeb3Default()
                .build()
            
            let uri = try Uri("wrapscan.io/polywrap/http@1.0")
            
            let result: Response = try client.invoke(
                uri: uri,
                method: "get",
                args: GetArgs(url: "https://example.com/")
            )
            
            print(result.body)
            
            return result.body
        } catch {
            print("\(error)")
            return "An error has occured. See console for details."
        }
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center){
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, HTTP!")
                TextField("Url", text: $url)
                    .textFieldStyle(.roundedBorder)
                Button("Get", action: {
                    respBody = httpGet(msg: url)
                })
                .buttonStyle(.bordered)
                Text("Response body:")
                Text("\(respBody)")
                    .monospaced()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

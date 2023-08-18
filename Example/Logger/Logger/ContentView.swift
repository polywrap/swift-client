//
//  ContentView.swift
//  Logger
//
//  Created by Cesar Brazon on 16.08.2023..
//

import SwiftUI
import PolywrapClient
import LoggerPlugin

struct LogMessageArgs: Codable {
    var message: String
}

struct ContentView: View {
    @State private var message: String = "Hello from console!"
    @State private var isError: Bool = false
    @State private var invocationDone: Bool = false

    func showLog(msg: String) {
        do {
            let wrapUri = try Uri("wrapscan.io/polywrap/logging@1.0.0")
            let pluginUri = try Uri("wrapscan.io/polywrap/logger@1.0")
            
            let loggerPlugin = getLoggerPlugin(nil)
            
            let client = BuilderConfig()
                .addSystemDefault()
                .addInterfaceImplementation(pluginUri, pluginUri)
                .addPackage(pluginUri, PluginPackage(loggerPlugin))
                .build()
                        
            let result: Bool = try client.invoke(
                uri: wrapUri,
                method: "info",
                args: LogMessageArgs(message: msg)
            )
            
            if !result {
                isError = true
            } else {
                invocationDone = true
            }
        } catch {
            print("\(error)")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center){
                Image(systemName: "link")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, World!")
                TextField("Message", text: $message)
                    .textFieldStyle(.roundedBorder)
                Button("Get", action: {
                    showLog(msg: message)
                })
                .buttonStyle(.bordered)
                if isError {
                    Text("Error in invocation. Check console")
                }
                
                if invocationDone {
                    Text("Invocation done! See message in console")
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

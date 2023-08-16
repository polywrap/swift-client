//
//  ContentView.swift
//  IpfsExample
//
//  Created by Jure Granić-Skender on 08.08.2023..
//

import SwiftUI
import PolywrapClient

struct CatArgs: Codable {
    var cid: String
    var ipfsProvider: String
}

struct ResolveArgs: Codable {
    var cid: String
    var ipfsProvider: String
}

struct ResolveResult: Codable {
    var cid: String
    var provider: String
}

struct ContentView: View {
    @State private var cid: String = "QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR"
    @State private var respData: Data = Data([])
    
    func ipfsGet(cid: String) -> Data {
        do {
            let client = BuilderConfig()
                .addSystemDefault()
                .build()
            
            let uri = try Uri("wrapscan.io/polywrap/ipfs-http-client@1.0")
            
            let resolveResult: ResolveResult = try client.invoke(
                uri: uri,
                method: "resolve",
                args: ResolveArgs(
                    cid: cid,
                    ipfsProvider: "https://ipfs.io/"
                )
            )
            
            print("\(resolveResult)")
            
            let catResult: Data = try client.invoke(
                uri: uri,
                method: "cat",
                args: CatArgs(
                    cid: resolveResult.cid,
                    ipfsProvider: resolveResult.provider
                )
            )
            
            print("\(catResult)")
            
            return catResult
        } catch {
            print("\(error)")
            return Data([])
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "folder")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, IPFS!")
                TextField("CID", text: $cid)
                    .textFieldStyle(.roundedBorder)
                Button("Cat file", action: {
                    respData = ipfsGet(cid: cid)
                })
                .buttonStyle(.bordered)
                Text("File contents:")
                ByteRenderView(data: respData)
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

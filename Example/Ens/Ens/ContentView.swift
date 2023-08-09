//
//  ContentView.swift
//  Ens
//
//  Created by Jure Granić-Skender on 09.08.2023..
//

import SwiftUI
import PolywrapClient

struct GetResolverArgs: Codable {
    var registryAddress: String
    var domain: String
}

struct GetOwnerArgs: Codable {
    var resolverAddress: String
    var domain: String
}

struct GetAddressArgs: Codable {
    var resolverAddress: String
    var domain: String
}

struct EnsDomainInfo {
    var owner: String
    var resolver: String
    var address: String
}

struct ContentView: View {
    @State private var ensDomain: String = "wraps.eth"
    @State private var registryAddress: String = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"
    @State private var resolver: String = ""
    @State private var owner: String = ""
    @State private var address: String = ""
    
    func getEnsInfo(ensDomain: String, registryAddress: String) -> EnsDomainInfo {
        do {
            let client = BuilderConfig()
                .addSystemDefault()
                .addWeb3Default()
                .build()
            let uri = try Uri("wrapscan.io/polywrap/ens@1.0")
            let resolver: String = try client.invoke(
                uri: uri,
                method: "getResolver",
                args: GetResolverArgs(
                    registryAddress: registryAddress,
                    domain: ensDomain
                )
            )
            
            print("Resolver: \(resolver)")
            
            // Commented out due to an issue with invoking getOwner
            // It seems that the args are not properly passed.
            /*
             let owner: String = try client.invoke(
             uri: uri,
             method: "getOwner",
             args: GetOwnerArgs(
             resolverAddress: resolver,
             domain: ensDomain
             )
             )
             */
            
            let address: String = try client.invoke(
                uri: uri,
                method: "getAddress",
                args: GetAddressArgs(
                    resolverAddress: resolver,
                    domain: ensDomain
                )
            )
            
            print("Address: \(address)")
            
            return EnsDomainInfo(
                owner: "not yet supported",
                resolver: resolver,
                address: address
            )
        } catch {
            print("\(error)")
            return EnsDomainInfo(
                owner: "error",
                resolver: "error",
                address: "error"
            )
        }
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center){
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, ENS!")
                TextField("Registry address", text: $registryAddress)
                    .textFieldStyle(.roundedBorder)
                TextField("Domain", text: $ensDomain)
                    .textFieldStyle(.roundedBorder)
                Button("Get", action: {
                    let info = getEnsInfo(
                        ensDomain: ensDomain,
                        registryAddress: registryAddress
                    )
                    resolver = info.resolver
                    owner = info.owner
                    address = info.address
                })
                .buttonStyle(.bordered)
                
                Group {
                    Text("Resolver:")
                    Text("\(resolver)")
                        .monospaced()
                }
                
                Group {
                    Text("Owner:")
                    Text("\(owner)")
                        .monospaced()
                }
                Group {
                    Text("Address:")
                    Text("\(address)")
                        .monospaced()
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

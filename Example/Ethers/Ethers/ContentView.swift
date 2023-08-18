//
//  ContentView.swift
//  Ethers
//
//  Created by Jure Granić-Skender on 09.08.2023..
//

import SwiftUI
import MetamaskProviderPlugin
import metamask_ios_sdk

struct ContentView: View {
    @ObservedObject var ethereum: Ethereum = MetaMaskSDK.shared.ethereum
    private let dapp = Dapp(name: "Ethers demo dApp", url: "")
    @State private var metamaskProvider: MetamaskProvider? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "key")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, Ethers!")
                Text("This example can only be run on a device which has Metamask installed. You can run it on your iOS device.")
                
                if ethereum.selectedAddress != "" && metamaskProvider != nil {
                    EthersExampleView(metamaskProvider: metamaskProvider!)
                } else {
                    Button("Connect with Metamask", action: {
                        connect()
                    })
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
    
    func connect() {
        let provider = getMetamaskProviderPlugin()
        provider.connect(ethereum: ethereum, dapp: dapp)
        metamaskProvider = provider
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

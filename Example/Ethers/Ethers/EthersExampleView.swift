//
//  EthersExampleView.swift
//  Ethers
//
//  Created by Jure Granić-Skender on 09.08.2023..
//

import SwiftUI
import MetamaskProviderPlugin
import PolywrapClient


struct Payload: Codable {
    var domain: [String: KnownCodable]
    var primaryType: String
    var types: [String: [[String: String]]]
    var message: [String: KnownCodable]
}

struct SignTypedDataArgs: Codable {
    var payload: String
}


let typeDefs = [
    "EIP712Domain": [
        [
            "name": "name",
            "type": "string"
        ],
        [
            "type": "string",
            "name": "version"
        ],
        [
            "type": "uint256",
            "name": "chainId",
        ],
        [
            "type": "address",
            "name": "verifyingContract"
        ]
    ],
    "Person": [
        [
            "name": "name",
            "type": "string",
        ],
        [
            "name": "wallet",
            "type": "address"
        ]
    ],
    "Mail": [
        [
            "name": "from",
            "type": "Person"
        ],
        [
            "name": "to",
            "type": "Person"
        ],
        [
            "name": "contents",
            "type": "string"
        ]
    ]
]

let domain: [String: KnownCodable] = [
    "name": .string("Ether Mail"),
    "version": .string("1"),
    "chainId": .int(1),
    "verifyingContract": .string("0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC")
]

let message: [String: KnownCodable] = [
    "from": .dict([
        "name": .string("Cow"),
        "wallet": .string("0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826")
    ]),
    "to": .dict([
        "name": .string("Bob"),
        "wallet": .string("0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB")
    ]),
    "contents": .string("Hello Bob!")
]

let payload = Payload(
    domain: domain,
    primaryType: "Mail",
    types: typeDefs,
    message: message
)


func encodeToJSONString<T: Codable>(_ value: T) -> String? {
    print("encode")
    let encoder = JSONEncoder()
    
    do {
        print(value)
        let jsonData = try encoder.encode(value)
        print("managed to encode")
        let stringified = String(data: jsonData, encoding: .utf8)
        return stringified
    } catch {
        print("Error encoding to JSON: \(error)")
        return nil
    }
}

struct EthersExampleView: View {
    var metamaskProvider: MetamaskProvider
    
    @State private var signedTypeData: String = ""
    
    func getSignedTypeData(payload: Payload) -> String {
        do {
            print("Get client")
            let pluginUri = try Uri("wrapscan.io/polywrap/ethereum-wallet@1.0")

            let client = BuilderConfig()
                .addSystemDefault()
                .addPackage(try Uri("plugin/swift-provider"), PluginPackage(metamaskProvider))
                .addRedirect(try Uri("plugin/ethereum-wallet@1.0"), try Uri("plugin/swift-provider"))
                .build()
            
            print("Invoke")
            
            let signedTypeData: String = try client.invoke(
                uri: try Uri("wrapscan.io/polywrap/ethers@1.0"),
                method: "signTypedData",
                args: SignTypedDataArgs(payload: encodeToJSONString(payload)!)
            );
            
            print("returning signed type data")
            
            return signedTypeData;
        } catch {
            print("\(error)")
            return "Invocation error. See console for details.";
        }
    }
    
    var body: some View {
        VStack{
            Text("Connected to Metamask")
            Button("Get signed type data", action: {
                signedTypeData = getSignedTypeData(payload: payload)
            })
            .buttonStyle(.borderedProminent)
            Text("Signed type data:")
            Text(signedTypeData)
                .monospaced()
        }
    }
}

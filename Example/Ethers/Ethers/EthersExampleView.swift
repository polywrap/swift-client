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
    let encoder = JSONEncoder()
    
    do {
        let jsonData = try encoder.encode(value)
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
    @State private var isExecuting = false

    // When interacting with a plugin that uses runBlocking
    // https://github.com/polywrap/ethereum-wallet/blob/main/implementations/swift/metamask/Source/MetamaskProvider.swift#L140
    // we need to make the function async to guarantee that the UI does not get blocked
    func getSignedTypeData(payload: Payload) async -> String {
        do {
            let pluginUri = try Uri("wrapscan.io/polywrap/ethereum-wallet@1.0")

            let client = BuilderConfig()
                .addSystemDefault()
                .addPackage(try Uri("plugin/swift-provider"), PluginPackage(metamaskProvider))
                .addRedirect(try Uri("plugin/ethereum-wallet@1.0"), try Uri("plugin/swift-provider"))
                .build()

            let signedTypeData: String = try client.invoke(
                uri: try Uri("wrapscan.io/polywrap/ethers@1.0"),
                method: "signTypedData",
                args: SignTypedDataArgs(payload: encodeToJSONString(payload)!)
            );

            return signedTypeData;
        } catch {
            print("\(error)")
            return "Invocation error. See console for details.";
        }
    }
    
    var body: some View {
        VStack{
            Text("Connected to Metamask")
            if isExecuting {
                ProgressView()
                    .frame(width: 50, height: 50)
            } else {
                Button("Get signed type data", action: {
                    // When consuming an async method, we need to use the Task construct to handle the asynchronous computation
                    Task {
                        isExecuting = true
                        defer { isExecuting = false }
                        signedTypeData = await getSignedTypeData(payload: payload)
                    }
                }).buttonStyle(.borderedProminent)
            }
            Text("Signed type data:")
            Text(signedTypeData)
                .monospaced()
        }
    }
}

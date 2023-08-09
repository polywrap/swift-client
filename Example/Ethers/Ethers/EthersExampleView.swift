//
//  EthersExampleView.swift
//  Ethers
//
//  Created by Jure Granić-Skender on 09.08.2023..
//

import SwiftUI
import MetamaskProviderPlugin
import PolywrapClient

struct Domain: Codable {
    var name: String
    var version: String
    var chainId: UInt
    var verifyingContract: String
}

struct Person: Codable {
    var name: String
    var wallet: String
}

struct Mail: Codable {
    var from: Person
    var to: Person
    var contents: String
}

struct Payload: Codable {
    var domain: Domain
    var primaryType: String
    var types: AllTypeDefs
    var message: Mail
}

struct TypeDef: Codable {
    var name: String
    var type: String
}

struct AllTypeDefs: Codable {
    var EIP712Domain: [TypeDef]
    var Person: [TypeDef]
    var Mail: [TypeDef]
}

struct SignTypedDataArgs: Codable {
    var payload: String
}

let typeDefs = AllTypeDefs(
    EIP712Domain: [
        TypeDef(name: "name", type: "string"),
        TypeDef(name: "version", type: "string"),
        TypeDef(name: "chainId", type: "uint256"),
        TypeDef(name: "verifyingContract", type: "address"),
    ],
    Person: [
        TypeDef(name: "name", type: "string"),
        TypeDef(name: "wallet", type: "string"),
    ],
    Mail: [
        TypeDef(name: "from", type: "Person"),
        TypeDef(name: "to", type: "Person"),
        TypeDef(name: "contents", type: "string"),
    ]
)

let domain = Domain(
    name: "Ether Mail",
    version: "1",
    chainId: 1,
    verifyingContract: "0xcccccccccccccccccccccccccccccccccccccccc"
)

let message = Mail(
    from: Person(
        name: "Alice",
        wallet: "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    ),
    to: Person(
        name: "Bob",
        wallet: "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
    ),
    contents: "Hello Bob. I'm Alice."
)

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
        let jsonData = try encoder.encode(value)
        print("managed to encode")
        return String(data: jsonData, encoding: .utf8)
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
            let client = BuilderConfig()
                .addSystemDefault()
                .addPackage(try Uri("wrapscan.io/polywrap/ethereum-wallet@1.0"), PluginPackage(metamaskProvider))
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

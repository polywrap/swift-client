# Polywrap Swift Client Examples

To run the example project, clone this repository, go to ./Example directory, and then run `pod install` from the Example directory to install the SDK as dependencies, then open example.xcworkspace in xcode and you will be able to select which example would you like to run, in targets.

You will probably need to modify the Signing team and the Bundle Identifier to be able to run the example project. You can use the same Bundle identifier for every app.

## Example Apps

### Http

Invokes the http plugin to do a GET request, getting the HTML from a website

### IPFS

Invokes the IPFS wrap, fetching an image and showing it

### Logger

Invokes the logger wrap, which interacts with the logger plugin. It shows a println message from WASM world

### Ethers

Invoke the Ethers wrap, and signs a typed data using Metamask App; this can only be run in a device (you must have Metamask installed in your phone). By using the ethereum wallet plugin for metamask it shows you how you can write to Ethereum blockchain

### ENS

Invoke the ENS wrap, and gets the information from `vitalik.eth` domain. This uses the default ethereum wallet plugin, which allows you to read
information from blockchain
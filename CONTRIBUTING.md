# Contributing
Thank you for considering contributing to the Polywrap Swift client! 

Contributions are more than welcome. If you find a bug or have suggestions for improvements, please open an issue. And if you'd like to contribute code, we would be happy to review a pull request, also, feel free to look through this repository's [issues](https://github.com/polywrap/swift-client/issues) to see what we're focused on solving.

## Pre-Requisites
To be able to fully build and test all functionality within the Swift Client, you will need to run this project in a macOS environment.

## Build

To build the swift package, you will need to run:
```sh
xcodebuild -scheme PolywrapClient -derivedDataPath Build/ -destination 'platform=macOS' clean build
```

It's worth mentioning that you can also set the platform to any simulator and/or device connected

## Testing

You can run tests by running:
```
xcodebuild -scheme PolywrapClient -derivedDataPath Build/ -destination 'platform=macOS' -enableCodeCoverage YES test
```


## Feedback and Discussions
For questions, suggestions, or discussions, open an issue or create a discussion within the [Polywrap Discord](https://discord.polywrap.io).

Happy coding!
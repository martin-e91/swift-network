# Network
[![Build & Test](https://github.com/martin-e91/swift-network/actions/workflows/CI.yml/badge.svg)](https://github.com/martin-e91/swift-network/actions/workflows/CI.yml)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/martin-e91/swift-network)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![License](https://img.shields.io/github/license/martin-e91/swift-network)](LICENSE)

A minimal network layer library for performing basic requests.



## Requirements
Platforms: iOS 13.0+ / macOS 10.15+


## Installation

### Swift Package Manager

This library can be added as dependency in your project by using [Swift Package Manager](https://swift.org/package-manager/), which is integrated into the `swift` compiler.

You'll need to add the following in your `Package.swift` file:

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift` or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/martin-e91/swift-network.git", branch: "main")
]
```

Mainly you'll want to depend on the interface `NetworkAPI` target

```swift
...
.target(name: "MyPackage", dependencies: [.product(name: "NetworkAPI", package: "swift-network")]),
...
```

while in the module where you'll need library's concrete types you'll want to depend on the concrete implementation target, `Network` like so: 

```swift
...
.target(name: "MyPackage", dependencies: [.product(name: "Network", package: "swift-network")]),
...
```


## System Design
 
The package has been designed with modularisation in mind. For this reason its components have been split in between 3 exposed targets, that will result in a more flexible and decoupled integration in importing modules.

- `NetworkAPI` containing the module's interfaces. This module should be imported wherever you'll need to perform a request leveraging this library.  
- `Network`: containing concrete implementations of the components.  Ideally this module should only be imported in your dependency injection layer, where you'll need to retrieve and inject concrete implementation components (like `NetworkClientFactoryImpl`).
- `NetworkMocks`: this target exposes types for mocking `NetworkAPI` protocols'.


## Usage
Ideally you'd import the `Network` module in your dependency injection layer, extracting a `NetworkClient` instance from exposed factory `NetworkClientFactoryImpl`, like so

```swift
struct AppDependencies {
	let networkClient: NetworkClient

	init() {
		...
		let factory = NetworkClientFactoryImpl()
		self.networkClient = factory.networkClient(with: URLSession.shared)
		...
	}
}
```

After that, let's say you want to hit the PUNK API to retrieve a list of beers. 

You'll want to declare a concrete `Endpoint` 

```swift
struct PunkBeersEndpoint: Endpoint {
	var scheme: String { "https" }
	var host: String { "api.punkapi.com" }
	var path: PathComponents { ["v2"] }
}
```

a concrete `NetworkRequest`

```swift
struct GetBeersRequest: NetworkRequest {
	typealias Response = [Beer]

	var method: HTTPMethod { .get }

	var parameters: RequestParameter? { nil }

	var endpoint: Endpoint { PunkBeersEndpoint() }
}
```

and finally you'll be able to hit the network with just 1 line of code

```swift
try await networkClient.perform(GetBeersRequest()) // will hit the network for the endpoint `https://api.punkapi.com/v2/beers`
```

## Contributions

Please feel free to [open an issue](https://github.com/martin-e91/swift-network/issues/new/choose) for requesting a feature or reporting a bug. 

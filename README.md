# Network
[![Build & Test](https://github.com/martin-e91/swift-network/actions/workflows/CI.yml/badge.svg)](https://github.com/martin-e91/swift-network/actions/workflows/CI.yml)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/martin-e91/swift-network)
[![License](https://img.shields.io/github/license/martin-e91/swift-network)](LICENSE)

A minimal network layer library for performing basic requests.


# System Design
 
The package exposes 3 targets for archiving a more flexible and decoupled integration in the importing module.

- `NetworkAPI` containing the module's interfaces.  
- `Network`: containing concrete implementations of the components.  
- `NetworkMocks`: the target exposing types for mocking `NetworkAPI` protocols'.  

> [!TIP]
> Suggested approach is to depend on the `NetworkAPI` target, in order to not be affected by any breaking change to the concrete types in `Network`.


# Contributions

Please feel free to [open an issue](https://github.com/martin-e91/swift-network/issues/new/choose) for requesting a feature or reporting a bug. 

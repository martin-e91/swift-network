# Network

A minimal network layer library for performing basic requests.

## System Design 
The package exposes 3 targets for archiving a more flexible integration in importing modules targets.

- `NetworkAPI` target that contains the interfaces.  
- `Network`: the implementation module containing concrete types for the components.  
- `NetworkMocks`: the target exposing mock types for mocking `NetworkAPI` protocols' behaviours.  

External integrating modules shall only depend on the `NetworkAPI` target so that they won't be affected in case any breaking change is done on the implememntation level.

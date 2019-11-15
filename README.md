# Networking With Combine

This is an SPM library ([How to add Swift Package to XCode Project?](https://medium.com/better-programming/add-swift-package-dependency-to-an-ios-project-with-xcode-11-remote-local-public-private-3a7577fac6b2)) for making simple network calls using Combine framework.

Available for:
* iOS 13.0 or above
* macOS 10.15 or above
* tvOS 13.0 or above

All the network calls return a Combine publisher of type AnyPublisher with APIError.

Example usage with Codable Object:
```swift
let cancellable = NetworkingWithCombine.getAPIResponseMapper(modelObject: SampleCodableClass.self, queryURL: someURL, params: nil)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    // Add debug statements or triggers
                }
            }, receiveValue: { value in
                // Utilize the returned SampleCodableClass object
            })
```

Example usage with Images:
```swift
let cancellable = NetworkingWithCombine.getImageFetcher(imageUrl: someURL)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    // Add debug statements or triggers
                }
            }, receiveValue: { value in
                // Utilize the returned Image
            })
```

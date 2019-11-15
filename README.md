# Networking With Combine

This is an SPM library ([How to add Swift Package to XCode Project?](https://medium.com/better-programming/add-swift-package-dependency-to-an-ios-project-with-xcode-11-remote-local-public-private-3a7577fac6b2)) for making simple network calls using Combine framework.

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
                // Utilize the returned T object
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
                // Utilize the returned value
            })
```

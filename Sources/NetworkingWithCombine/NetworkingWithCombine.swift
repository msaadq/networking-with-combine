//
//  NetworkingWithCombine.swift
//
//
//  Created by Saad Qureshi on 15/11/2019.
//

import Foundation
import Combine
import UIKit

// MARK: - APIService
@available(tvOS 13.0, *)
@available(iOS 13.0, *)
class NetworkingWithCombine {
    
    let decoder = JSONDecoder()

    // MARK: - Errors
    enum APIError: Error {
        case decodingError
        case httpError
        case unknownError(error: Error)
    }

    // MARK: - URL Request Mapper
    static func getAPIResponseMapper<T: Codable>(modelObject: T.Type, queryURL: URL, params: [String: String]? = nil) -> AnyPublisher<T, NetworkingWithCombine.APIError> {
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = []
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"

        return getRemoteDataPublisher(url: request)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ error in
                if type(of: error) == Swift.DecodingError.self {
                    print("JSON decoding error")
                    return APIError.decodingError
                }
                return APIError.unknownError(error: error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Image Fetcher
    static func getImageFetcher(imageUrl: String) -> AnyPublisher<UIImage, Never> {
        let components = URLComponents(url: URL(string: imageUrl)!, resolvingAgainstBaseURL: true)!
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"

        return getRemoteDataPublisher(url: request)
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    print("Image decoding error")
                    throw APIError.decodingError
                }
                return image
            }
            .replaceError(with: UIImage(named: "FailedPlaceholder")!)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    // MARK: - URL Request Publisher
    static func getRemoteDataPublisher(url: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
        .retry(3)
        .tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Error")
                throw APIError.httpError
            }
            return data
        }
        .mapError { error in
            print(error.localizedDescription)
            return APIError.unknownError(error: error)
        }
        .eraseToAnyPublisher()
    }
}

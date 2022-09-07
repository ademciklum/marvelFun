//
//  URLComposer.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import Foundation

public struct URLRequestComposer {
    static let baseUrl: URL = URL(string: "https://gateway.marvel.com")!
    
    public enum HTTPMethod: String {
        case get = "GET"
    }

    public enum ApiVersion: String {
        case v1public = "/v1/public"
    }
    
    public static func compose(_ method: HTTPMethod = .get,
                               baseURL: URL = Constants.baseUrl,
                               apiVersion: ApiVersion = .v1public,
                               request: Endpoint,
                               queryParameters: [String: String]? = nil,
                               additionalHTTPHeaderFields: [String: String]? = nil) -> URLRequest {
        var components = URLComponents()
        components.host = baseURL.host
        components.scheme = baseURL.scheme
        components.path = [apiVersion.rawValue, request.stringValue].compactMap { $0 }.joined()
        components.queryItems = []
        
        if request.authorizationRequired {
            components.queryItems?.append(contentsOf: authorizationParameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            components.queryItems?.append(contentsOf: queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        if request.httpBody != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        additionalHTTPHeaderFields?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
    
    public static func compose(path: String,
                               extention: String? = nil,
                               authorizationRequired: Bool,
                               queryParameters: [String: String]? = nil) -> URL? {
        var components = URLComponents(string: path)
        components?.queryItems = []
        if authorizationRequired {
            components?.queryItems?.append(contentsOf: authorizationParameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        guard var url = components?.url else { return nil }
        if let extention = extention {
            url.appendPathExtension(extention)
        }
        return url
    }
    
    private static var authorizationParameters: [String: String] {
        var params = [String: String]()
        
        let timeStamp = String(Date().timeIntervalSince1970)
        let hash = "\(timeStamp)\(Constants.privateApiKey)\(Constants.publicApiKey)".md5
        
        params["apikey"] = Constants.publicApiKey
        params["ts"] = String(timeStamp)
        params["hash"] = hash
        
        return params
    }
}

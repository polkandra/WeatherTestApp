//
//  NetworkClient.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int, data: Data?)
}

final class NetworkClient {

    static let shared = NetworkClient()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(
        urlString: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryParams: [String: String]? = nil,
        body: Encodable? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        
        guard let url = buildURL(baseURL: urlString, queryParams: queryParams) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
       
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
        }

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode, data: data)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError(error)))
            }

        }.resume()
    }
}
extension NetworkClient {
    private func buildURL(baseURL: String, queryParams: [String: String]?) -> URL? {
        guard var components = URLComponents(string: baseURL) else {
            return nil
        }
        
        if let queryParams = queryParams {
            components.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        return components.url
    }
}

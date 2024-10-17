//
//  CustomNetworkClient.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 17.10.2024.
//

import Foundation

final class CustomNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {

        guard let urlRequest = create(request: request) else {
            onResponse(.failure(NetworkClientError.urlSessionError))
            return nil
        }

        logRequest(urlRequest)

        let task = session.dataTask(with: urlRequest) { data, response, error in
            self.logResponse(data: data, response: response, error: error)

            if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }

            guard 200..<300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }

            if let data = data {
                onResponse(.success(data))
            } else {
                onResponse(.failure(NetworkClientError.urlSessionError))
            }
        }

        task.resume()

        return DefaultNetworkTask(dataTask: task)
    }

    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        return send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try self.decoder.decode(T.self, from: data)
                    onResponse(.success(decodedData))
                } catch {
                    Logger.shared.error("Ошибка парсинга: \(error.localizedDescription)")
                    onResponse(.failure(NetworkClientError.parsingError))
                }
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }

    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue

        urlRequest.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        if let dto = request.dto as? UpdateProfileDto {
            var profileData = ""
            if let name = dto.name,
               let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                profileData += "&name=\(encodedName)"
            }
            if let avatar = dto.avatar,
               let encodedAvatar = avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                profileData += "&avatar=\(encodedAvatar)"
            }
            if let description = dto.description,
               let encodedDescription = description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                profileData += "&description=\(encodedDescription)"
            }
            if let website = dto.website,
               let encodedWebsite = website.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                profileData += "&website=\(encodedWebsite)"
            }
            if let likes = dto.likes {
                for like in likes {
                    if let encodedLike = like.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        profileData += "&likes=\(encodedLike)"
                    }
                }
            }
            urlRequest.httpBody = profileData.data(using: .utf8)
        }

        return urlRequest
    }

    // MARK: - Logging Methods

    private func logRequest(_ request: URLRequest) {
        var logMessage = "\n----- Request -----\n"

        if let url = request.url {
            logMessage += "URL: \(url.absoluteString)\n"
        }
        if let method = request.httpMethod {
            logMessage += "Method: \(method)\n"
        }
        if let headers = request.allHTTPHeaderFields {
            logMessage += "Headers:\n"
            for (key, value) in headers {
                logMessage += "  \(key): \(value)\n"
            }
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            logMessage += "Body: \(bodyString)\n"
        } else {
            logMessage += "Body: nil\n"
        }
        logMessage += "-------------------"

        Logger.shared.debug(logMessage)
    }

    private func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        var logMessage = "\n----- Response -----\n"

        if let error = error {
            logMessage += "Error: \(error.localizedDescription)\n"
        }
        if let response = response as? HTTPURLResponse {
            logMessage += "Status Code: \(response.statusCode)\n"
            logMessage += "Headers:\n"
            for (key, value) in response.allHeaderFields {
                logMessage += "  \(key): \(value)\n"
            }
        }
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            logMessage += "Body: \(dataString)\n"
        } else {
            logMessage += "Body: nil\n"
        }
        logMessage += "--------------------"

        if let error {
            Logger.shared.error(logMessage)
        } else {
            Logger.shared.debug(logMessage)
        }
    }
}

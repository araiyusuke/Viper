//
//  APIAgent.swift
//  Viper
//
//  Created by ććăȘă on 2022/04/26.
//

import Foundation
import Combine

typealias RequestHandler = ((URLRequest) throws -> (HTTPURLResponse, Data?))

struct APIAgent: APIAgentProtocol {
    
    let config: URLSessionConfiguration?
    
    init(config: URLSessionConfiguration? = nil ) {
        self.config = config
    }
    
    var session: URLSession {
        if let config = config {
            return URLSession.init(configuration: config)
        } else {
            return URLSession.shared
        }
    }
    
    func run<T: Mockable>(_ request: URLRequest, mockFile: String?, statusCd: Int?) -> AnyPublisher<T, Error> {
        return API.run(session.dataTaskPublisher(for: request), mockFile: mockFile, statusCd: statusCd)
    }
}

class StubURLProtocol: URLProtocol {
    
    static var requestHandler: RequestHandler?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        guard let handler = Self.requestHandler else {
            fatalError("Handler is unavailable")
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch let e {
            client?.urlProtocol(self, didFailWithError: e)
        }
    }
    override func stopLoading() {}
}

extension API {
    
    static func run<T: Mockable>(_ dataTaskPublisher: URLSession.DataTaskPublisher, mockFile: String?, statusCd: Int?) -> AnyPublisher<T, Error> {
        
        dataTaskPublisher
            .tryMap { dataTaskOutput -> Result<URLSession.DataTaskPublisher.Output, Error> in
                guard let httpResponse = dataTaskOutput.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                print(httpResponse)

                // ăčăăŒăżăčăłăŒăăććŸ
                let statusCode = httpResponse.statusCode
                                                
                // 500çȘć°ăšă©ăŒ
                if StatusCode.HTTP_SERVER_ERROR_RANGE.contains(statusCode) {
                    throw APIError.serverError
                }

                // 400çȘć°ăšă©ăŒ
                if StatusCode.HTTP_CLIENT_ERROR_RANGE.contains(statusCode) {
                                        
                    // ăăŒăŻăłăšă©ăŒ
                    if statusCode == StatusCode.HTTP_UNAUTHORIZED_401 {
                        let decoder = jsonDecoder()
                        let data = try decoder.decode(ResponseResultError.self, from: dataTaskOutput.data)
                        if data.message == "Error:DeviceTokenăæ­ŁăăăăăŸăă" {
                            throw APIError.unauthorized(.device)
                        } else {
                            throw APIError.unauthorized(.member)
                        }
                    }

                    // ć„ćăšă©ăŒ
                    if statusCode == StatusCode.HTTP_UNPROCESSABLE_ENTITY_422 {
                        let decoder = jsonDecoder()
                        let data = try decoder.decode(ResponseResultError.self, from: dataTaskOutput.data)
                        throw APIError.validation(data: data)
                    }
                    
                    if statusCode == StatusCode.HTTP_TOO_MANY_REQUESTS_429 {
                        throw APIError.tooManyRequest
                    }
                    
                    if StatusCode.HTTP_NOT_FOUND_AND_NOT_ALLOWED.contains(statusCode) {
                        throw APIError.serverError
                    }
                
                }
                
                return .success(dataTaskOutput)
            }

            .catch { error -> AnyPublisher<Result<URLSession.DataTaskPublisher.Output, Error>, Error> in
                switch error {
                // äžéšăšă©ăŒă«ă€ăăŠăŻretryăăăă
                case URLError.notConnectedToInternet:
                    // 3ç§ćŸă«retry
    //                    return Fail(error: error)
    //                        .delay(for: 3, scheduler: DispatchQueue.main)
    //                        .eraseToAnyPublisher()
                    
                    return Just(.failure(APIError.wifiError))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
            
                // retryăăăăȘăăšă©ăŒ(sinkăź.failureă«ć°éăă)
                case URLError.timedOut:
                    return Just(.failure(error))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()

                case APIError.unauthorized:
                    return Just(.failure(error))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                    
                case APIError.serverError:
                    return Just(.failure(error))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                    
                case APIError.tooManyRequest:
                    return Just(.failure(error))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                    
                // ć„ćăă©ăŒă ăźæ€èšŒ
                case APIError.validation(let data):
                    do {
                        return Just(.failure(APIError.validation(data: data)))
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }

                default:
                    // 401ăȘă©ăźăšă©ăŒăŻăăă«ăăă
                    return Just(.failure(error))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .retry(2)
            // çĄäșæćăăŠJSONăććŸă§ăă
            .tryMap { result -> T in
                switch result {
                case .success:
                    do {
                        let decoder = jsonDecoder()
                        return try decoder.decode(T.self, from: result.get().data)
                    } catch {
                        print(error)
                        throw APIError.jsonDecodeError
                    }
                case .failure(let error):
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
}

//
//  BaseRequest.swift
//  rainierrivera
//
//  Created by John Rivera on 15/08/2019.
//  Copyright © 2019 John Rivera. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseRequest {

  var networkManager: NetworkManager

  init(withNetworkManager networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  func requestMethod() -> Alamofire.HTTPMethod {
    return .get
  }

  func request<T: Decodable>(completion: ((APIResponse<T>) -> Void)?) {
    performRequest() { response in
      switch response {
      case let .success(json):
        guard let object = JSONDecoder().decode(T.self, from: json) else {
          completion?(.error("Parsing Error"))
          return
        }
        completion?(.success(object))
      case let .error(error):
        completion?(.error(error))
      }
    }
  }

  // Override this for more specific error
  func performRequest(completion: @escaping (NetworkResponse) -> Void) {

    let requestUrl = requestURL()
    let requestParams = parameters()
    let requestHeaders = headers()

    NetworkManager.manager.request(requestUrl,
                                   method: requestMethod(),
                                   parameters: requestParams,
                                   encoding: encoding(),
                                   headers: requestHeaders)
      .validate()
      .responseData { response in

        switch response.result {
        case .success(let data):
          if let json = try? JSON(data: data) {
            completion(.success(json))
          } else {
            completion(.success(JSON.null))
          }
        case .failure(let error):
          completion(.error(error.localizedDescription))
        }
    }

  }

  enum NetworkResponse: Error {

    // Success
    case success(JSON)

    // Better to create custom API Error type, but needed in this project
    case error(String)

    // Helper method to get a readable description of the error.
    var description: String {
      switch self {
      case .success:
        return "Success"
      case .error(let error):
        // todo: placeholder text to be updated
        return error
      }
    }
  }

  // Should override this to set the request URL
  func requestURL() -> URLConvertible {
    return ""
  }

  // Override this for unique header
  func headers() -> [String: String] {
    return networkManager.defaultHeaders()
  }

  // Override to pass parameters to request
  func parameters() -> [String: Any]? {
    return nil
  }

  func encoding() -> ParameterEncoding {
    return URLEncoding()
  }
}

class ManagedRequest: BaseRequest { }

// Generic Api Response
enum APIResponse<RESULT> {
  case success(RESULT)
  case error(String)
}

extension JSONDecoder {

  // Decode from JSON since we have no decodable from JSON yet
  func decode<T: Decodable>(_ type: T.Type, from json: JSON) -> T? {
    guard let data = try? json.rawData() else { return nil }
    do {
      return try JSONDecoder().decode(type, from: data)
    } catch {
      return nil
    }
  }
}

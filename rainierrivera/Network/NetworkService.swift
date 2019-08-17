//
//  NetworkService.swift
//  rainierrivera
//
//  Created by John Rivera on 16/08/2019.
//  Copyright © 2019 John Rivera. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {

  // Basic alamofire configuration setup
  static var manager: Alamofire.SessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30.0
    configuration.urlCache = nil
    return Alamofire.SessionManager(configuration: configuration)
  }()

  // since we are not handling the authentication bearer
  // we leave it empty as default header
  func defaultHeaders() -> [String: String] {
    let headers: [String: String] = [:]
    return headers
  }
}

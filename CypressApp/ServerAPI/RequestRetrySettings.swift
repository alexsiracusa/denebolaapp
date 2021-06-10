//
//  RequestRetrySettings.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/10/21.
//

import Foundation
import Alamofire

class Retry: RetryPolicy {
    let delay: Double = 2.5
    let maxRetryCount: UInt = 10

    override func retry(_ request: Request,
                    for session: Session,
                    dueTo error: Error,
                    completion: @escaping (RetryResult) -> Void) {
        if request.retryCount < maxRetryCount, shouldRetry(request: request, dueTo: error) {
            completion(.retryWithDelay(delay))
        } else {
            completion(.doNotRetry)
        }
    }
}

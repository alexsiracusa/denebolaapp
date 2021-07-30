//
//  RequestRetrySettings.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/10/21.
//

import Alamofire
import Foundation

/// https://github.com/Alamofire/Alamofire/blob/master/Source/RetryPolicy.swift

class Retry: RetryPolicy {
    let delay: Double
    let maxRetryCount: UInt

    init(delay: Double = 4, maxRetryCount: UInt = UInt.max) {
        self.delay = delay
        self.maxRetryCount = maxRetryCount
    }

    override func retry(_ request: Request,
                        for _: Session,
                        dueTo error: Error,
                        completion: @escaping (RetryResult) -> Void)
    {
        if request.retryCount < maxRetryCount, shouldRetry(request: request, dueTo: error) {
            completion(.retryWithDelay(delay))
        } else {
            completion(.doNotRetry)
        }
    }

    // not changed from original
    override func shouldRetry(request: Request, dueTo error: Error) -> Bool {
        guard let httpMethod = request.request?.method, retryableHTTPMethods.contains(httpMethod) else { return false }

        if let statusCode = request.response?.statusCode, retryableHTTPStatusCodes.contains(statusCode) {
            return true
        } else {
            let errorCode = (error as? URLError)?.code
            let afErrorCode = (error.asAFError?.underlyingError as? URLError)?.code

            guard let code = errorCode ?? afErrorCode else { return false }

            return retryableURLErrorCodes.contains(code)
        }
    }
}

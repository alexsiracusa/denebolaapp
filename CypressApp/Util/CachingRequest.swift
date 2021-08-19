//
//  CachingRequest.swift
//  CypressApp
//
//  Created by Connor Tam on 7/31/21.
//

import Alamofire
import CryptoKit
import Foundation
import PromiseKit

func requestPromise<T: Codable>(request: DataRequest) -> Promise<T> {
    return Promise(cancellable: request) { seal in
        // Resolve the request
        request.validate().responseDecodable(of: T.self, decoder: MultiFormatter()) { response in
            sealResult(seal, response.result)
        }
    }
}

class CachingRequest<T: Codable> {
    let dataRequest: DataRequest

    init(with: DataRequest) {
        dataRequest = with
    }

    /**
      Attempts to retrieve data for the first two seconds, then attempts to retrieve data from the cache.
      The promise resolves with whichever is faster. If the cache resolves faster, the request is cancelled.

     - Parameter maxRetry: The number of times to retry before rejecting
     - Parameter useCache: Whether the promise is allowed to resolve with a cached response
     - Returns: A promise.
     */
    func perform(maxRetry: Int = 1, useCache: Bool = true) -> Promise<T> {
        var isFulfilled = false

        let initialRequest: Promise<T> = requestRetrying(times: maxRetry, shouldStopRetrying: { isFulfilled })

        if useCache {
            let afterRequest: Promise<T> = after(seconds: 1.0)
                .then(retrieveResponsePromise)
                .get { _ in isFulfilled = true }

            return race(fulfilled: [initialRequest, afterRequest])
        } else {
            return initialRequest
        }
    }

    /**
      Normal request.

     - Returns: A promise.
     */
    func request() -> Promise<T> {
        return requestPromise(request: dataRequest).get { _ in
            // Save the successful response to the Disk cache
            self.cacheResponse()
        }
    }

    /**
      Infinitely polls the server for data

     - Parameter: stopIfResolved: Will stop retrying if the promise is resolved
     - Returns: A promise.
     */
    private func requestRetrying(times: Int, shouldStopRetrying: @escaping () -> Bool = { false }) -> Promise<T> {
        return retry(times: times, cooldown: 3.0, shouldThrowError: {
            // If the error was a network error, then stop retrying and throw error
            let afError = $0.asAFError!
            return (!afError.isSessionTaskError && !afError.isRequestRetryError) || shouldStopRetrying()
        }) {
            self.request()
        }
    }

    /// Attempts to retrieve a response from the cache in promise-form
    private func retrieveResponsePromise() -> Promise<T> {
        return Promise { seal in
            let data = URLCache.shared.cachedResponse(for: dataRequest.request!.urlRequest!)?.data

            guard let data = data else { seal.reject("No cache found."); return }

            seal.fulfill(try MultiFormatter().decode(T.self, from: data))
        }
    }

    private func cacheResponse() {
        let dataRequest = dataRequest
        URLCache.shared.storeCachedResponse(CachedURLResponse(response: dataRequest.response!, data: dataRequest.data!), for: dataRequest.request!.urlRequest!)
    }
}

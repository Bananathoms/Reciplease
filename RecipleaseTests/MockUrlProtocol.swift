//
//  MockUrlProtocol.swift
//  RecipleaseTests
//
//  Created by Thomas Carlier on 13/05/2024.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var mockResponses: [(request: URLRequest, response: HTTPURLResponse, data: Data?)] = []

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let responseTuple = MockURLProtocol.mockResponses.first(where: { $0.request.url == request.url }) {
            client?.urlProtocol(self, didReceive: responseTuple.response, cacheStoragePolicy: .notAllowed)
            if let data = responseTuple.data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } else {
            let error = NSError(domain: "MockURLProtocol", code: 0, userInfo: nil)
            client?.urlProtocol(self, didFailWithError: error)
        }
    }


    override func stopLoading() {
        // Not needed for mock
    }
}


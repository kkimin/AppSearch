//
//  ResponseData.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

import Foundation

class ResponseData {
	var statusCode: Int?
	var errorCode: NetworkError?
	var header: HTTPURLResponse?
	var body: Data?
	var URLLoadError: NSError?
	var errorDescription: String?  // error localizedDescription
}

public enum NetworkError: Swift.Error {
	case unknown
	case invalidSearchTerm
	case invalidURL
	case invalidConnection
	case serverError(Int)
	case urlLoadError(Int)
}

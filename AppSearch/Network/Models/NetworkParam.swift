//
//  NetworkParam.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

class NetworkParam {
	var detailURL: String = ""
	var headers: [String: String]?
	var body: String?
	var parameters: [String: String] = [:]
	weak var responseListener: ResponseListenerDelegate?

	/**
	NetworkParam with Parameters
	- Parameter detailURL: detail Path
	- Parameter parameters: parameters
	- Parameter animated: Bool
	- Parameter responseListener: ResponseListenerDelegate
	*/
	init (detailURL: String, parameters: [String: String]?, responseListener: ResponseListenerDelegate) {
		self.detailURL = detailURL
		self.parameters = parameters ?? [:]
		self.responseListener = responseListener
	}

	/**
	NetworkParam with body
	- Parameter detailURL: detail Path
	- Parameter headers: headers
	- Parameter body: body String Only
	- Parameter responseListener: ResponseListenerDelegate
	*/
	init (detailURL: String, headers: [String: String]?, body: String, responseListener: ResponseListenerDelegate) {
		self.detailURL = detailURL
		self.headers = headers
		self.body = body
		self.responseListener = responseListener
	}
}

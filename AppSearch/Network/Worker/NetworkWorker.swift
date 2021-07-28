//
//  NetworkWorker.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

import Foundation

class NetworkWorker: NetworkWorkerDelegate {

	enum NetworkConstants {
		static let NETWORK_TIMEOUT_FOR_REQUEST = 60.0
		static let ROOTPATH = "https://itunes.apple.com"
		static let HOSTPATH = "itunes.apple.com"
	}

	private var service: URLSession
	private var defaultConfig: URLSessionConfiguration = URLSessionConfiguration.default
	private var rootPath: String = ""

	private let errorHandler: ErrorHandler = ErrorHandler()

	init(rootPath: String = NetworkConstants.ROOTPATH) { // 기본 rootPath
		self.rootPath = rootPath
		defaultConfig.timeoutIntervalForRequest = NetworkConstants.NETWORK_TIMEOUT_FOR_REQUEST		// default 60.0
		service = URLSession(configuration: defaultConfig)
	}

	init(rootPath: String, configuration: URLSessionConfiguration) {
		self.rootPath = rootPath
		service = URLSession(configuration: configuration)
	}

	/// get 통신
	func requestGet(param: NetworkParam) {
		guard let requestURL = url(withPath: param.detailURL, parameters: param.parameters) else {
			errorHandler.callOnFail(responseListener: param.responseListener, errorCode: .invalidURL)
			return // invalid url fail
		}
		var request = URLRequest(url: requestURL) // request parameter 구성
		request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "GET"
		requestData(requestInfo: request, responseListener: param.responseListener)
	}

	// MARK: - 네트워크 통신 후 성공, 실패 로직 수행
	private func requestData(requestInfo: URLRequest, responseListener: ResponseListenerDelegate?) {
		let rd = ResponseData() // callback 할 통신결과 객체 init
		#if DEBUG
		if let url = requestInfo.url, let body = requestInfo.httpBody {
			print(url.absoluteString + " INPUT" + body.prettyPrintedJSONString)
		}
		#endif
		let dataTask = service.dataTask(with: requestInfo) { (data, urlResponse, error) in
			if let error = error { // 에러가 발생했는지 확인 후 각각의 리스너에 responseData 콜백
				print(error)
				self.errorHandler.mappingNetworkError(error: error, responseListener: responseListener)
			} else if let httpResponse = urlResponse as? HTTPURLResponse {
				#if DEBUG
				if let url = requestInfo.url, let new = data {
					print(url.absoluteString + " OUTPUT" + new.prettyPrintedJSONString)
				}
				#endif
				rd.body = data
				rd.header = httpResponse
				rd.statusCode = httpResponse.statusCode

				if (!self.errorHandler.checkStatusCode(responseData: rd, httpResponse: httpResponse, responseListener: responseListener)) {
					return
				}
				responseListener?.onSuccess(data: rd)
			}
		}
		dataTask.resume()
	}

	/// make url for API
	private func url(withPath path: String, parameters: [String: String]) -> URL? {
		var components = URLComponents()
		components.scheme = "https"
		components.host = NetworkConstants.HOSTPATH
		components.path = path
		components.queryItems = parameters.map { URLQueryItem(name: $0.0, value: $0.1) }
		return components.url
	}
}

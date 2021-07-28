//
//  ErrorHandler.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

import Foundation
import SystemConfiguration

class ErrorHandler {
	var rd = ResponseData()
	// MARK: - 네트워크 환경이 통신 가능한 상태인지 확인

	func checkNetworkConnection(responseListener: ResponseListenerDelegate?) -> Bool {
		let isNetworkConnect: Bool = isConnectToNetwork()

		if (!isNetworkConnect) {
			callOnFail(responseListener: responseListener, errorCode: .invalidConnection)
			return false
		} else {
			return true
		}
	}

	// MARK: - NSError mapping, onFail에 code 와 NSError 반환(URL Load Error 발생 case)

	func mappingNetworkError(error: Error, responseListener: ResponseListenerDelegate?) {
		let nsError = error as NSError
		rd.errorDescription = nsError.localizedDescription
		rd.errorCode = .urlLoadError(nsError.code)
		rd.URLLoadError = nsError
		callOnFail(responseListener: responseListener)
	}

	// MARK: - http 통신 status code 200번대 확인

	func checkStatusCode(responseData: ResponseData, httpResponse: HTTPURLResponse, responseListener: ResponseListenerDelegate?) -> Bool {
		if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
			rd = responseData
			callOnFail(responseListener: responseListener, errorCode: .serverError(httpResponse.statusCode))
			return false
		} else {
			return true
		}
	}

	/// 실패 처리
	func callOnFail(responseListener: ResponseListenerDelegate?, errorCode: NetworkError = .unknown) {
		let errorInfo = String(describing: rd.errorCode) + String(describing: rd.errorDescription)
		print(errorInfo)
		responseListener?.onFail(data: rd)
	}

	// MARK: - Network 통신가능 환경 체크

	func isConnectToNetwork() -> Bool {
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
		zeroAddress.sin_family = sa_family_t(AF_INET)

		guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				SCNetworkReachabilityCreateWithAddress(nil, $0)
			}
		}) else {
			return false
		}

		var flags: SCNetworkReachabilityFlags = []
		if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
			return false
		}

		let isReachable = flags.contains(.reachable)
		let needsConnection = flags.contains(.connectionRequired)
		return (isReachable && !needsConnection)
	}
}

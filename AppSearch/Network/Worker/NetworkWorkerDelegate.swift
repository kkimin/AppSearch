//
//  NetworkWorkerDelegate.swift
//  AppSearch
//
//  Created by Minju Ki on 3/22/21.
//

protocol NetworkWorkerDelegate: AnyObject {
	func requestGet(param: NetworkParam)
	// requestPost,requestPut,requestDelete 구현 확장
}

protocol ResponseListenerDelegate: AnyObject {
	func onSuccess(data: ResponseData)
	func onFail(data: ResponseData)
}

//
//  DatailViewInteractor.swift
//  AppSearch
//
//  Created by Minju Ki on 3/25/21.
//

import Foundation

protocol DetailBusinessLogic {
	var viewModel: MainSearch.ViewModel { get set }
	func makeTestData(data: InquiryCellValue)
}

class DatailViewInteractor: DetailBusinessLogic {
	var viewModel = MainSearch.ViewModel()
	var presenter: DetailPresentationLogic?

	/// TestData 만들기
	func makeTestData(data: InquiryCellValue) {
		viewModel.testData = data
		viewModel.testData?.versionDetail = "2.5.2\n● 일부 기기에서 발생하는 대출 프로세스 개선\n\n2.5.0\n● 이체 즐겨찾기 위젯 출시 (iOS 14 이상 사용 가능)\n- 홈스크린에서 이체 즐겨찾기 위젯으로 빠르게 이체 가능\n- 니니즈, 카카오프렌즈 테마 적용 지원\n\n● 유럽 해외송금을 더 빠르게, 해외계좌송금 서비스 개선\n- 독일, 프랑스 등 유럽 11개국으로 해외계좌송금시 소요시간 1일로 더 빠른 송금 가능\n- 은행코드 없이 계좌번호(IBAN Code)만으로 편리한 송금 지원\n\n● mini 거래내역 다운로드 기능 지원\n- [mini > 관리 > 거래내역] 화면에서 파일로 다운로드하여 한번에 확인 가능\n\n● 서비스 안정화 및 개선\n- 고객정보 확인 사용성 개선\n- 체크카드 이용실적 그래프 오류 수정\n- 그 외 편의성 개선 및 안정화"
		viewModel.testData?.openURL = "https://itunes.apple.com/kr/app/podcast/id525463029?mt=8&uo=4"
		viewModel.testData?.infoContent = ["제공자": "KakaoBank Corp.", "크기": "금융", "카테고리": "금융", "호환성": "이 iPhone와(과) 호환", "언어": "한국어", "연령 등급": "4+", "저작권": "카카오", "개발자 웹 사이트": "", "개인정보 처리방침": ""]
		viewModel.testData?.infoCollectionData = [InfoCollectionData(top: "8.6천개의 평가", middle: "3.6", bottom: "별 다섯개"), InfoCollectionData(top: "연령", middle: "4+", bottom: "세"), InfoCollectionData(top: "차트", middle: "#4", bottom: "금융"), InfoCollectionData(top: "개발자", middle: "기민주", bottom: "카카오뱅크"), InfoCollectionData(top: "언어", middle: "KO", bottom: "한국어")]
		presenter?.presentTestData(model: viewModel)
	}
}

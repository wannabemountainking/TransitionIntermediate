//
//  Models.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/21/26.
//

import Foundation

struct Article: Identifiable {
	let id = UUID()
	let title: String
	let source: String
	let readingMinutes: Int
	let icon: String
}

struct BookmarkItem: Identifiable {
	
	
	var id: UUID { article.id }
	let article: Article
	var hasRead: Bool = false
}

// Sample article data — mirrors the `products` array pattern in ShoppingCartMGE
// 샘플 기사 데이터 — ShoppingCartMGE의 products 배열과 동일한 패턴
enum Articles {
	static let articles: [Article] = [
		Article(
			title: "Swift 6의 엄격한 동시성 모델, 무엇이 달라지나",
			source: "Swift.org",
			readingMinutes: 6,
			icon: "swift"
		),
		Article(
			title: "애플, 새로운 온디바이스 AI 프레임워크 공개",
			source: "TechCrunch",
			readingMinutes: 4,
			icon: "apple.logo"
		),
		Article(
			title: "SwiftUI Attribute Graph 내부 동작 파헤치기",
			source: "Point-Free",
			readingMinutes: 12,
			icon: "chart.xyaxis.line"
		),
		Article(
			title: "2026년 iOS 앱스토어 심사 정책 변경 요약",
			source: "9to5Mac",
			readingMinutes: 5,
			icon: "doc.text.magnifyingglass"
		),
		Article(
			title: "왜 유명 스타트업들이 UIKit으로 회귀하는가",
			source: "Medium",
			readingMinutes: 8,
			icon: "arrow.uturn.backward"
		),
		Article(
			title: "동시성 프로그래밍, actor와 Sendable 완전 정리",
			source: "Hacking with Swift",
			readingMinutes: 10,
			icon: "cpu"
		)
	]
}

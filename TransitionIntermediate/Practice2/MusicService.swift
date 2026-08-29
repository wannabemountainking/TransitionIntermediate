//
//  MusicService.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/27/26.
//

import Foundation

/*
 ### 실제 서버 — iTunes Search API
 - **엔드포인트**: `https://itunes.apple.com/search?term={검색어}&media=music&entity=song&limit=25`
 - **인증 불필요, API 키 불필요**
 - **참고용 응답 형태** (직접 브라우저에 URL을 넣어서 확인해보세요):
 */

final class MusicService {
	
	static let shared: MusicService = .init()
	
	private init() {}
	
	let baseURL: String = "https://itunes.apple.com/search"
	
	func searchTracks(term: String) async throws -> [Track] {
		let searchingTerm = term
			.trimmingCharacters(in: .symbols)
			.trimmingCharacters(in: .whitespacesAndNewlines)
		let url = URL(string: "\(baseURL)?term=\(searchingTerm)&media=music&entity=song&limit=25")!
		let (data, _) = try await URLSession.shared.data(from: url)
		let response = try JSONDecoder().decode(ITuneResponse.self, from: data)
		return response.results
	}
	
}

extension MusicService {
	
	static let mockTracks: [Track] = [
		Track(
			track: "The Fate of Ophelia",
			artist: "Taylor Swift",
			collection: "The Life of a Showgirl",
			artworkURL: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/2d/46/e0/2d46e0bc-8ab9-85dd-4b56-ee6951351034/25UM1IM19577.rgb.jpg/100x100bb.jpg",
			durationSeconds: "02:22",
			previewURL: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/4b/07/28/4b07285f-b50c-7aff-cb40-2d732256b703/mzaf_16739866530441939982.plus.aac.p.m4a"
		)
	]
}

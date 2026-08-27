//
//  Track.swift
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

struct ITuneResponse: Codable {
	let results: [Track]
}

struct Track: Identifiable, Codable {
	var id: UUID
	
	let track: String
	let artist: String
	let collection: String
	let artworkURL: String
	let trackTimeMillis: Int
	let previewURL: String
	
	var durationSeconds: Int {
		Int(trackTimeMillis / 1000)
	}
	
	enum CodingKeys: String, CodingKey {
		case track = "trackName"
		case artist = "artistName"
		case collection = "collectionName"
		case artworkURL = "artworkUrl100"
		case trackTimeMillis
		case previewURL = "previewUrl"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = UUID()
		
		self.track = try container.decode(String.self, forKey: .track)
		self.artist = try container.decode(String.self, forKey: .artist)
		self.collection = try container.decode(String.self, forKey: .collection)
		self.artworkURL = try container.decode(String.self, forKey: .artworkURL)
		self.trackTimeMillis = try container.decode(Int.self, forKey: .trackTimeMillis)
		self.previewURL = try container.decode(String.self, forKey: .previewURL)
	}
	
	init(track: String, artist: String, collection: String, artworkURL: String, trackTimeMillis: Int, previewURL: String) {
		self.id = UUID()
		self.track = track
		self.artist = artist
		self.collection = collection
		self.artworkURL = artworkURL
		self.trackTimeMillis = trackTimeMillis
		self.previewURL = previewURL
	}

}



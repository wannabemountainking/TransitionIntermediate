//
//  MusicViewModel.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/27/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class MusicViewModel {
	
	private var service = MusicService.shared
	
	private(set) var tracks: [Track] = []
	private(set) var isLoading: Bool = false
	private(set) var errorMessage: String? = nil
	
	var selectedTrack: Track? = nil
	var hasResult: Bool? = nil
	
	func search(term: String) async {
		
		guard !isLoading else {
			errorMessage = "이미 로딩 중인 프로그램이 있습니다"
			return
		}
		
		guard !term.isEmpty else {
			hasResult = nil
			return
		}
		
		isLoading = true
		errorMessage = nil
		
		do {
			tracks = try await service.searchTracks(term: term)
			hasResult = !tracks.isEmpty
		} catch {
			errorMessage = error.localizedDescription
			tracks = []
			hasResult = false
		}
		
		isLoading = false
	}
	
}



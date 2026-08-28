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
	
	
	func search(term: String) async {
		guard !isLoading else {
			errorMessage = "이미 로딩 중인 프로그램이 있습니다"
			return
		}
		
		isLoading = true
		errorMessage = nil
		
		guard !term.isEmpty else { return }
		
		do {
			tracks = try await service.searchTracks(term: term)
		} catch {
			errorMessage = error.localizedDescription
		}
		
		isLoading = false
	}
	
}



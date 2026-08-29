//
//  MainView.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/27/26.
//

import SwiftUI
import AVFoundation

struct MainView: View {
	
	@Namespace private var iTuneNamespace
	
	@State private var vm: MusicViewModel = .init()
	@State private var searchText: String = ""
	@State private var showDetail: Bool = false
	@State private var debounceTask: Task<Void, Never>?
	
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color.purple, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
				.ignoresSafeArea()
			
			// Content
			VStack(spacing: 10) {
				if !showDetail {
					HStack(spacing: 10) {
						Text("검색창:")
							.font(.title)
							.fontWeight(.semibold)
						TextField("", text: $searchText)
							.font(.title2)
							.foregroundStyle(.black.opacity(0.9))
							.textFieldStyle(.roundedBorder)
							.onChange(of: searchText) { _, newValue in
								debounceTask?.cancel()
								debounceTask = Task {
									try? await Task.sleep(for: .seconds(0.6))
									guard !Task.isCancelled else {return}
									await vm.search(term: newValue)
								}
							}
						
						Button {
							// Action
							debounceTask?.cancel()
							Task {
								await vm.search(term: searchText)
							}
						} label: {
							Image(systemName: "magnifyingglass")
								.font(.title)
								.fontWeight(.bold)
								.foregroundStyle(Color.blue)
						}
					} //:HSTACK
					.padding(20)
					
					Divider()
					
					ScrollView {
						VStack(spacing: 10) {
							
							if vm.isLoading {
								ProgressView {
									Text("데이터 로딩 중...")
								}
							} else {
								switch vm.hasResult {
								case nil:
									ContentUnavailableView("검색어를 입력해 주세요", systemImage: "magnifyingglass")
								case false:
									ContentUnavailableView(
										"검색 결과가 없습니다",
										systemImage: "music.note.slash"
									)
								case true:
									TrackListView(
										tracks: vm.tracks,
										namespace: iTuneNamespace,
										onTrackSelected: { track in
											vm.selectedTrack = track
											withAnimation(.spring) {
												showDetail = true
											}
										}
									)
								}//: Switch
							}//:CONDITIONAL
						} //:VSTACK
					} //:SCROLL
				} else {
					if let track = vm.selectedTrack {
						TrackDetailView(
							track: track,
							namespace: iTuneNamespace,
							onDismiss: {
								withAnimation(.spring) {
									showDetail = false
								}
							}
						)
					}
				}
			} //:VSTACK
			
		} //:ZSTACK
	}
}

#Preview {
	MainView()
}

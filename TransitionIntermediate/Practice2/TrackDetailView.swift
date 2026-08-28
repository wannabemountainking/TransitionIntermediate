//
//  TrackDetailView.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/27/26.
//

import SwiftUI

struct TrackDetailView: View {
	
	let track: Track
	let onDismiss: () -> Void
	
    var body: some View {
		VStack(spacing: 20) {
			headerView()
			
			detailView(track: track)
			
			Spacer()
			\
			PurpleButton(
				title: "30초 미리듣기 버튼",
				action: {
					
				}
			)
		} //:VSTACK
    }
	
	private func headerView() -> some View {
		HStack(spacing: 20) {
			Button {
				// Action
				onDismiss()
			} label: {
				Text("➤")
					.font(.largeTitle)
					.fontWeight(.ultraLight)
					.rotationEffect(.degrees(180))
				Text("Search Result")
					.font(.title)
			}
			.foregroundStyle(.gray)
			Spacer()
		} //:HSTACK
		.padding()
	}
	
	private func detailView(track: Track) -> some View {
		VStack(spacing:20) {
			AsyncImage(url: URL(string: track.artworkURL))
				.frame(width: 70, height: 70)
				.clipShape(Circle())
				.overlay(alignment: .center) {
					Circle()
						.fill(Color.black.opacity(0.6))
						.frame(width: 25, height: 25)
				}
			
		} //:VSTACK
		.padding()
	}
}

#Preview {
	TrackDetailView(
		track: MusicService.mockTracks[0],
		onDismiss: {
		})
}

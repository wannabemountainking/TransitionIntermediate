//
//  TrackDetailView.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/27/26.
//

import SwiftUI
import AVFoundation

struct TrackDetailView: View {
	
	let track: Track
	let namespace: Namespace.ID
	@State private var player: AVPlayer? = nil
	let onDismiss: () -> Void
	
	
    var body: some View {
		VStack(spacing: 20) {
			headerView()
				
			detailView(track: track)
			
			Spacer()
			
			PurpleButton(
				title: "30초 미리듣기 버튼",
				action: {
					player = AVPlayer(url: URL(string: track.previewURL)!)
					player?.play()
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
				HStack {
					Text("➤")
						.font(.largeTitle)
						.fontWeight(.ultraLight)
						.rotationEffect(.degrees(180))
					Text("Search Result")
						.font(.title)
				}
			}
			.foregroundStyle(.gray)
			Spacer()
		} //:HSTACK
		.padding()
	}
	
	private func detailView(track: Track) -> some View {
		VStack(spacing:20) {
			AsyncImage(url: URL(string: track.artworkURL))
				.clipShape(Circle())
			
			VStack(spacing: 15) {
				Text(track.track)
					.font(.system(size: 40))
					.fontWeight(.semibold)
					.matchedGeometryEffect(id: "\(track.id)-image", in: namespace)
				Text(track.artist)
					.font(.largeTitle)
					.fontWeight(.light)
					.matchedGeometryEffect(id: "\(track.id)-artist", in: namespace)
				Text(track.collection)
					.font(.title)
					.fontWeight(.medium)
				Text("재생시간: \(track.durationSeconds)")
					.font(.title2)
					.fontWeight(.ultraLight)
					.matchedGeometryEffect(id: "\(track.id)-runningTime", in: namespace)
			} //:VSTACK
			.padding(.vertical, 30)
		} //:VSTACK
		.padding()
		.padding(.vertical, 30)
		.background(
			RoundedRectangle(cornerRadius: 15)
				.fill(Color.mint.opacity(0.3))
				.frame(maxWidth: .infinity)
				.matchedGeometryEffect(id: "\(track.id)-background", in: namespace)
		)
	}
}



#Preview {
	@Previewable @Namespace var namespace
	TrackDetailView(
		track: MusicService.mockTracks[0],
		namespace: namespace,
		onDismiss: {
		})
}

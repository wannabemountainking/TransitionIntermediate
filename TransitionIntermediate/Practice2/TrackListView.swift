//
//  TrackListView.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/27/26.
//

import SwiftUI

struct TrackListView: View {
	
	let tracks: [Track]
	let namespace: Namespace.ID
	let onTrackSelected: (Track) -> Void
	
    var body: some View {
		LazyVStack(alignment: .leading, spacing: 10) {
			ForEach(tracks, id: \.id) { track in
				HStack(alignment: .top, spacing: 20) {
					AsyncImage(url: URL(string: track.artworkURL))
						.frame(width: 70, height: 70)
						.clipShape(Circle())
						.overlay(alignment: .center) {
							Circle()
								.fill(Color.black.opacity(0.6))
								.frame(width: 25, height: 25)
						}
						.matchedGeometryEffect(id: "\(track.id)-image", in: namespace)
					
					VStack(alignment: .leading, spacing: 5) {
						Text(track.track)
							.font(.title2)
							.fontWeight(.semibold)
							.matchedGeometryEffect(id: "\(track.id)-track", in: namespace)
						HStack(spacing: 30) {
							Text(track.artist)
								.font(.title3)
								.fontWeight(.light)
								.matchedGeometryEffect(id: "\(track.id)-artist", in: namespace)
							Text(track.durationSeconds)
								.font(.headline)
								.fontWeight(.ultraLight)
								.matchedGeometryEffect(id: "\(track.id)-runningTime", in: namespace)
						} //:HSTACK
					} //:VSTACK
					Spacer()
				} //:HSTACK
				.frame(maxWidth: .infinity)
				.padding(.vertical)
				.padding(.horizontal, 20)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(
							Color.orange.opacity(0.3)
						)
						.matchedGeometryEffect(id: "\(track.id)-background", in: namespace)
				)
				.onTapGesture {
					withAnimation(.spring) {
						onTrackSelected(track)
					}
				}
				.padding(.vertical, 10)
			} //:LOOP
		} //:VSTACK
		.frame(maxWidth: .infinity)
		.padding(.horizontal)
    }
}

#Preview {
	@Previewable @Namespace var namespace
	
	TrackListView(
		tracks: MusicService.mockTracks,
		namespace: namespace,
		onTrackSelected: { _ in
		})
}

//
//  MainView.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/27/26.
//

import SwiftUI

struct MainView: View {
	
	@State private var vm: MusicViewModel = .init()
	@State private var tracks: [Track] = []
	@State private var searchText: String = ""
	@State private var hasResult: Bool? = nil
	
    var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color.purple, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
				.ignoresSafeArea()
			
			// Content
			VStack(spacing: 10) {
				HStack(spacing: 10) {
					Text("검색창:")
						.font(.title)
						.fontWeight(.semibold)
					TextField("", text: $searchText)
						.font(.title2)
						.foregroundStyle(.black.opacity(0.9))
						.textFieldStyle(.roundedBorder)
					Button {
						// Action
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
					<#code#>
				}
			} //:VSTACK
			
		} //:ZSTACK
    }
}

#Preview {
	MainView()
}

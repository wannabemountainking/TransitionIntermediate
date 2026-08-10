//
//  NotiToastSystemView.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/10/26.
//

import SwiftUI
import Observation

struct Toast: Identifiable, Equatable, Hashable {
	let id = UUID()
	let title: String
	let type: ToastType
	
	enum ToastType: CaseIterable {
		case success, warning, error, info
		
		var color: Color {
			switch self {
			case .success: .green
			case .warning: .orange
			case .error: .red
			case .info: .blue
			}
		}
		
		var iconName: String {
			switch self {
			case .success: "checkmark.circle.fill"
			case .warning: "exclamationmark.triangle.fill"
			case .error: "xmark.circle.fill"
			case .info: "info.circle.fill"
			}
		}
		
		var duration: TimeInterval {
			switch self {
			case .success: 2.0
			case .warning: 4.0
			case .error: 5.0
			case .info: 6.0
			}
		}
		
		var transition: AnyTransition {
			switch self {
			case .success:
				return .asymmetric(
					insertion: .move(edge: .top)
						.combined(with: .scale(scale: 0.8))
						.combined(with: .opacity),
					removal: .move(edge: .top)
						.combined(with: .opacity)
				)
			case .warning:
				return .asymmetric(
					insertion: .move(edge: .trailing)
						.combined(with: .scale(scale: 0.3))
						.combined(with: .opacity),
					removal: .move(edge: .leading)
						.combined(with: .opacity)
				)
			case .error:
				return .asymmetric(
					insertion: .move(edge: .leading)
						.combined(with: .scale(scale: 0.2))
						.combined(with: .opacity),
					removal: .move(edge: .trailing)
						.combined(with: .opacity)
				)
			case .info:
				return .asymmetric(
					insertion: .move(edge: .bottom)
						.combined(with: .scale(scale: 0.6))
						.combined(with: .opacity),
					removal: .move(edge: .bottom)
						.combined(with: .opacity)
				)
			}
		}
	}
}

@Observable
final class ToastSystemManager {
	
}


struct MultiToastSystemView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MultiToastSystemView()
}

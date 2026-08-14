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
		
		var title: String {
			switch self {
			case .success: "성공"
			case .warning: "경고"
			case .error: "에러"
			case .info: "상세정보"
			}
		}
		
		var color: Color {
			switch self {
			case .success: .green
			case .warning: .orange
			case .error: .red
			case .info: .blue
			}
		}
		
		var buttonName: String {
			switch self{
			case .success: "성공 토스트"
			case .warning: "경고 토스트"
			case .error: "에러 토스트"
			case .info: "알림 토스트"
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
	
	// MARK: - 1. Manager Properties
	
	// 생성되고 사라지는 것을 관리하는 배열
	var activeToasts: [Toast] = []
	
	// Toast가 만들어지고 작동될 때 사용할 Timer 관리
	var toastTimers: [UUID : Timer] = [:]
	
	// Toast 최대 개수
	let maxNumberOfToasts: Int = 3
	
	// MARK: - 2. Manager method
	func scheduleToast(type: Toast.ToastType, title: String) {
		let newToast = Toast(
			title: title,
			type: type
		)
		
		keepMaxNumberOfToasts()
		
		withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
			activeToasts.append(newToast)
		}
		
		scheduleAutoDismiss(for: newToast)
	}
	
	private func keepMaxNumberOfToasts() {
		if activeToasts.count >= maxNumberOfToasts,
		   let oldest = activeToasts.first {
			dismissToast(target: oldest)
		}
	}
	
	private func scheduleAutoDismiss(for toast: Toast) {
		let timer = Timer.scheduledTimer(
			withTimeInterval: toast.type.duration,
			repeats: false,
			block: { [weak self] _ in
				guard let self else { return }
				self.dismissToast(target: toast)
			}
		)
		toastTimers[toast.id] = timer
	}
	
	func dismissToast(target: Toast) {
		toastTimers[target.id]?.invalidate()
		toastTimers[target.id] = nil
		
		withAnimation(.spring) {
			self.activeToasts.removeAll(where: { $0.id == target.id })
		}
	}
	
}

struct MultiToastSystemView: View {
	
	@State private var manager: ToastSystemManager = .init()
	
    var body: some View {
		NavigationStack {
			VStack(spacing: 10) {
				Spacer()
				ForEach(Toast.ToastType.allCases, id: \.self) { type in
					PurpleButton(
						title: type.buttonName,
						action: {
							manager.scheduleToast(type: type, title: type.title)
						}
					)
				}
			} //:VSTACK
			.navigationTitle("ToastSystems")
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.contentShape(Rectangle())
			.overlay(alignment: .top) {
				// Toast 카드를 만들어서 화면 상단에 쌓아 올림
				VStack(spacing: 15) {
					ForEach(manager.activeToasts, id: \.id) { currentToast in
						ToastView(
							manager: manager,
							currentToast: currentToast
						)
						.frame(width: 350, height: 70)
						.transition(currentToast.type.transition)
					}
				}
			}
		} //:NAVSTACK
    }
}

struct ToastView: View {
	
	let manager: ToastSystemManager
	let currentToast: Toast
	
	var body: some View {
		RoundedRectangle(cornerRadius: 10)
			.fill(currentToast.type.color.opacity(0.3))
			.frame(maxWidth: .infinity)
			.frame(height: 80)
			.shadow(
				color: currentToast.type.color,
				radius: 5,
				x: 0,
				y: 5
			)
			.contentShape(Rectangle())
			.overlay(alignment: .top) {
				HStack {
					VStack(alignment: .leading) {
						HStack(spacing: 20) {
							Image(systemName: currentToast.type.iconName)
								.font(.title)
								.foregroundStyle(currentToast.type.color)
							Text(currentToast.title)
								.font(.title).bold()
						}
						HStack(spacing: 20) {
							Image(systemName: currentToast.type.iconName)
								.font(.title)
								.foregroundStyle(.clear)
							Text(currentToast.type.title)
								.font(.title3).bold()
								.foregroundStyle(.gray)
						}
					}
					
					Spacer()
					Button("", systemImage: "xmark.circle.fill") {
						manager.dismissToast(target: currentToast)
					}
					.font(.title)
					.foregroundStyle(.red)
						
				}
				.padding(.horizontal, 20)
				.padding(.top, 10)
			}
	}
}

#Preview {
    MultiToastSystemView()
}

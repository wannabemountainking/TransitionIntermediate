//
//  SuccessToastAlarmViewe.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/5/26.
//

import SwiftUI


struct SuccessToastAlarmViewe: View {
	@State private var showToast: Bool = false
	@State private var toastTask: Task<Void, Never>?
	
    var body: some View {
		ZStack {
			Color.clear.ignoresSafeArea()
				.contentShape(Rectangle())
				.onTapGesture {
					if  showToast {
						toastTask?.cancel()
						withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
							showToast = false
						}
					}
				}
			VStack {

				if showToast {
					RoundedRectangle(cornerRadius: 15)
						.fill(.gray.opacity(0.5))
						.frame(width: 300, height: 80)
						.overlay {
							HStack(spacing: 20) {
								Image(systemName: "checkmark")
									.fontWeight(.semibold)
									.foregroundStyle(.green)
								Text("저장되었습니다")
							}
							.font(.largeTitle)
							.fontWeight(.ultraLight)
						}
						.transition(
							.asymmetric(
								insertion: .scale(scale: 0.3, anchor: .topTrailing)
									.combined(with: .offset(y: -400))
									.combined(with: .opacity),
								removal: .move(edge: .top)
									.combined(with: .opacity)
							)
						)
				}
			}
			
		}
		
		Button {
			// action
			withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
				showToast = true
			}
			toastTask = Task {
				do {
					try await Task.sleep(for: .seconds(2))
					
					withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
						showToast = false
					}
				} catch {
					print(CancellationError())
				}
			}
		} label: {
			Text("저장하기")
				.font(.largeTitle)
				.fontWeight(.semibold)
				.frame(maxWidth: .infinity)
				.frame(height: 40)
				.foregroundStyle(.white)
				.padding(10)
				.background(
					Color.indigo.opacity(0.8)
				)
				.clipShape(Capsule())
		}
		.padding()
    }
}

#Preview {
    SuccessToastAlarmViewe()
}

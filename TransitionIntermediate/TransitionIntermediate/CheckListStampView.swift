//
//  CheckListStampView.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/16/26.
//

import SwiftUI
import Observation

struct TodoItem: Identifiable {
	let id = UUID()
	let title: String
	var isDone: Bool = false
	var isStampVisible: Bool = false
}

@Observable
final class TodoManager {
	var todoItems: [TodoItem] = []
	var timers: [UUID : Timer] = [:]
	let initialItems: [TodoItem] = [
		TodoItem(title: "우유 사기"),
		TodoItem(title: "운동 하기"),
		TodoItem(title: "책 읽기")
	]
	
	init() {
		self.todoItems = initialItems
	}
}


struct CheckListStampView: View {
	
	@State private var manager: TodoManager = .init()
	
    var body: some View {
		NavigationStack {
			ScrollView {
				ForEach(manager.todoItems, id: \.id) { item in
					TodoBoxView(manager: manager, item: item)
				}
			}
			.navigationTitle("할 일 목록")
			.padding(.vertical, 30)
		}
		.padding(.horizontal, 20)
    }
}

// MARK: - Todo 박스View
struct TodoBoxView: View {
	var manager: TodoManager
	let item: TodoItem
	@State private var shakeAngle: Double = 0
	
	var body: some View {
		
		HStack(spacing: 20) {
			Image(systemName: item.isDone ? "checkmark" : "square")
				.foregroundStyle(item.isDone ? Color.red : .green)
				
			Text(item.title)
				.strikethrough(item.isDone, color: Color.red)
			Spacer()
		}
		.rotationEffect(Angle(degrees: shakeAngle))
		.animation(.spring(response: 0.2, dampingFraction: 0.8).repeatCount(10, autoreverses: true), value: shakeAngle)
		.transition(
			.asymmetric(
				insertion: .opacity,
				removal: .rotateBlurScaleFade
			)
		)
		.onTapGesture {
			shakeAngle = 2
			if let index = manager.todoItems.firstIndex(where: { $0.id == item.id }) {
				manager.todoItems[index].isDone.toggle()
			}
			
			manager.timers[item.id] = Timer.scheduledTimer(
				withTimeInterval: 1.0,
				repeats: false,
				block: { _ in
					withAnimation(.easeInOut(duration: 0.5)) {
						manager.todoItems.removeAll(where: { $0.id == item.id })
					}
				}
			)
		}
		.font(.title)
		.fontWeight(.bold)
		.padding(.vertical, 10)
	}
}

// MARK: - Transition ViewModifier
struct rotateBlurScaleFadeModifier: ViewModifier {
	let hasActivated: Bool
	
	func body(content: Content) -> some View {
		content
			.rotationEffect(.degrees(hasActivated ? 15 : 0))
			.blur(radius: hasActivated ? 10 : 0)
			.scaleEffect(hasActivated ? 0.5 : 1.0)
			.opacity(hasActivated ? 0.0 : 1.0)
	}
}

// MARK: - Custom Transition 적용
extension AnyTransition {
	static var rotateBlurScaleFade: AnyTransition {
		AnyTransition.modifier(
			active: rotateBlurScaleFadeModifier(hasActivated: true),
			identity: rotateBlurScaleFadeModifier(hasActivated: false)
		)
	}
}

#Preview {
    CheckListStampView()
}

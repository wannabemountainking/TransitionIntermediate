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
	var isDoneTimers: [UUID : Timer] = [:]
	var stampTimers: [UUID : Timer] = [:]
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
			VStack {
				ForEach(manager.todoItems, id: \.id) { item in
					if item.isStampVisible {
						VStack(alignment: .leading) {
							Text("완료됨")
								.font(.largeTitle)
								.fontWeight(.bold)
								.foregroundStyle(Color.pink)
								.padding(.horizontal, 50)
						}
						.transition(.overShootScale)
						.frame(maxWidth: .infinity, alignment: .leading)
					} else {
						TodoBoxView(manager: manager, item: item)
					}
				}
				Spacer()
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
			shakeAngle = 4
			
			withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5)) {
				if let index = manager.todoItems.firstIndex(where: { $0.id == item.id }) {
					manager.todoItems[index].isDone.toggle()
				}
			}
			
			manager.isDoneTimers[item.id] = Timer.scheduledTimer(
				withTimeInterval: 1.0,
				repeats: false,
				block: { _ in
					withAnimation(.easeInOut(duration: 0.5)) {
						manager.todoItems.removeAll(where: { $0.id == item.id })
					}
				}
			)
			
			manager.stampTimers[item.id] = Timer.scheduledTimer(
				withTimeInterval: 0.5,
				repeats: false,
				block: { _ in
					withAnimation(.spring(response: 0.15, dampingFraction: 0.9)) {
						if let index = manager.todoItems.firstIndex(where: { $0.id == item.id }) {
							manager.todoItems[index].isStampVisible.toggle()
						}
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
struct RotateBlurScaleFadeModifier: ViewModifier {
	let hasActivated: Bool
	
	func body(content: Content) -> some View {
		content
			.rotationEffect(.degrees(hasActivated ? 15 : 0), anchor: .leading)
			.scaleEffect(hasActivated ? 0.5 : 1.0)
			.blur(radius: hasActivated ? 10 : 0)
			.opacity(hasActivated ? 0.0 : 1.0)
	}
}

struct OvershootScaleModifier: ViewModifier {
	let isActive: Bool
	
	func body(content: Content) -> some View {
		content
			.offset(y: isActive ? -5 : 0)
			.scaleEffect(isActive ? 1.03 : 1.0)
			.opacity(isActive ? 0.0 : 1.0)
	}
}


// MARK: - Custom Transition 적용
extension AnyTransition {
	static var rotateBlurScaleFade: AnyTransition {
		AnyTransition.modifier(
			active: RotateBlurScaleFadeModifier(hasActivated: true),
			identity: RotateBlurScaleFadeModifier(hasActivated: false)
		)
	}
}

extension AnyTransition {
	static var overShootScale: AnyTransition {
		AnyTransition.modifier(
			active: OvershootScaleModifier(isActive: true),
			identity: OvershootScaleModifier(isActive: false)
		)
	}
}

#Preview {
    CheckListStampView()
}

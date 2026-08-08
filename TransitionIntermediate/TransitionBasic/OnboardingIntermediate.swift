//
//  OnboardingIntermediate.swift
//  TransitionIntermediate
//
//  Created by YoonieMac on 8/7/26.
//

import SwiftUI

// MARK: - OnboardingStep Unit
struct OnboardingStep: Identifiable {
	let id = UUID()
	let iconName: String
	let title: String
	let subtitle: String
	let description: String
	let buttonName: String
	let accentColor: Color
}

// MARK: - StepManger @observable
@Observable
final class StepManager {
	
	let steps: [OnboardingStep] = [
		OnboardingStep(
			iconName: "hand.wave.fill",
			title: "Welcome!",
			subtitle: "Welcome to Transtion World",
			description: "This is an introduction of Transition World App",
			buttonName: "앱의 빠르기",
			accentColor: .purple
		),
		OnboardingStep(
			iconName: "airplane.up.forward",
			title: "Transportation",
			subtitle: "Incredible Speed, State-of-art Quality",
			description: "The App makes your life fast and convenient",
			buttonName: "다음장은 보안",
			accentColor: .pink
		),
		OnboardingStep(
			iconName: "lock.rotation",
			title: "Safety",
			subtitle: "Unbreakable Code for Personal Infomation",
			description: "Nobody can traspass your app",
			buttonName: "앱의 추구 방향",
			accentColor: .green
		),
		OnboardingStep(
			iconName: "figure.2.and.child.holdinghands",
			title: "Happiness",
			subtitle: "Expect better Tomorrow",
			description: "Family-oriented app leads your life to be prosperous",
			buttonName: "시작하기",
			accentColor: .orange
		)
	]
	
	// 1. stored properties
	/// 현재 페이지의 단계 번호
	var currentStep: Int = 1
	/// 다음 페이지가 앞방향이냐 뒷방향이냐
	var isForward: Bool = true
	/// 온보딩페이지가 완료되었나? == 메인 화면이 나올 차례냐
	var isCompleted: Bool = false
	
	// 2. computed properties
	/// 현재 페이지가 첫 페이지 이냐? - 이 경우 이전 버튼이 안나타남
	var isFirstStep: Bool {
		currentStep == 1
	}
	/// 현재 페이지가 마지막 페이지 이냐? - 이 경우 다음 버튼이 안나타남
	var isLastStep: Bool {
		currentStep == steps.count
	}
	/// 전체 페이지 == 마지막 페이지
	var totalSteps: Int {
		return steps.count
	}
	/// 페이지 진행 상황
	var progress: Double {
		Double(currentStep) / Double(totalSteps)
	}
	
	var mainPageTransition: AnyTransition {
		if isCompleted {
			return AnyTransition.asymmetric(
				insertion: .scale(scale: 0.4, anchor: .trailing)
					.combined(with: .opacity),
				removal: .scale(scale: 0.4, anchor: .leading)
					.combined(with: .opacity),
			)
		} else {
			return AnyTransition.asymmetric(
				insertion: .scale(scale: 0.4, anchor: .leading)
					.combined(with: .opacity),
				removal: .scale(scale: 0.4, anchor: .trailing)
					.combined(with: .opacity),
			)
		}
	}

	var onboardingPageTransition: AnyTransition {
		if isForward {
			return AnyTransition.asymmetric(
				insertion: .move(edge: .trailing)
					.combined(with: .opacity),
				removal: .move(edge: .leading)
					.combined(with: .opacity)
			)
		} else {
			return AnyTransition.asymmetric(
				insertion: .move(edge: .leading)
					.combined(with: .opacity),
				removal: .move(edge: .trailing)
					.combined(with: .opacity)
			)
		}
	}
	
	// 3. method
    /// 앞으로 이동
	func goToForwardStep() {
		guard currentStep > 0 && currentStep < totalSteps else {return}
		goToStep(target: currentStep + 1)
	}
	/// 뒤로 이동
	func goToBackwardStep() {
		guard currentStep > 1 && currentStep <= totalSteps else {return}
		goToStep(target: currentStep - 1)
	}
	/// 이동 기본 메서드
	private func goToStep(target: Int) {
		isForward = currentStep < target
		currentStep = target
	}
	
}

// MARK: - Main Control View
struct OnboardingIntermediate: View {
	
	@State private var manager: StepManager = StepManager()
	
    var body: some View {
		if manager.isCompleted {
			MainPageView(manager: manager)
				.transition(manager.mainPageTransition)
		} else {
			OnboardingPageView(manager: manager)
				.transition(manager.mainPageTransition)
		} //:CONDITION
    }
}

// MARK: - OnboardingPageView
struct OnboardingPageView: View {
	var manager: StepManager
	
	var body: some View {
		VStack(spacing: 5) {
			// MARK: - Header
			VStack(spacing: 10) {
				// 진행상황 - 건너뛰기
				HStack {
					Text("\(manager.currentStep) / \(manager.totalSteps)")
					Spacer()
					if !manager.isLastStep {
						Button("건너뛰기") {
							withAnimation(.easeInOut(duration: 1)) {
								manager.isCompleted = true
							}
						}
					}//:CONDITIONAL
				} //:HSTACK
				.font(.title3)
				.fontWeight(.semibold)
				
				// 진행바
				RoundedRectangle(cornerRadius: 5)
					.fill(Color.gray.opacity(0.3))
					.frame(height: 10)
					.overlay {
						GeometryReader { geo in
							RoundedRectangle(cornerRadius: 5)
								.fill(Color.green)
								.frame(
									width: geo.size.width * manager.progress,
									height: 10
								)
								.animation(.easeInOut(duration: 1), value: manager.progress)
						} //:GEOMETRY
					} //:OVERLAY
			} //:VSTACK
			.padding(.horizontal)
			.frame(height: 70)
			
			// MARK: - Current Content
			Spacer()
			switch manager.currentStep {
			case 1:
				PageComponent(step: manager.steps[0])
					.transition(manager.onboardingPageTransition)
			case 2:
				PageComponent(step: manager.steps[1])
					.transition(manager.onboardingPageTransition)
			case 3:
				PageComponent(step: manager.steps[2])
					.transition(manager.onboardingPageTransition)
			case 4:
				PageComponent(step: manager.steps[3])
					.transition(manager.onboardingPageTransition)
			default: EmptyView()
			}
			
			Spacer()
			
			// MARK: - Navigation
			VStack(spacing: 10) {
				
				PurpleButton(
					title: manager.steps[manager.currentStep - 1].buttonName,
					action: {
						withAnimation(.easeInOut(duration: 1)) {
							if manager.isLastStep {
								manager.isCompleted = true
							} else {
								manager.goToForwardStep()
							}
						}
					}
				)
				
				HStack {
					if !manager.isFirstStep {
						Button("이전") {
							withAnimation(.easeInOut(duration: 1)) {
								manager.goToBackwardStep()
							}
						}
					} else {
						Button("이전") { }
							.foregroundStyle(.white)
					}//:CONDITIONAL
					
					Spacer()
					
					HStack(spacing: 15) {
						ForEach(Array(manager.steps.enumerated()), id: \.element.id) {
							index,
							step in
							Circle()
								.fill(manager.currentStep == index + 1
									  ? Color.pink.opacity(0.7)
									  : Color.gray.opacity(0.5))
								.frame(width: 15, height: 15)
								.scaleEffect(manager.currentStep == index + 1 ? 1.5 : 1.0)
								.animation(.easeInOut(duration: 1), value: manager.currentStep)
						} //:LOOP
					} //:HSTACK
					
					Spacer()
					
					if !manager.isLastStep {
						Button("다음") {
							withAnimation(.easeInOut(duration: 1)) {
								manager.goToForwardStep()
							}
						}
					} else {
						Button("다음") { }
							.foregroundStyle(.white)
					}//:CONDITIONAL
				} //:HSTACK
				.font(.title3)
				.fontWeight(.black)
				.foregroundStyle(.black.opacity(0.7))
				.padding(.horizontal, 25)
			} //:VSTACK
		} //:VSTACK
	}
}

// MARK: - OnboardingPageComponent
struct PageComponent: View {
	//TODO: 속성과 뷰 작성
	// main Control View에서 받아오는 현재 페이지 정보 -> 이것을 변동시키면 다 변하므로 그런데 manager는 binding을 해야 할 듯
	let step: OnboardingStep
	var body: some View {
		
		VStack(alignment: .center, spacing: 40) {
			Circle()
				.fill(Color.red.opacity(0.3))
				.frame(width: 160, height: 160)
				.overlay(alignment: .center) {
					Image(systemName: step.iconName)
						.font(.system(size: 80))
						.foregroundStyle(step.accentColor)
				}
			VStack(spacing: 10) {
				Text(step.title)
					.font(.title2)
					.fontWeight(.bold)
				Text(step.subtitle)
					.font(.headline)
					.fontWeight(.medium)
				Text(step.description)
					.font(.subheadline)
					.fontWeight(.ultraLight)
			}
			.frame(width: 250)
		}
	}
	
	
	
}

// MARK: - MainView of App
struct MainPageView: View {
	
	var manager: StepManager
	
	var body: some View {
		VStack(spacing: 10) {
			Spacer()
			VStack(spacing: 40) {
				Image(systemName: "hands.and.sparkles.fill")
					.font(.system(size: 80))
					.foregroundStyle(.purple)
				Text("축하합니다.")
					.font(.largeTitle)
			}
			Spacer()
			PurpleButton(
				title: "다시 시작하기",
				action: {
					withAnimation(.easeInOut(duration: 1)) {
						manager.currentStep = 1
						manager.isForward = true
						manager.isCompleted = false
					}
				}
			)
		} //:VSTACK
	}
}

#Preview {
    OnboardingIntermediate()
}


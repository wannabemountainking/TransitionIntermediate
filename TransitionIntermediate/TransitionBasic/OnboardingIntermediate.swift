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
			buttonName: "메인 화면으로",
			accentColor: .orange
		)
	]
	
	// 1. stored properties
	/// 현재 페이지의 단계 번호
	var currentStep: Int = 1
	/// 다음 페이지가 앞방향이냐 뒷방향이냐
	var isForward: Bool = false
	
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
	func goToStep(target: Int) {
		isForward = currentStep < target
		currentStep = target
	}
	
}

struct OnboardingIntermediate: View {
	
	@State private var manager: StepManager = StepManager()
	
    var body: some View {
        
    }
}

struct MainPageView: View {
	
	var body: some View {
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
				
			}
		)
	}
}

#Preview {
    OnboardingIntermediate()
}

#Preview("MainPageView") {
	MainPageView()
}

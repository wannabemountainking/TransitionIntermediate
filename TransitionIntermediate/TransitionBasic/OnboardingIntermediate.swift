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
	let step: Int
	let iconName: String
	let title: String
	let subtitle: String
	let description: String
	let accentColor: Color
}

// MARK: - StepManger @observable
@Observable
final class StepManager {
	
	let steps: [OnboardingStep] = [
		OnboardingStep(
			step: 1,
			iconName: "hand.wave.fill",
			title: "Welcome!",
			subtitle: "Welcome to Transtion World",
			description: "This is an introduction of Transition World App",
			accentColor: .purple
		),
		OnboardingStep(
			step: 2,
			iconName: "airplane.up.forward",
			title: "Transportation",
			subtitle: "Incredible Speed, State-of-art Quality",
			description: "The App makes your life fast and convenient",
			accentColor: .pink
		)
	]
}

struct OnboardingIntermediate: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    OnboardingIntermediate()
}

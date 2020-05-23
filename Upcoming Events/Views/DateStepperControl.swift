//
//  DateStepperControl.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/22/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import SwiftUI
import Combine

struct DateStepperControl: View {
	@ObservedObject var dayViewModel: DayViewModel

	@State private var isPreviousButtonDisabled = true
	@State private var isNextButtonDisabled = true
	@State private var currentDayString = ""

	var body: some View {
		HStack {
			DateStepperButton(action: dayViewModel.goToPreviousDay, disabled: isPreviousButtonDisabled, direction: .left)
			.disabled(self.isPreviousButtonDisabled)
			.onReceive(dayViewModel.canGoToPreviousDay) { canGoToPreviousDay in
				self.isPreviousButtonDisabled = !canGoToPreviousDay
			}

			Text(self.currentDayString)
				.font(.headline)
				.multilineTextAlignment(.center)
				.lineLimit(1)
				.foregroundColor(.white)
				
				.frame(width: 170.0)
				.onReceive(dayViewModel.$currentDay) { currentDay in
				self.currentDayString = currentDay.description
			}

			DateStepperButton(action: dayViewModel.goToNextDay, disabled: isNextButtonDisabled, direction: .right)
			.disabled(self.isNextButtonDisabled)
			.onReceive(dayViewModel.canGoToNextDay) { canGoToNextDay in
				self.isNextButtonDisabled = !canGoToNextDay
			}.padding(0)
		}.padding(.horizontal, 20.0)
	}
}

struct DateStepperButton: View {
	enum Direction {
		case left
		case right

		var iconName: String {
			switch self {
			case .left:
				return "arrowtriangle.left.fill"
			default:
				return "arrowtriangle.right.fill"
			}
		}

		var offset: (ellipse: CGFloat, icon: CGFloat) {
			switch self {
			case .left:
				return (-20.0, -10.0)
			default:
				return (20.0, 10.0)
			}
		}
	}

	let action: () -> Void
	let disabled: Bool
	let direction: Direction

	var body: some View {
		Button(action: action) {
			ZStack {
				RoundedRectangle(cornerRadius: 5, style: .continuous)
					.frame(width: 60, height: 30, alignment: .center)
					.foregroundColor(disabled ? Color(red: 0.54, green: 0.56, blue: 0.61) : Color(.white))

				Ellipse().frame(width: 60, height: 30)
					.offset(x: direction.offset.ellipse, y: 0)
					.foregroundColor(disabled ? Color(red: 0.54, green: 0.56, blue: 0.61) : Color(.white))

				Image(systemName: direction.iconName)
					.frame(width: 60.0)
					.offset(x: direction.offset.icon, y: 0)
					.font(.title)
					.foregroundColor(disabled ? Color(red: 0.7, green: 0.7, blue: 0.7) : Color(red: 0.26, green: 0.40, blue: 0.70))

			}
		}
	}
}

struct DateStepperControl_Previews: PreviewProvider {
	static let previewEvents = Event.createMockEvents(count: 10, eventsPerDay: 10)

	static var previews: some View {
		ZStack {
			Color(red: 0.26, green: 0.40, blue: 0.70)
			DateStepperControl(dayViewModel: DayViewModel(fromEvents: self.previewEvents))
		}
		.previewLayout(.fixed(width: 375, height: 100))
	}
}

struct DateStepperControl_PreviewsDarkMode: PreviewProvider {
	static let previewEvents = Event.createMockEvents(count: 10, eventsPerDay: 10)

	static var previews: some View {
		ZStack {
			Color(red: 0.26, green: 0.40, blue: 0.70)
			DateStepperControl(dayViewModel: DayViewModel(fromEvents: self.previewEvents))
		}
		.previewLayout(.fixed(width: 400, height: 100))
		.environment(\.colorScheme, .dark)
	}
}

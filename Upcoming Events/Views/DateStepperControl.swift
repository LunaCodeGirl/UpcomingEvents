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
			Button(action: dayViewModel.goToPreviousDay) {
				Image(systemName: "chevron.left.square.fill")
			}
			.disabled(self.isPreviousButtonDisabled)
			.onReceive(dayViewModel.canGoToPreviousDay) { canGoToPreviousDay in
				self.isPreviousButtonDisabled = !canGoToPreviousDay
			}

			Text(self.currentDayString)
			.onReceive(dayViewModel.$currentDay) { currentDay in
				self.currentDayString = currentDay.description
			}

			Button(action: dayViewModel.goToNextDay) {
				Image(systemName: "chevron.right.square.fill")
			}
			.disabled(self.isNextButtonDisabled)
			.onReceive(dayViewModel.canGoToNextDay) { canGoToNextDay in
				self.isNextButtonDisabled = !canGoToNextDay
			}
		}
	}
}

struct DateStepperControl_Previews: PreviewProvider {
	static let previewEvents = Event.createMockEvents(count: 10, eventsPerDay: 10)

	static var previews: some View {
		DateStepperControl(dayViewModel: DayViewModel(fromEvents: self.previewEvents))
			.previewLayout(.fixed(width: 375, height: 100))
	}
}

struct DateStepperControl_PreviewsDarkMode: PreviewProvider {
	static let previewEvents = Event.createMockEvents(count: 10, eventsPerDay: 10)

	static var previews: some View {
		ZStack {
			Color(.black)
			DateStepperControl(dayViewModel: DayViewModel(fromEvents: self.previewEvents))
		}
		.previewLayout(.fixed(width: 400, height: 100))
		.environment(\.colorScheme, .dark)
	}
}

//
//  DayViewModel.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/22/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation
import Combine

struct Day: Hashable  {
	let dateComponents: DateComponents

	var date: Date {
		guard let today = Calendar.current.date(from: dateComponents) else {
			assertionFailure("Day has invalid dateComponents!")
			return Date.now
		}

		return today
	}

	private static let componentsOfADay: Set<Calendar.Component> = [.year, .month, .day]

	init(fromDate date: Date) {
		dateComponents = Calendar.current.dateComponents(Day.componentsOfADay, from: date)
	}
}

class DayViewModel: ObservableObject {
	private static let generatedData: DayViewModel = {
		let events = Event.createMockEvents(count: 100, startDate: 1.weeks.ago, eventsPerDay: 4)

		 let days = Dictionary(grouping: events) { (event:Event) -> Day in
			return Day(fromDate: event.startDate)
		}

		return DayViewModel(days: days)
	}()

	private static let givenMockData: DayViewModel = {
		let events = try! Event.eventsFromJSON(FileUtilities.getDataFromFile(named: "mock_events.json")!).sorted()

		 let days = Dictionary(grouping: events) { (event:Event) -> Day in
			return Day(fromDate: event.startDate)
		}

		return DayViewModel(days: days)
	}()

	static var shared: DayViewModel {
		return UserDefaults.standard.bool(forKey: "IsUsingProvidedMockDataKey") ? self.givenMockData : self.generatedData
	}

	@Published private(set) var currentDay: Day
	@Published private(set) var currentEvents: [Event]

	lazy var canGoToPreviousDay: AnyPublisher<Bool, Never> = {
		$currentDayIndex.map { index -> Bool in
			return index > 0
		}.eraseToAnyPublisher()
	}()

	lazy var canGoToNextDay: AnyPublisher<Bool, Never> = {
		$currentDayIndex.map { index -> Bool in
			return index < self.sortedDays.count - 1
		}.eraseToAnyPublisher()
	}()

	typealias Days = [Day:[Event]]
	private let days: Days
	private let sortedDays: [Day]

	@Published private var currentDayIndex: Int {
		didSet {
			currentDay = sortedDays[currentDayIndex]
			currentEvents = days[currentDay] ?? []
		}
	}

	init(days: Days) {
		self.days = days

		let initialSortedDays = days.keys.sorted()

		var initialCurrentDay = Day(fromDate: Date.now)
		if !days.keys.contains(initialCurrentDay) {
			initialCurrentDay = days.first?.key ?? initialCurrentDay
		}

		currentDayIndex = initialSortedDays.firstIndex(of: initialCurrentDay) ?? 0
		sortedDays = initialSortedDays

		currentDay = initialCurrentDay
		currentEvents = days[initialCurrentDay] ?? []
	}

	convenience init(fromEvents events: [Event]) {
		let days = Dictionary(grouping: events) { (event:Event) -> Day in
			return Day(fromDate: event.startDate)
		}

		self.init(days: days)
	}

	func goToNextDay() {
		currentDayIndex += 1
	}

	func goToPreviousDay() {
		currentDayIndex -= 1
	}
}

extension Day: CustomStringConvertible {
	var description: String {
		let result =  Day.dayFormatter.string(from: self.date)
		return result
	}

	private static let dayFormatter: DateFormatter = {
		let formatter =  DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.doesRelativeDateFormatting = true
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()
}

extension Day: Comparable {
	static func < (lhs: Day, rhs: Day) -> Bool {
		lhs.date < rhs.date
	}
}

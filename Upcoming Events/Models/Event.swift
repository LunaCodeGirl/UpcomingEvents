//
//  Event.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/20/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation

struct Event {
	let title: String
	let startDate: Date
	let endDate: Date

	var dateInterval: DateInterval {
		return DateInterval(start: startDate, end: endDate)
	}

	var isInPast: Bool {
		endDate < Date.now
	}

//	static func fetchAllEvents() -> [Event] {
//		//		events = try! Event.eventsFromJSON(FileUtilities.getDataFromFile(named: "mock_events_2.json")!).sorted()
//		return Event.createMockEvents(count: 100, startDate: 1.weeks.ago, eventsPerDay: 4)
//	}

	func conflictsWith(_ otherEvent: Event) -> Conflict? {
		guard let overlap = dateInterval.intersection(with: otherEvent.dateInterval) else { return nil }

		return overlap.duration > 0 ? Conflict(self, otherEvent) : nil
	}

	func conflictingEvent(forConflict conflict: Conflict) -> Event? {
		guard conflict.first == self || conflict.second == self else { return nil }

		return (conflict.first == self) ? conflict.second : conflict.first
	}
}

extension Event: Comparable, Hashable {
	static func < (lhs: Event, rhs: Event) -> Bool {
		lhs.startDate < rhs.startDate
	}
}

extension Event: Decodable {
	enum CodingKeys: String, CodingKey {
		case title
		case startDate = "start"
		case endDate = "end"
	}

	static let dateFormatter: DateFormatter = {
		let formatter =  DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "MMMM d, yyyy h:mm a"
		return formatter
	}()

	static func eventsFromJSON(_ json: Data) throws -> [Event] {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		let result = try decoder.decode([Event].self, from: json)
		return result
	}
}

#if DEBUG

extension Event {
	static func createMockEvents(count: Int = 1000,
								 startDate: Date = Date.now,
								 eventsPerDay: Int = 20,
								 minEventLength: TimeInterval = 10.minutes,
								 maxEventLength: TimeInterval = 2.hours) -> [Event] {

		let endDate = startDate + (count / eventsPerDay).days
		
		// Converting dates to TimeIntervals to simplivy working with them

		let startDateInterval = startDate.timeIntervalSinceReferenceDate
		let endDateInterval = endDate.timeIntervalSinceReferenceDate

		let createAndApplyDates:((Date) -> (Date) -> Event) -> Event = { curriedEventCreator in
			let eventLength = TimeInterval.random(in: minEventLength...maxEventLength)
			var randomStartTime: TimeInterval

			repeat {
				randomStartTime = TimeInterval.random(in: startDateInterval...endDateInterval)
			} while randomStartTime + eventLength > endDateInterval

			let startDate = Date(timeIntervalSinceReferenceDate: randomStartTime)
			let endDate = Date(timeIntervalSinceReferenceDate: randomStartTime + eventLength)
			return curriedEventCreator(startDate)(endDate)
		}

		let randomEventTitles: [String] = FileUtilities.getStringFromFile(named: "mock_event_titles.txt")!.split(separator: "\n").map { String($0) }

		let result = (0..<count)
			.map { _ -> String in randomEventTitles.randomElement()! }
			.map(curry(Event.init))
			.map(createAndApplyDates)

		return result.sorted()
	}
}

#endif

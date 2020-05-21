//
//  EventTests.swift
//  Upcoming EventsTests
//
//  Created by Luna Comerford on 5/20/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import XCTest

@testable import Upcoming_Events

class EventTests: XCTestCase {

	func testEventsCanBeSuccessfullyDecodedFromJSON() {
		let json: Data? = FileUtilities.getDataFromFile(named: "mock_events.json")
		XCTAssertNoThrow(try Event.eventsFromJSON(json!))
	}

	// MARK: - Conflicting Events Tests

	func testEventsWithNoOverlapDontConflict() {
		let event1 = Event(title: "One", startDate: 1.hours.fromNow, endDate: 2.hours.fromNow)
		let event2 = Event(title: "Two", startDate: 5.hours.fromNow, endDate: 6.hours.fromNow)
		XCTAssertNil(event1.conflictsWith(event2))
	}

	func testConsecutiveEventsDontConflict() {
		let event1 = Event(title: "One", startDate: 1.hours.fromNow, endDate: 2.hours.fromNow)
		let event2 = Event(title: "Two", startDate: 2.hours.fromNow, endDate: 3.hours.fromNow)
		XCTAssertNil(event1.conflictsWith(event2))
	}

	func testEventsOnDifferentDaysDontConflict() {
		let event1 = Event(title: "One", startDate: Date.now, endDate: Date.now + 1.hours)
		let event2 = Event(title: "Two", startDate: 1.days.fromNow, endDate: 1.days.fromNow + 1.hours)
		XCTAssertNil(event1.conflictsWith(event2))
	}

	func testEventsWithSameStartTimesConflict() {
		let event1 = Event(title: "One", startDate: 1.hours.ago, endDate: 2.hours.fromNow)
		let event2 = Event(title: "Two", startDate: 1.hours.ago, endDate: 6.hours.fromNow)
		XCTAssertNotNil(event1.conflictsWith(event2))
	}

	func testEventsWithDifferentStartTimesConflict() {
		let event1 = Event(title: "One", startDate: 2.hours.ago, endDate: 2.hours.fromNow)
		let event2 = Event(title: "Two", startDate: Date.now, endDate: 6.hours.fromNow)
		XCTAssertNotNil(event1.conflictsWith(event2))
	}
}

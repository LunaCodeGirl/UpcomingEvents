//
//  ConflictTests.swift
//  Upcoming EventsTests
//
//  Created by Luna Comerford on 5/21/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import XCTest

@testable import Upcoming_Events

class ConflictTests: XCTestCase {

	func testInitializerSortsEventsByStartDate() {
		let firstEvent = Event(title: "First", startDate: 1.hours.fromNow, endDate: 2.hours.fromNow)
		let secondEvent = Event(title: "Second", startDate: 90.minutes.fromNow, endDate: 3.hours.fromNow)
		let conflict = Conflict(secondEvent, firstEvent)
		XCTAssertEqual(conflict.first, firstEvent)
		XCTAssertEqual(conflict.second, secondEvent)
	}

	func testInitializerHandlesEventsWithSameStartTime() {
		let firstEvent = Event(title: "First", startDate: 1.hours.fromNow, endDate: 2.hours.fromNow)
		let secondEvent = Event(title: "Second", startDate: 1.hours.fromNow, endDate: 3.hours.fromNow)
		let conflict = Conflict(firstEvent, secondEvent)
		XCTAssertEqual(conflict.first, firstEvent)
		XCTAssertEqual(conflict.second, secondEvent)
	}

	func testConflictEqualityWhenContainedEventsAreTheSame() {
		let firstEvent = Event(title: "First", startDate: 1.hours.fromNow, endDate: 2.hours.fromNow)
		let secondEvent = Event(title: "Second", startDate: 90.minutes.fromNow, endDate: 3.hours.fromNow)
		let conflict1 = Conflict(firstEvent, secondEvent)
		let conflict2 = Conflict(secondEvent, firstEvent)
		XCTAssertEqual(conflict1, conflict2)
	}

	func testConflictInequalityWhenContainedEventsAreDifferent() {
		let firstEvent = Event(title: "First", startDate: 1.hours.fromNow, endDate: 2.hours.fromNow)
		let secondEvent = Event(title: "Second", startDate: 90.minutes.fromNow, endDate: 3.hours.fromNow)
		let thirdEvent = Event(title: "Third", startDate: 3.hours.fromNow, endDate: 4.hours.fromNow)
		let conflict1 = Conflict(firstEvent, secondEvent)
		let conflict2 = Conflict(firstEvent, thirdEvent)
		XCTAssertNotEqual(conflict1, conflict2)
	}

	// MARK: - Conflict.generateConflictsFromEvents() | Tests of algorithm to find conflicts between events

	// These events roughly match the "Event Conflict Visualization" drawing which I've included in the root project folder.
	let testEventOne = Event(title: "One", startDate: Date.now, endDate: 4.hours.fromNow)
	let testEventTwo = Event(title: "Two", startDate: 3.hours.fromNow, endDate: 13.hours.fromNow)
	let testEventThree = Event(title: "Three", startDate: 4.hours.fromNow, endDate: 10.hours.fromNow)
	let testEventFour = Event(title: "Four", startDate: 8.hours.fromNow, endDate: 12.hours.fromNow)
	let testEventFive = Event(title: "Five", startDate: 9.hours.fromNow, endDate: 10.hours.fromNow)
	let testEventSix = Event(title: "Six", startDate: 13.hours.fromNow, endDate: 16.hours.fromNow)

	var testEventList: [Event] {
		return [testEventOne, testEventTwo, testEventThree, testEventFour, testEventFive, testEventSix]
	}

	func testGenerateConflictsFromEventsProducesExpectedConflicts() {
		let expectedConflicts: Set<Conflict> = [
			Conflict(testEventOne, testEventTwo),
			Conflict(testEventTwo, testEventThree),
			Conflict(testEventTwo, testEventFour),
			Conflict(testEventTwo, testEventFive),
			Conflict(testEventThree, testEventFour),
			Conflict(testEventThree, testEventFive),
			Conflict(testEventFour, testEventFive),
		]

		let generatedConflicts = Set<Conflict>(Conflict.generateConflictsFromEvents(testEventList))

		XCTAssertEqual(expectedConflicts, generatedConflicts)
	}

}

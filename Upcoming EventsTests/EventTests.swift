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
}

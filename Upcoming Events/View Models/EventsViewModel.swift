//
//  EventsViewModel.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/21/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation
import Combine

class EventsViewModel: ObservableObject {

	let events: [Event]
	let eventToConflictsMap: [Event:[Conflict]]

	init() {
		events = try! Event.eventsFromJSON(FileUtilities.getDataFromFile(named: "mock_events_2.json")!).sorted()
		let conflicts = Conflict.generateConflictsFromEvents(events)
		var eventToConflictsMap:[Event:[Conflict]] = [:]

		conflicts.forEach { conflict in
			let appendConflictToEventArray:(Event) -> Void = { event in
				if var bucket = eventToConflictsMap[event] {
					bucket.append(conflict)
					eventToConflictsMap[event] = bucket
				} else {
					eventToConflictsMap[event] = [conflict]
				}
			}

			appendConflictToEventArray(conflict.first)
			appendConflictToEventArray(conflict.second)
		}

		self.eventToConflictsMap = eventToConflictsMap
	}
}

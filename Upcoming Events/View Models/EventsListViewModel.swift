//
//  EventsListViewModel.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/21/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation
import Combine

class EventsListViewModel: ObservableObject {

	let events: [Event]

	init(events: [Event]) {
		self.events = events
	}
	
	lazy var eventToConflictsMap: [Event:[Conflict]] = {
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

		return eventToConflictsMap
	}()
}

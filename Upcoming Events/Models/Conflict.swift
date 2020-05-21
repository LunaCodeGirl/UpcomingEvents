//
//  Conflict.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/21/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation

struct Conflict {
	let first: Event
	let second: Event

	init(_ firstEvent: Event, _ secondEvent: Event) {
		first = min(firstEvent, secondEvent)
		second = max(firstEvent, secondEvent)
	}
}

extension Conflict: Hashable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		if lhs.first == rhs.first {
			return lhs.second == rhs.second
		} else {
			return lhs.first == rhs.second && lhs.second == rhs.first
		}
	}
}

extension Conflict: CustomStringConvertible, CustomDebugStringConvertible {
	var description: String {
		"[\(first.title) & \(second.title)]"
	}

	var debugDescription: String {
		"(\(first.title) & \(second.title))"
	}
}

// MARK: - Assignment algorithm

extension Conflict {
	
	static func generateConflictsFromEvents(_ events: [Event]) -> [Conflict] {
		guard events.count > 1 else { return [] }

		let sortedEvents = events.sorted()

		var conflicts: [Conflict] = []

		var lowIndex = 0
		var highIndex = 1

		repeat {
			let earlierEvent = sortedEvents[lowIndex]
			let laterEvent = sortedEvents[highIndex]

			if let conflict = earlierEvent.conflictsWith(laterEvent) {
				conflicts.append(conflict)
				highIndex += 1
			} else {
				lowIndex += 1
				highIndex = lowIndex + 1
			}

			if highIndex == events.count {
				lowIndex += 1
				highIndex = lowIndex + 1
			}

		} while lowIndex < events.count - 1

		return conflicts
	}
}

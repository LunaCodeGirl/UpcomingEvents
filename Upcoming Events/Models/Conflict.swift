//
//  Conflict.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/21/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation

struct Conflict {
	private static var counter = 0

	let first: Event
	let second: Event
	let id: Int

	init(_ firstEvent: Event, _ secondEvent: Event) {
		first = min(firstEvent, secondEvent)
		second = max(firstEvent, secondEvent)
		id = Conflict.counter
		Conflict.counter += 1
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

	func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(second)
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
/**
	 # Algorithm Description

	The way the conflict generation works is essentially using a greedy algorithm. We first sort all of the events by their start dates. This step has a complexity of **O(n*log(n))**.

	With the sorted list of events `[A, B, C, D]`, we walk through two events at a time, starting with `(A, B)`. If `B` has a start time that is earlier than `A`’s end time, that’s a conflict, and we append it to our list of conflicts.

	We then make a new pair with the same earlier event, but the next later event, `(A, C)`. We then repeat until the start time of the later event is after the end time of the earlier event.

	At that point, we move the earlier of the pair to to the next event in the list (`B` in my example) and start from the beginning with the sequential pair, `(B, C)`.

	In a worst case scenario, the number of times this loop would happen is equal to the possible number of unique combinations of 2 events, n / 2. So the complexity of this part of the algorithm is effectively **O(n)**.

	That means the time complexity of the algorithm is **O(n*log(n))** due to the complexity from the sorting step.

	There are probably some ways to make this algorithm even smarter about time spans, but it seemed like it could be error prone, and it wouldn’t help reduce the complexity any more since after sorting the rest is already **O(n)**.

	### I’ve included a visual diagram I drew to help think about the problem in the root project folder.
*/

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

//
//  EventList.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/19/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import SwiftUI

struct EventList: View {
	@ObservedObject var viewModel: EventsListViewModel

	init(viewModel: EventsListViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		List(viewModel.events, id: \.self) { event in
			EventRow(event: event, conflicts: self.viewModel.eventToConflictsMap[event])
		}.navigationBarTitle("Upcomming Events")
	}
}

struct EventRow: View {

	let event: Event
	let conflicts: [Conflict]?

	private var conflictColors:[Color] {
		guard let conflicts = conflicts else { return [] }

		return conflicts.map { conflict -> Color in
			self.conflictColorList[conflict.id % self.conflictColorList.count]
		}
	}

	private static let timeFormatter: DateFormatter = {
		let formatter =  DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		return formatter
	}()

	private let conflictColorList: [Color] = [.orange, .red, .pink, .purple, .blue]

	var body: some View {
		HStack {
			VStack {
				ForEach(conflictColors, id: \.self) { color in
					Image(systemName: "exclamationmark.circle").foregroundColor(color)
				}
			}
			VStack(alignment: .leading) {
				Text(event.title).font(.headline)
				HStack {
					Text(EventRow.timeFormatter.string(from: event.startDate))
					Text(EventRow.timeFormatter.string(from: event.endDate))
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static let previewEvents = Event.createMockEvents(count: 10, eventsPerDay: 3)

	static var previews: some View {
		EventList(viewModel: EventsListViewModel(events: self.previewEvents))
	}
}

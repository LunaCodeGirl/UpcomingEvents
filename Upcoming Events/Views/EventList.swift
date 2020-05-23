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

	private var numberedEvents: [(event: Event, number: Int)]  {
		viewModel.events.enumerated().map { index, event in
			(event: event, number: index + 1)
		}
	}

	init(viewModel: EventsListViewModel) {
		self.viewModel = viewModel
		UITableView.appearance().tableFooterView = UIView()
		UITableView.appearance().separatorStyle = .none
	}

	var body: some View {
		List {
			ForEach(numberedEvents, id: \.1) { (event: Event, number: Int) in
				EventRow(event: event, conflicts: self.viewModel.eventToConflictsMap[event], eventNumber: number, numberedEvents: self.numberedEvents)
					.listRowInsets(EdgeInsets())
					.opacity(event.isInPast ? 0.3 : 1.0)
			}
		}
	}
}

struct EventRow: View {

	let event: Event
	let conflicts: [Conflict]?
	let eventNumber: Int
	let numberedEvents: [(event: Event, number: Int)]

	private var eventIsInPast: Bool {
		event.endDate < Date.now
	}

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
		let conflictDetails = self.getConflictDetails()

		return VStack(alignment: .leading) {
			Rectangle().fill(Color(white: 0.8)).frame(height: 0.5)
			HStack {
				Number(number: eventNumber)
				VStack(alignment: .leading) {
					Text(event.title)
						.font(.system(size: 24))
						.fontWeight(.thin)
						.lineLimit(1)
						.padding(.bottom, 5)

					HStack(alignment: .center) {
						Text("Time: ")
						.font(.callout)
						.fontWeight(.regular)

						+ Text(EventRow.timeFormatter.string(from: event.startDate))
							.font(.callout)
							.fontWeight(.regular)

							+ Text(" - ")
								.font(.callout)
								.fontWeight(.regular)
								.foregroundColor(.gray)

							+ Text(EventRow.timeFormatter.string(from: event.endDate))
								.font(.callout)
								.fontWeight(.regular)
					}
				}
			}
			.padding(.bottom, 5.0)
			.padding(.horizontal, 10.0)

			ForEach(conflictDetails, id: \.conflictingEvent) { details in
				ConflictBanner(conflictingEvent: details.conflictingEvent, conflictingEventNumber: details.conflictingEventNumber).padding(.top, -10)
			}
		}
		.padding(.vertical, 5)
	}

	func getConflictDetails() -> [(conflictingEvent: Event, conflictingEventNumber: Int)] {
		guard let conflicts = conflicts else { return [] }

		return conflicts.compactMap { conflict in
			guard let conflictingEvent = event.conflictingEvent(forConflict: conflict) else {
				assertionFailure()
				return nil
			}

			let conflictingEventNumber = self.numberedEvents.first(where: { $0.event == conflictingEvent })!.number

			return (conflictingEvent: conflictingEvent, conflictingEventNumber: conflictingEventNumber)
		}
	}
}

struct Number: View {

	let number: Int

	var body: some View {
		ZStack(alignment: .center) {
			Circle()
				.fill(Color(red: 0.26, green: 0.40, blue: 0.70))
				.frame(width: 40, height: 40)
			Text("\(number)")
				.font(.title)
				.fontWeight(.heavy)
				.foregroundColor(.white)
		}
	}
}

struct ConflictBanner: View {

	let conflictingEvent: Event
	let conflictingEventNumber: Int

	var body: some View {
		HStack {
			ZStack(alignment:.center) {
				Image(systemName: "exclamationmark.triangle").foregroundColor(Color.white).font(.system(size: 23.0))
			}.frame(width: 40, alignment: .center)

			Text("This event conflicts with event #\(conflictingEventNumber)!")
				.font(.callout)
				.fontWeight(.regular)
				.foregroundColor(.white)
		}
		.padding(.horizontal, 10.0)
		.padding(.vertical, 5.0)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color.red)
	}
}

struct ContentView_Previews: PreviewProvider {
	static let previewEvents = try! Event.eventsFromJSON(FileUtilities.getDataFromFile(named: "mock_events.json")!).sorted()

	static var previews: some View {
		EventList(viewModel: EventsListViewModel(events: self.previewEvents))
	}
}

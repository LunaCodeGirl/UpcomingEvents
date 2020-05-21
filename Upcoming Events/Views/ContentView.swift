//
//  ContentView.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/19/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel: EventsViewModel

	init(viewModel: EventsViewModel = EventsViewModel()) {
		self.viewModel = viewModel
	}

	var body: some View {
		List(viewModel.events, id: \.self) { event in
			EventRow(event: event)
		}.navigationBarTitle("Upcomming Events")
	}
}

struct EventRow: View {

	let event: Event

	private static let dayFormatter: DateFormatter = {
		let formatter =  DateFormatter()
		formatter.doesRelativeDateFormatting = true
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	}()

	private static let timeFormatter: DateFormatter = {
		let formatter =  DateFormatter()
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		return formatter
	}()

	var body: some View {
		VStack(alignment: .leading) {
			Text(event.title).font(.headline)
			Text(EventRow.dayFormatter.string(from: event.startDate))
			HStack {
				Text(EventRow.timeFormatter.string(from: event.startDate))
				Text(EventRow.timeFormatter.string(from: event.endDate))
			}
		}

	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

//
//  DayView.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/22/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import SwiftUI

struct DayView: View {
	@ObservedObject var dayViewModel: DayViewModel

	init(viewModel: DayViewModel = DayViewModel.shared) {
		self.dayViewModel = viewModel
	}

    var body: some View {
		NavigationView {
			VStack {
				DateStepperControl(dayViewModel: self.dayViewModel)
				EventList(viewModel: EventsListViewModel(events: self.dayViewModel.currentEvents))
			}
		}
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
    }
}

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

	@State var showingAlert: Bool = true

	private var isUsingProvidedMockData:Bool {
		UserDefaults.standard.bool(forKey: "IsUsingProvidedMockDataKey")
	}

	private var alertTitle: String {
		if isUsingProvidedMockData {
			return "Do you want to have random data generated?"
		} else {
			return "Do you want to use the provided mock_events.json data?"
		}
	}

	private var alertMessage: String {
		if isUsingProvidedMockData {
			return "Right now the app is using the provided json data. If you select \"Yes\" This will require an app restart to take effect."
		} else {
			return "By default I generate a random set of data. If you select \"Yes\" This will require an app restart to take effect."
		}
	}

	init(viewModel: DayViewModel = DayViewModel.shared) {
		self.dayViewModel = viewModel
	}

    var body: some View {
		VStack {
			ZStack(alignment: .bottom) {
				Rectangle()
					.fill(Color(red: 0.26, green: 0.40, blue: 0.70))
					.frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)

				DateStepperControl(dayViewModel: self.dayViewModel).padding(.bottom, 15)
			}
			EventList(viewModel: EventsListViewModel(events: self.dayViewModel.currentEvents))
		}
		.edgesIgnoringSafeArea(.all)
		.alert(isPresented: $showingAlert) {
			Alert(title: Text(self.alertTitle), message: Text(self.alertMessage),
				  primaryButton: .destructive(Text("Yes")) {
					UserDefaults.standard.set(!self.isUsingProvidedMockData, forKey: "IsUsingProvidedMockDataKey")
					self.showingAlert = false
				}, secondaryButton: .cancel(Text("No"), action: {
					self.showingAlert = false
				}))
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
    }
}

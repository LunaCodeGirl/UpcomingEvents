//
//  DateUtilities.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/21/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation

extension Date {
	// Signature copied from DateComponents.init
	init?(calendar: Calendar? = Calendar.current,
		 timeZone: TimeZone? = TimeZone.current,
		 era: Int? = nil,
		 year: Int? = nil,
		 month: Int? = nil,
		 day: Int? = nil,
		 hour: Int? = nil,
		 minute: Int? = nil,
		 second: Int? = nil,
		 nanosecond: Int? = nil,
		 weekday: Int? = nil,
		 weekdayOrdinal: Int? = nil,
		 quarter: Int? = nil,
		 weekOfMonth: Int? = nil,
		 weekOfYear: Int? = nil,
		 yearForWeekOfYear: Int? = nil) {
		let dateComponents = DateComponents(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond, weekday: weekday, weekdayOrdinal: weekdayOrdinal, quarter: quarter, weekOfMonth: weekOfMonth, weekOfYear: weekOfYear, yearForWeekOfYear: yearForWeekOfYear)

		if let date = dateComponents.date {
			self = date
		} else {
			return nil
		}
	}

	static var now: Date { Date() }
}

extension Int {
	enum TimeIntervalType: TimeInterval {
		case minute = 60
		case hour = 3600
		case day = 86400
		case week = 604800
	}

	var minutes: TimeInterval { Double(self) * TimeIntervalType.minute.rawValue }
	var hours: TimeInterval { Double(self) * TimeIntervalType.hour.rawValue }
	var days: TimeInterval { Double(self) * TimeIntervalType.day.rawValue }
	var weeks: TimeInterval { Double(self) * TimeIntervalType.week.rawValue }
}

extension TimeInterval {
	var ago: Date {
		Date() - self
	}

	var fromNow: Date {
		Date() + self
	}
}

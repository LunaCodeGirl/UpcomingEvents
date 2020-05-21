//
//  Event.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/20/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation

struct Event {
	let title: String
	let startDate: Date
	let endDate: Date
}

extension Event: Equatable {}

extension Event: Decodable {
	enum CodingKeys: String, CodingKey {
		case title
		case startDate = "start"
		case endDate = "end"
	}

	static func eventsFromJSON(_ json: Data) throws -> [Event] {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		let result = try decoder.decode([Event].self, from: json)
		return result
	}

	// MARK: - Private

	private static let dateFormatter: DateFormatter = {
		let formatter =  DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "MMMM d, YYYY h:mm a"
		return formatter
	}()
}

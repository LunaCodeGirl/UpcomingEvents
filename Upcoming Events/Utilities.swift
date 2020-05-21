//
//  Utilities.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/20/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation

struct FileUtilities {
	static func getStringFromFile(named fileName: String) throws -> String {
		let url = urlForFile(named: fileName)
		let result = try String(contentsOf: url!)
		return result
	}

	static func getStringFromFile(named fileName: String) -> String? {
		return convertToOptionalResult(try FileUtilities.getStringFromFile(named: fileName))
	}

	static func getDataFromFile(named fileName: String) throws -> Data {
		let url = urlForFile(named: fileName)
		let result = try Data(contentsOf: url!)
		return result
	}

	static func getDataFromFile(named fileName: String) -> Data? {
		return convertToOptionalResult(try FileUtilities.getDataFromFile(named: fileName))
	}

	// MARK: - Private Functions

	private static func urlForFile(named fileName: String) -> URL? {
		let bundle = Bundle.main
		return bundle.url(forResource: fileName, withExtension: "")
	}

	private static func convertToOptionalResult<T>(_ f: @autoclosure () throws -> T) -> T? {
		do {
			return try f()
		} catch {
			print(error)
			return nil
		}
	}
}

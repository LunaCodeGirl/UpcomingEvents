//
//  FunctionalUtilities.swift
//  Upcoming Events
//
//  Created by Luna Comerford on 5/22/20.
//  Copyright © 2020 Luna Comerford. All rights reserved.
//

import Foundation

public func curry<A,B,C,D>(_ curriedFunction: @escaping ((A, B, C)) -> D) -> (A) -> (B) -> (C) -> D {
	return { (f1: A) -> (B) -> (C) -> D in
		return { (f2: B) -> (C) -> D in
			return { (f3: C) -> D in
				return curriedFunction((f1, f2, f3))
			}
		}
	}
}

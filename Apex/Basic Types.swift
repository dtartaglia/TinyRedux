//
//  Basic Types.swift
//  Apex
//
//  Created by Daniel Tartaglia on 12/17/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License
//

public
enum Result<T> {
	case success(T)
	case failure(Error)

	public
	func map<U>(transform: (T) throws -> U) -> Result<U> {
		switch self {
		case .success(let t):
			do {
				return .success(try transform(t))
			}
			catch {
				return .failure(error)
			}
		case .failure(let error):
			return .failure(error)
		}
	}
}

public
struct UnknownError: Error { }

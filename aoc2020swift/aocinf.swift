//
//  aocinf.swift
//  aoc2020swift
//
//  Created by James Hannah on 05/01/2021.
//

import Foundation

protocol AOCRunnable {
    func RunPart1(input: Data, withOption opt: String?) throws -> String
    func RunPart2(input: Data, withOption opt: String?) throws -> String
    init()
}

enum AOCError: Error {
    case partNotImplemented
    case errorReadingInput
    case optionNotProvided
    case dayNotImplemented
}

extension AOCRunnable {
    func Run(part: Part, withInput data: Data, withOption opt: String? = nil) throws -> String {
        switch part {
        case Part.one:
            return try RunPart1(input: data, withOption: opt)
        case Part.two:
            return try RunPart2(input: data, withOption: opt)
        }
    }
    
//    func RunPart2(input: Data) throws -> String {
//        throw AOCError.PartNotImplemented
//    }
}

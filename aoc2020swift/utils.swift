//
//  utils.swift
//  aoc2020swift
//
//  Created by James Hannah on 05/01/2021.
//
import Foundation

func GetTrimmedLines(from input: Data) -> [String]? {
    let inStr  = String(data: input, encoding: .utf8)
    return inStr?.components(separatedBy: .newlines).map { x in
        return x.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

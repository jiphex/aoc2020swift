//
//  utils.swift
//  aoc2020swift
//
//  Created by James Hannah on 05/01/2021.
//
import Foundation


func getTrimmedLines(from input: Data) -> [String]? {
    let inStr = String(data: input, encoding: .utf8)
    return inStr?.components(separatedBy: .newlines).map { x in
        x.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


protocol InitableFromString {
    init(from: String)
}

func batchCreate<T: InitableFromString>(from batchInput: Data, encoding: String.Encoding = .utf8) throws -> [T] {
    if let stringData = String(data: batchInput, encoding: encoding) {
        return try batchCreate(from: stringData)
    }
    throw AOCError.problemReadingInput
}

func batchCreate<T: InitableFromString>(from batchInput: String) throws -> [T] {
    var objects: [T] = []
    var current = ""
    for l in batchInput.components(separatedBy: .newlines) {
        guard !l.isEmpty else {
            objects.append(T(from: current))
            current = ""
            continue
        }
        current.append(l+"\n")
    }
    // also grab the last one
    objects.append(T(from: current))
    return objects
}

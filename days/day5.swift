//
//  day5.swift
//  aoc2020swift
//
//  Created by James Hannah on 09/01/2021.
//

import Foundation

extension BinaryInteger {
    var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        var counter = 0
        
        for _ in 1...bitWidth {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
            counter += 1
//            if counter % 4 == 0 {
//                binaryString.insert(contentsOf: " ", at: binaryString.startIndex)
//            }
        }
        
        return binaryString
    }
}

struct Day5: AOCRunnable {
    func RunPart1(input: Data, withOption opt: String?) throws -> String {
        let passes = try getPasses(from: input)
        guard !passes.isEmpty else {
            throw AOCError.errorReadingInput
        }
        return "highest seat ID: \(passes.max {a,b in a.seatID < b.seatID }!)"
    }
    
    func RunPart2(input: Data, withOption opt: String?) throws -> String {
        let passes = try getPasses(from: input).sorted()
        guard !passes.isEmpty else {
            throw AOCError.errorReadingInput
        }
        var myseat: BoardingPass?
        var last: BoardingPass = passes.first!
        for p in passes {
            if p.seatID-last.seatID > 1 {
//                print(p,p.seatID-last.seatID)
                myseat=p
                break
            }
            last = p
        }
        return "empty seat ID: \(myseat!.seatID-1)"
    }
    
    func getPasses(from: Data) throws -> [BoardingPass] {
        if let sdata = String(data: from, encoding: .utf8) {
            return sdata.components(separatedBy: .newlines).map { BoardingPass($0) }.compactMap { $0 }
        }
        throw AOCError.errorReadingInput
    }
    
    struct BoardingPass: CustomStringConvertible,Comparable {
        static func < (lhs: Day5.BoardingPass, rhs: Day5.BoardingPass) -> Bool {
            lhs.seatID < rhs.seatID
        }
        
        private(set) var data: String
        
        var row: UInt8 {
            var row: UInt8 = 0
            for c in data[data.startIndex...data.index(data.startIndex, offsetBy: 6)].enumerated() {
                row = row | (c.element == "B" ? 1 << UInt8(6-c.offset) : 0 )
//                print("num \(row.binaryDescription) - element: \(c.element) offset: \(6 - c.offset)")
            }
            return row
        }
        
        var seat: UInt8 {
            var seat: UInt8 = 0
            for c in data[data.index(data.startIndex, offsetBy: 7)..<data.endIndex].enumerated() {
//                print("\(c.element) \(2-c.offset)")
                seat = seat | (c.element == "R" ? 1 << UInt8(2-c.offset) : 0)
            }
            return seat
        }
        
        var seatID: Int {
            Int(row)*8+Int(seat)
        }
        
        var description: String {
            return "\(seatID) - \(data): Row \(row) Seat \(seat)"
        }
        
        static var seatRegex: NSRegularExpression {
            do {
                return try NSRegularExpression(pattern: "^[FB]{7}[LR]{3}$", options: .init())
            } catch {
                fatalError()
            }
        }
        
        init?(_ from: String) {
            if BoardingPass.seatRegex.numberOfMatches(in: from, options: .init(), range: NSMakeRange(0, from.count)) != 1 {
                return nil
            }
            data = from
        }
    }
}

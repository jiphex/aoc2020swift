//
//  part1.swift
//  aoc2020swift
//
//  Created by James Hannah on 05/01/2021.
//

import Foundation

struct Day1: AOCRunnable {
    func RunPart1(input: Data, withOption: String?) -> String {
        if let instr = getTrimmedLines(from: input) {
            let innum = instr.map { istr -> Int  in
                if let n  = Int(istr) {
                    return n
                }
                return -999
            }.sorted()
            if let pair = part1FindPair(input: innum.reversed()) {
                print("pair is \(pair)")
                return String(pair.0*pair.1)
            }
        }
        return "search error"
    }
    
    func RunPart2(input: Data, withOption: String?) -> String {
        if let instr = getTrimmedLines(from: input) {
            let innum = instr.map { istr -> Int  in
                if let n  = Int(istr) {
                    return n
                }
                return -999
            }
            if let triple = part2FindTriple(input: innum.reversed()) {
                print("triple is \(triple)")
                return String(triple.0*triple.1*triple.2)
            }
        }
        return "search error"
    }
    
    typealias T20Pair = (Int,Int)
    
    typealias T20Triple = (Int,Int,Int)
    
    func part1FindPair(input: [Int]) -> T20Pair?{
        for i in input {
            for j in input {
                guard i != j else  { continue }
                if i+j == 2020 {
                    return (i,j)
                }
            }
        }
        return nil
    }
    
    func part2FindTriple(input: [Int]) -> T20Triple?{
        for x in input {
            for y in input {
                for z in input {
                    if x+y+z == 2020 {
                        return (x,y,z)
                    }
                }
            }
        }
        return nil
    }
}

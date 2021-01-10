//
//  day6.swift
//  aoc2020swift
//
//  Created by James Hannah on 11/01/2021.
//

import Foundation


protocol Countable {
    var count: Int { get }
}

struct Day6: AOCRunnable {
    func RunPart1(input: Data, withOption opt: String?) throws -> String {
        let allAnswers: [GroupAnswers] = try batchCreate(from: input)
        return "sum of group answers: \(sum(of: allAnswers))"
    }
    
    func RunPart2(input: Data, withOption opt: String?) throws -> String {
    
        let allAnswers: [GroupAnswersPart2] = try batchCreate(from: input)
        return "sum of group answers: \(sum(of: allAnswers))"
    }
    
    
    func sum<T: Countable>(of all: [T]) -> Int {
        return all.reduce(0) { acc, ga in
            return acc + ga.count
        }
    }
    
    struct GroupAnswers: InitableFromString,Countable {
        private(set) var yesAnswers: Set<Character>
        
        subscript(index: Character) -> Bool {
            return yesAnswers.contains(index)
        }
        
        var count: Int {
            return yesAnswers.count
        }
        
        init(from: String) {
            yesAnswers = Set<Character>()
            for line in from.components(separatedBy: .newlines) {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                yesAnswers.formUnion(trimmed)
            }
        }
    }
    
    
    struct GroupAnswersPart2: InitableFromString,Countable {
        private(set) var yesAnswers: Set<Character>
        
        subscript(index: Character) -> Bool {
            return yesAnswers.contains(index)
        }
        
        var count: Int {
//            print(yesAnswers)
            return yesAnswers.count
        }
        
        init(from: String) {
            var setupDone = false
            yesAnswers = Set<Character>()
            for line in from.components(separatedBy: .newlines).filter({!$0.isEmpty}) {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
//                print(trimmed)
                if yesAnswers.isEmpty && !setupDone {
                    yesAnswers = Set(trimmed)
                    setupDone = true
                    continue
                }
//                print("ints \(yesAnswers) with \(trimmed)")
                yesAnswers.formIntersection(trimmed)
            }
        }
    }
}

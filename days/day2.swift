//
//  day2.swift
//  aoc2020swift
//
//  Created by James Hannah on 05/01/2021.
//

import Foundation


struct Day2: AOCRunnable {
    
    func RunPart1(input: Data, withOption: String?) throws -> String {
        if let inl = GetTrimmedLines(from: input){
            let inpp = inl.map { l in
                PolicyAndPassword(from: l)
            }
            var validPasswords = 0
            for pp in inpp {
                if pp.IsValidPart1() {
                    validPasswords += 1
                }
            }
            return "part 1: found \(validPasswords) valid passwords"
        }
        throw AOCError.errorReadingInput
    }
    
    func RunPart2(input: Data, withOption: String?) throws -> String {
        if let inl = GetTrimmedLines(from: input){
            let inpp = inl.map { l in
                PolicyAndPassword(from: l)
            }
            var validPasswords = 0
            for pp in inpp {
                if pp.IsValidPart2() {
                    validPasswords += 1
                }
            }
            return "part 2: found \(validPasswords) valid passwords"
        }
        throw AOCError.errorReadingInput
    }
    
    struct PolicyAndPassword {
        var lowerPolicy,upperPolicy: Int
        var char: Character
        var password: String
        
        var policyAsRange: ClosedRange<Int> {
            return lowerPolicy...upperPolicy
        }
        
        var lowerIndex: String.Index {
            return password.index(password.startIndex, offsetBy: lowerPolicy)
        }
        var upperIndex: String.Index {
            return password.index(password.startIndex, offsetBy: upperPolicy)
        }
        
        init(from str: String) {
            let pwparts = str.split(separator: ":", maxSplits: 1)
            guard pwparts.count == 2 else {
                fatalError()
            }
            password = String(pwparts[1])
            let pcparts = pwparts[0].split(separator: " ", maxSplits: 1)
            char = Character(String(pcparts[1]))
            let polparts = pcparts[0].split(separator: "-", maxSplits: 1)
            lowerPolicy = Int(polparts[0])!
            upperPolicy = Int(polparts[1])!
        }
        
        func IsValidPart1() -> Bool {
            guard lowerPolicy != 0 && password.contains(char) else {
                return false
            }
            let numInstances = password.numberOfInstancesOf(character: char)
            return policyAsRange.contains(numInstances)
        }
        
        func IsValidPart2() -> Bool {
            let valid1 = password[lowerIndex] == char && password[upperIndex] != char
            let valid2 = password[lowerIndex] != char && password[upperIndex] == char
            var valid: Bool
            if valid1 {
                valid = !valid2
            } else {
                valid = valid2
            }
            print("checking whether password \(password) has \(char) at index \(lowerPolicy)(\(password[lowerIndex])) or at \(upperPolicy)(\(password[upperIndex])): \(valid)")
//            guard password.count >= upperPolicy else {
//                return false
//            }
            return valid
        }
    }
}

extension String {
    func numberOfInstancesOf(character: Character) -> Int {
        return self.filter { $0 == character }.count
    }

//    func substring(from: Int, to: Int) -> String {
//        let start = index(startIndex, offsetBy: from)
//        let end = index(start, offsetBy: to - from)
//        return String(self[start ..< end])
//    }
//
//    func substring(range: NSRange) -> String {
//        return substring(from: range.lowerBound, to: range.upperBound)
//    }
}

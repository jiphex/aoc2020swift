//
//  day7.swift
//  aoc2020swift
//
//  Created by James Hannah on 11/01/2021.
//

import Foundation


extension Day7.BagRuleset {
    func canContainBag(color: String) -> [Day7.BagRule] {
//        var lookupTable: [String:[Day7.ContainsRule]] = [:]
//        for rule in self {
//            lookupTable[rule.color] = rule.containsRules
//        }
        var canContain: [Day7.BagRule] = []
        for rule in self {
            if rule.canContainBagWith(color: color) {
                canContain.append(rule)
            }
        }
        for rule in canContain {
            canContain.append(contentsOf: canContainBag(color: rule.color))
        }
        return canContain
    }
}
struct Day7: AOCRunnable {
    func RunPart1(input: Data, withOption opt: String?) throws -> String {
        let rules: BagRuleset = createRules(from: input)
//        rules.forEach { r in
//            print("rule {\(r.color)} BAG can CONTAIN \(r.containsRules)")
//        }
        let canContain = rules.canContainBag(color: "shiny gold")
        let s = Set<String>.init(canContain.map{$0.color})
        return "can contain: \(s.count)"
    }
    
    func RunPart2(input: Data, withOption opt: String?) throws -> String {
        throw AOCError.partNotImplemented
    }
    
    func createRules(from: Data) -> [BagRule] {
        guard let strdata = String(data: from, encoding: .utf8) else {
            fatalError()
        }
        return strdata.components(separatedBy: .newlines).map { l in
            BagRule(from: l)
        }
    }
    
    typealias BagRuleset = [BagRule]
    
    struct ContainsRule: InitableFromString {
        var number: Int
        var color: String
        private var textSuffix: String {
            switch number {
            case 0:
                return "no other bags"
            case 1:
                return "bag"
            default:
                return "bags"
            }
        }
        var cannotContainOtherBags: Bool {
            return number == 0
        }
        var description: String {
            return "\(number) \(color) \(textSuffix)"
        }
        init(from: String) {
            if from == "no other bags" {
                number = 0
                color = ""
                return
            }
            let scan = Scanner(string: from)
            guard let n = scan.scanInt() else {
                fatalError()
            }
            number = n
            guard let scolor = scan.scanUpToString("bag") else {
                fatalError()
            }
            color = scolor.trimmingCharacters(in: .whitespaces)
        }
    }
    
    struct BagRule: InitableFromString {
        static var topSplitBy = "bags contain"
        
        private var ruleText: String
        
        typealias ParsedBagRule = (String,Array<ContainsRule>)
        
        var color: String {
            return ruleParts.0
        }
        
        var containsRules: [ContainsRule] {
            return ruleParts.1
        }
        
        func canContainBagWith(color: String) -> Bool {
            return containsRules.contains(where: {$0.color == color})
        }
        
        private var ruleParts: ParsedBagRule {
            let scan = Scanner(string: ruleText)
            let firstPart = scan.scanUpToString(BagRule.topSplitBy)?.trimmingCharacters(in: .whitespaces)
            guard let fp = firstPart else {
                return ParsedBagRule("",[])
            }
            _ = scan.scanString(BagRule.topSplitBy)
            var contains = Array<String>()
            while let x = scan.scanUpToCharacters(from: .punctuationCharacters) {
                contains.append(x)
                _ = scan.scanCharacters(from: .punctuationCharacters)
            }
//            print(scan.isAtEnd)
            return (fp,contains.map{ContainsRule(from: $0)})
        }
//
//        var bagColor: String {
//            parts
//        }
        
        init(from: String) {
//            print("FROM is {\(from)}")
            ruleText = from
        }
    }
}

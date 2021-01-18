//
//  main.swift
//  aoc2020swift
//
//  Created by James Hannah on 02/12/2020.
//

import ArgumentParser
import Foundation

struct DaySpec: Hashable,Decodable {
    var day: Int8 = 1
    var part: Part
}

enum Part: Int,ExpressibleByArgument,Decodable {
    case one = 1
    case two = 2
}

struct AOC: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "day")
    var day: Int = 1
    @Option(name: .shortAndLong, help: "part")
    var part: Part = Part.one
    @Option(name: .shortAndLong, help: "sample")
    var sample: Bool = true
    @Option(name: .shortAndLong, help: "puzzle option")
    var option: String?
    
    static func RegisterModule<T: AOCRunnable>(_ mod: T, forDay day: Int) {
        let imod = T.init()
        AOC.dayModules[day] = imod
    }
    
    static func RegisterModules<T: AOCRunnable>(_ mods: [T]) {
        for m in mods.enumerated() {
            AOC.RegisterModule(m.element, forDay: m.offset+1)
        }
    }
    
    private static var dayModules: [Int: AOCRunnable] = [:]
    
    func run(_ module: AOCRunnable, _ rpart: Part, withInput url: URL, withOption opt: String?) throws -> String {
        let data = try Data(contentsOf: url)
        return try module.Run(part: rpart, withInput: data, withOption: opt)
    }
    
    mutating func run() throws {
        if let mod = AOC.dayModules[day] {
            do {
                let inputFilename = URL(fileURLWithPath: "day\(day)-\(sample ? "sample" : "input").txt", relativeTo: URL(fileURLWithPath: "/Users/jameshannah/usrc/aoc2020swift/input"))
                let out = try run(mod, part, withInput: inputFilename, withOption: option)
                print("part \(part) \(sample ? "sample" : "puzzle") output\(option != nil ? " with option" : ""): \(out)")
            } catch {
                print("error: \(error)")
                throw ExitCode.failure
            }
        } else {
            print("error: no module registered for day \(day)")
            throw AOCError.dayNotImplemented
        }
    }
}

//let modules: [Int:AOCRunnable] = [Day1(),Day2()].enumerated().reduce(Dictionary<Int,AOCRunnable>()){x,y in x[y.offset]=y.element}
AOC.RegisterModule(Day1(), forDay: 1)
AOC.RegisterModule(Day2(), forDay: 2)
AOC.RegisterModule(Day3(), forDay: 3)
AOC.RegisterModule(Day4(), forDay: 4)
AOC.RegisterModule(Day5(), forDay: 5)
AOC.RegisterModule(Day6(), forDay: 6)
AOC.RegisterModule(Day7(), forDay: 7)
AOC.RegisterModule(Day8(), forDay: 8)
AOC.RegisterModule(Day8(), forDay: 9)
AOC.main()

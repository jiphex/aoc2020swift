//
//  day3.swift
//  aoc2020swift
//
//  Created by James Hannah on 05/01/2021.
//

import Foundation

struct Day3: AOCRunnable {
    func RunPart1(input: Data, withOption opt: String?) throws -> String {
        let map = TreeMap(from: input)
        let trees = try map.treeHitCount(withSlope: .sampleSlope)
        return ("got to the bottom and hit \(trees) trees on the way down")
    }
    
    func RunPart2(input: Data, withOption opt: String?) throws -> String {
        
        let map = TreeMap(from: input)
        let slopes = [
            TreeMap.Slope(sideways: 1),
            TreeMap.Slope(sideways: 3),
            TreeMap.Slope(sideways: 5),
            TreeMap.Slope(sideways: 7),
            TreeMap.Slope(sideways: 1, down: 2),
        ]
        var answer: Int?
        for slope in slopes {
            let x = try map.treeHitCount(withSlope: slope)
            print("step \(x)")
            if let a = answer {
                answer = a * x
            } else {
                answer = x
            }
        }
        return "answer is \(answer!)"
    }
    
    struct TreeMap {
        let mapString: String
        
        var height: Int {
            return mapString.components(separatedBy: .newlines).count-1
        }
        
        var width: Int {
            return .max
        }
        
        var inputWidth: Int {
            return mapString.components(separatedBy: .newlines).first!.count
        }
        
        var mapLines: [String] {
            return mapString.components(separatedBy: .newlines)
        }
        
        func mapCharAt(point: Point) -> Character {
            let line = mapLines[point.1]
            let index = line.index(line.startIndex, offsetBy: point.0 % inputWidth)
            return line[index]
        }
        
        enum SlopeDirection {
            case right
        }
        
        typealias Point = (Int,Int)
        
        
        struct Slope {
            var sideways,down: Int
            var direction: SlopeDirection = .right
            
            static let sampleSlope = Slope(sideways: 3, down: 1)
            
            func move(from point: Point) -> Point {
                var newPoint = point
                switch direction {
                case .right:
                    newPoint.0 += sideways
                }
                newPoint.1 += down
                return newPoint
            }
            
            init(sideways x: Int, down y: Int = 1) {
                sideways = x
                down = y
            }
            
            init?(fromString opt: String) {
                let drp = opt.split(separator: "-", maxSplits: 1)
                guard drp.count == 2 else {
                    return nil
                }
                sideways = Int(drp[0])!
                down = Int(drp[1])!
            }
        }
        
        
        enum StartLocation {
            case origin
            case from(x: Int, y: Int)
        }
        
        func treeHitCount(withSlope slope: Slope, startingAtIndex: StartLocation = .origin) throws -> Int {
            var pos: Point
            switch startingAtIndex {
            case .origin:
                pos = (0,0)
            default:
                throw AOCError.partNotImplemented
            }
            var treesHit = 0
            while true {
                let newPos = slope.move(from: pos)
//                print("moving from \(pos) to \(newPos) (mod: \(newPos.0 % inputWidth))")
                if mapCharAt(point: newPos) == "#" {
                    treesHit += 1
                }
                if newPos.1 == height {
                    break
                } else {
                    pos = newPos
                }
            }
            return treesHit
        }
        
        init(from data: Data) {
            guard let stringData = String(data: data, encoding: .utf8) else {
                fatalError()
            }
            mapString = stringData
        }
    }
}

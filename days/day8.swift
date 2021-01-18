//
//  day8.swift
//  aoc2020swift
//
//  Created by James Hannah on 15/01/2021.
//

import Foundation

struct Day8: AOCRunnable {
    func RunPart1(input: Data, withOption opt: String?) throws -> String {
        guard let sdata = String(data: input, encoding: .utf8) else {
            throw AOCError.problemReadingInput
        }
        let prog = try Program(from: sdata)
        var console = Console(prog)
        do {
            try console.boot()
        } catch let ConsoleError.secondExecution(pc: ins, accValue: acc) {
            return ("second exec ins \(ins) acc= \(acc)")
        } catch ConsoleError.tooManyInstructions {
            return ("womp - too much loops")
        }
        throw AOCError.partNotImplemented
    }
    
    func RunPart2(input: Data, withOption opt: String?) throws -> String {
        guard let sdata = String(data: input, encoding: .utf8) else {
            throw AOCError.problemReadingInput
        }
        let prog = try Program(from: sdata)
        for line in prog.instructions.enumerated() {
            var p2 = prog
            p2.instructions[line.offset]=line.element.alternate()
            var console = Console(p2)
            do {
                try console.boot(detectingFaultyInstructions: true)
            } catch let ConsoleError.secondExecution(pc: ins, accValue: acc) {
//                return ("second exec ins \(ins) acc=\(acc)")
                continue
            } catch let ConsoleError.faultDetected(at: fline, acc: facc) {
                return ("fault at \(line) - \(fline) - acc = \(facc)")
            } catch ConsoleError.tooManyInstructions {
                return ("womp")
            }
            throw AOCError.partNotImplemented
        }
        throw AOCError.problemReadingInput
    }
    
    enum Opcode: String {
        case nop
        case acc
        case jmp
    }
    
    struct Instruction: Hashable {
        var operation: Opcode
        var argument: Int
        
        init(_ text: String) throws {
            let p = text.components(separatedBy: .whitespaces)
            guard p.count == 2 else {
                throw AOCError.problemReadingInput
            }
            guard let opcode = Opcode(rawValue: p[0]) else {
                throw AOCError.problemReadingInput
            }
            operation = opcode
            guard let arg = Int(p[1]) else {
                throw AOCError.problemReadingInput
            }
            argument = arg
        }
        
        func alternate() -> Instruction {
            var n = self
            switch operation {
            case .acc:
                // These go through unmodified
                return self
            case .jmp:
                n.operation = .nop
            case .nop:
                n.operation = .jmp
            }
            return n
        }
        
        func modify(pc: Int) -> Int {
            switch operation {
            case .jmp:
                return pc+argument
            default:
                return pc+1
            }
        }
    }
    
    struct Program: Hashable {
        var instructions: [Instruction]
        
        subscript(idx: Int) -> Instruction{
            return instructions[idx]
        }
        
        init(from code: String) throws {
            instructions = try code.components(separatedBy: .newlines).map { line in
                try Instruction(line)
            }
        }
    }
    
    enum ConsoleError: Error {
        case secondExecution(pc: Int, accValue: Int)
        case tooManyInstructions
        case faultDetected(at: Int, acc: Int)
    }
    
    struct Console {
        let bootloader: Program
        private var visited: [Int] = []
        // accumulator is the register
        private var accumulator = 0
        // pc is the program counter which tracks what instruction we're on
        private var pc = 0
        private var instructionCount = 0
        private static var maxInstructions = 1_000_000
        
        private var exitTarget: Int {
            bootloader.instructions.count
        }
        
        init(_ p: Program) {
            bootloader = p
        }
        
        mutating func boot(detectingFaultyInstructions det: Bool = false) throws {
            if det {
                print("DETECTION MODE ON- LOOKING FOR INSTRUCTION: \(exitTarget)")
            }
            while instructionCount < Console.maxInstructions {
                let currentInstruction = bootloader.instructions[pc]
                guard !visited.contains(pc) else {
                    throw ConsoleError.secondExecution(pc: pc, accValue: accumulator)
                }
                let newpc = currentInstruction.modify(pc: pc)
                visited.append(pc)
                if currentInstruction.operation == .acc {
                    accumulator += currentInstruction.argument
                }
                print("\(instructionCount)@\(pc)->\(newpc) - exec \(currentInstruction.operation): \(currentInstruction.argument) a=\(accumulator)")
                
                if det {
                    let altpc = currentInstruction.alternate().modify(pc: pc)
                    print("\(instructionCount)@possibly could jump to \(altpc) / \(exitTarget)")
                    if altpc == exitTarget {
                        throw ConsoleError.faultDetected(at: pc, acc: accumulator)
                    }
                }
                instructionCount += 1
                pc = newpc
            }
            throw ConsoleError.tooManyInstructions
        }
    }
}

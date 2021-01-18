//
//  day4.swift
//  aoc2020swift
//
//  Created by James Hannah on 06/01/2021.
//

import Foundation

struct Day4: AOCRunnable {
    func RunPart1(input: Data, withOption opt: String?) throws -> String {
        guard let strinput = String(data: input, encoding: .utf8) else {
            throw AOCError.problemReadingInput
        }
        let passports = try batchImportPassports(from: strinput)
        let validCount = passports.filter { $0.hasAllMandatoryFields }.count
        return "valid passports found: \(validCount)"
    }
    
    func RunPart2(input: Data, withOption opt: String?) throws -> String {
        guard let strinput = String(data: input, encoding: .utf8) else {
            throw AOCError.problemReadingInput
        }
        let passports = try batchImportPassports(from: strinput)
        let validCount = passports.filter { $0.isFullyValid }.count
        return "valid part2 passports found: \(validCount) out of \(passports.count)"
    }
    
    func batchImportPassports(from batchInput: String) throws -> [Passport] {
        var passports: [Passport] = []
        var currentPassport = Passport()
        for l in batchInput.components(separatedBy: .newlines) {
            guard !l.isEmpty else {
                passports.append(currentPassport)
                currentPassport = Passport()
                continue
            }
            currentPassport.parsePassportFields(l)
        }
        // also grab the last one
        passports.append(currentPassport)
        return passports
    }
    
    struct Passport {
        static let fieldSplitChar: Character = ":"
        
        typealias PassportFields = [FieldType:String]

        enum FieldClassification {
            case optional
            case mandatory
        }
        
        static var fieldTypeClassification: [FieldType: FieldClassification] = [
            .birthYear: .mandatory,
            .issueYear: .mandatory,
            .expirationYear: .mandatory,
            .height: .mandatory,
            .hairColor: .mandatory,
            .eyeColor: .mandatory,
            .passportID: .mandatory,
            .countryID: .optional,
        ]
        
        static var partTwoClassification: [FieldType: (String) -> FieldProblem?] = [
            .birthYear: numberRange(min: 1920, max: 2002),
            .issueYear: numberRange(min: 2010, max: 2020),
            .expirationYear: numberRange(min: 2020, max: 2030),
            .height: heightValidator(),
            .hairColor: regexValidator(pattern: "^#[0-9a-f]{6}$"),
            .eyeColor: regexValidator(pattern: "^(amb|blu|brn|gry|grn|hzl|oth)$"),
            .passportID: regexValidator(pattern: "^0*[0-9]{9}$")
        ]
        
        static func regexValidator(pattern: String, options: NSRegularExpression.Options = .init()) -> (String) -> FieldProblem? {
            do {
                let re = try NSRegularExpression(pattern: pattern, options: options)
                return {
                    (test: String) -> FieldProblem? in
                    if re.numberOfMatches(in: test, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, test.count)) == 0 {
                        return .failsValidation
                    }
                    return nil
                }
            } catch {
                fatalError()
            }
        }
        
        static func heightValidator() -> (String) -> FieldProblem? {
            return { (input: String) -> FieldProblem? in
                guard regexValidator(pattern: "^[0-9]+(cm|in)$")(input) == nil else {
                    return .failsValidation
                }
                if input.hasSuffix("cm") {
                    let numpart = input[input.startIndex...input.index(before: input.firstIndex(of: "c")!)]
                    let num = Int(numpart)!
                    return num >= 150 && num <= 193 ? nil : .failsValidation
                } else if input.hasSuffix("in") {
                    let numpart = input[input.startIndex...input.index(before: input.firstIndex(of: "i")!)]
                    let num = Int(numpart)!
                    return num >= 59 && num <= 76 ? nil : .failsValidation
                } else {
                    return .failsValidation
                }
            }
        }
        
        static func numberRange(min: Int?, max: Int?) -> (String) -> FieldProblem? {
            return {
                (input: String) -> FieldProblem? in
                guard regexValidator(pattern: "^[0-9]+$")(input) == nil else {
                    return .failsValidation
                }
                guard let inyear = Int(input) else {
                    return .unrecognisableData
                }
                if (min != nil &&  inyear >= min!) && (max != nil && inyear <= max!) {
                    return nil
                } else {
                    return .failsValidation
                }
            }
        }
        
        enum FieldType: String {
            case birthYear = "byr"
            case issueYear = "iyr"
            case expirationYear = "eyr"
            case height = "hgt"
            case hairColor = "hcl"
            case eyeColor = "ecl"
            case passportID = "pid"
            case countryID = "cid"
            case unknownField = "unk"
        }
        
        enum FieldProblem: Error {
            case noFields
            case missingMandatoryField
            case unrecognisableData
            case failsValidation
        }
        
        
        
        private(set) var fieldStore: PassportFields
        
        var hasAllMandatoryFields: Bool {
            // Either there's no problems, or the only ones that exist are missingMandatoryFields
            return problems.isEmpty || problems.filter { _,e in e == .missingMandatoryField || e == .noFields}.isEmpty
        }
        
        func get(_ field: FieldType) -> String? {
            return fieldStore[field]
        }
        
        var isFullyValid: Bool {
//            print("\(get(.passportID)) \(problems)")
            return problems.isEmpty
        }
        
        var problems: [FieldType:FieldProblem] {
            if fieldStore.isEmpty {
                return [.unknownField:.noFields]
            }
            var errors: [FieldType:FieldProblem] = [:]
            for f in Passport.fieldTypeClassification {
                if f.value == .mandatory {
                    if fieldStore[f.key] == nil {
                        errors[f.key]=FieldProblem.missingMandatoryField
                    }
                }
            }
            for f in Passport.partTwoClassification {
                if let fv = fieldStore[f.key] {
                    if let prob = f.value(fv) {
                        errors[f.key] = prob
                    }
                }
            }
            return errors
        }
        
        var problemText: String {
            guard !problems.isEmpty else {
                return ""
            }
            var str = "PASSPORT PROBLEMS:"
            for p in problems {
                str += "  \(p.key.rawValue): \(p.value.localizedDescription)"
            }
            return str
        }
        
        init() {
            fieldStore = [FieldType: String]()
        }
        
        mutating func parsePassportFields(_ txt: String) {
            for field in txt.components(separatedBy: .whitespacesAndNewlines) {
                let fldsp = field.split(separator: Passport.fieldSplitChar, maxSplits: 1)
                guard let ft = FieldType(rawValue: String(fldsp[0])) else {
                    fatalError()
                }
                let fc = fldsp[1]
                fieldStore[ft] = String(fc)
            }
        }
        
        init(fromTextRepresentation txt: String) {
            fieldStore = [FieldType: String]()
            parsePassportFields(txt)
        }
    }
}

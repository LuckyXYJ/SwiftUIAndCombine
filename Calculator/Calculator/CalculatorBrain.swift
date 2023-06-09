//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by dingtone on 2023/5/23.
//

import Foundation

enum CalculatorBrain {
    case left(String)
    case leftOp(
          left: String,
          op: CalculatorButtonItem.Op
    )
    case leftOpRight(
        left: String,
        op: CalculatorButtonItem.Op,
        right: String
    )
    case error
}

extension CalculatorBrain {
    
    var output: String {
        
        let formatter: NumberFormatter = {
            let f = NumberFormatter()
            f.minimumFractionDigits = 0
            f.maximumFractionDigits = 8
            f.numberStyle = .decimal
            return f
        }()
        
        let result: String
        switch self {
            case .left(let left):
                result = left
        case .leftOp(let left, _):
            result = left
        case .leftOpRight(_, _, let right):
            result = right
        case .error:
            result = "EOF"
        }
        guard let value = Double(result) else {
            return "Error"
        }
        return formatter.string(from: value as NSNumber)!
    }

    func apply(num: Int) -> CalculatorBrain {
        switch self {
        case .left(let str):
            return .left("\(str)\(num)")
        case .leftOp(let str, let op):
            return .leftOpRight(left: str, op: op, right: "\(num)")
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: "\(right)\(num)")
        case .error:
            return .error
        }
    }
    
    func applyDot() -> CalculatorBrain {
        switch self {
        case .left(let str):
            return .left("\(str).")
        case .leftOp(let str, let op):
            return .leftOpRight(left: str, op: op, right: "0.")
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: "\(right).")
        case .error:
            return .error
        }
    }
    
    func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        case .left(let str):
            return .left("\(str)\(op)")
        case .leftOp(let str, let op):
            return .leftOpRight(left: str, op: op, right: "\(op)")
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: "\(right)\(op)")
        case .error:
            return .error
        }
    }
    
    func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain {
        switch self {
        case .left(let str):
            return .left("\(str)\(command)")
        case .leftOp(let str, let op):
            return .leftOpRight(left: str, op: op, right: "\(command)")
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: "\(right)\(command)")
        case .error:
            return .error
        }
    }
    
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
        
        switch item {
        case .digit(let num):
            return apply(num: num)
        case .dot:
            return applyDot()
        case .op(let op):
            return apply(op: op)
        case .command(let command):
            return apply(command: command)
        }
    }
    
   
    
}

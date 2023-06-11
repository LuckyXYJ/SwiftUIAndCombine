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
            return .leftOp(left: str, op: op)
        case .leftOp(let str, let op):
            return .leftOp(left: str, op: op)
        case .leftOpRight(let left, let oop, let right):
            if oop == .divide && NSDecimalNumber(string: right) == NSDecimalNumber.zero {
                return .error
            }
            let value = compute(left: left, op: oop, right: right)
            return .leftOp(left: value, op: op)
        case .error:
            return .error
        }
    }
    
    func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain {
        
        if command == .clear {
            return .left("0")
        }
        
        switch self {
        case .left(let left):
            return .left(commandNumber(original: left, command: command))
        case .leftOp(let left, let op):
            return .leftOp(left: commandNumber(original: left, command: command), op: op)
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: commandNumber(original: right, command: command))
        case .error:
            return self
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
    
   
    func commandNumber(original: String, command: CalculatorButtonItem.Command) -> String {
        
        let l = NSDecimalNumber(string: original)
        var res: NSDecimalNumber
        switch command {
        case .flip:
            res = NSDecimalNumber.zero - l
        case .percent:
            res = l / 100
        default:
            res = l
        }
        return res.toString()
    }
    
    func compute(left: String, op: CalculatorButtonItem.Op, right: String) -> String {
        
        let l = NSDecimalNumber(string: left)
        let r = NSDecimalNumber(string: right)
        var res: NSDecimalNumber!
        
        switch op {
        case .plus:
            res = l + r
        case .minus:
            res = l - r
        case .multiply:
            res = l * r
        case .divide:
            res = l / r
        case .equal:
            res = r
        }
        
//        formatter.string(from: value as NSNumber)!
        return res.toString()
    }
    
}

public extension NSDecimalNumber {
    static func + (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.adding(rhs)
    }
    
    static func - (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.subtracting(rhs)
    }
    
    static func * (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.multiplying(by: rhs)
    }
    
    static func / (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.dividing(by: rhs)
    }
    
    /// 转String 四舍五入
    /// - Parameter scale: 保留几位小数
    /// - Parameter roundingMode:
    ///     plain: 保留位数的下一位四舍五入
    ///     down: 保留位数的下一位直接舍去
    ///     up: 保留位数的下一位直接进一位
    ///     bankers: 当保留位数的下一位不是5时，四舍五入，当保留位数的下一位是5时，其前一位是偶数直接舍去，是奇数直接进位（如果5后面还有数字则直接进位）
    func toString(_ scale: Int = 2, roundingMode: RoundingMode = .plain) -> String {
        let behavior = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: Int16(scale),
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: true
        )
        
        let product = multiplying(by: .one, withBehavior: behavior)
        
        return product.stringValue
    }

}

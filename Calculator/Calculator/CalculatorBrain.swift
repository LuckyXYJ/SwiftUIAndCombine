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
        
        var formatter: NumberFormatter = {
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

    
}

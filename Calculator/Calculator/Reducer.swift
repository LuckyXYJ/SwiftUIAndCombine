//
//  Reducer.swift
//  Calculator
//
//  Created by LuckyXYJ on 2023/6/10.
//

import Foundation

typealias CalculatorState = CalculatorBrain
typealias CalculatorStateAction = CalculatorButtonItem

struct Reducer {
    static func reduce(
        state: CalculatorState,
        action: CalculatorStateAction
    ) -> CalculatorState
    {
        return state.apply(item: action)
        
    }
}

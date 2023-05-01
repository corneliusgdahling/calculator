//
//  ContentView.swift
//  Calculator (iPhone copy)
//
//  Created by Cornelius Grieg Dahling on 01/05/2023.
//

import UIKit

enum CalculatorButton: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "÷"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    // Color
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, equal, decimal, none
}


import SwiftUI

struct ContentView: View {
    @State var value = "0"
    @State var storedValue = 0.0
    @State var currentOperation: Operation = .none
    @State var lastButtonPressedIsDigit: Bool = false
    
    let buttons: [[CalculatorButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    func valueToDisplay(_ value: String) -> String {
        guard let valueDouble = Double(value) else {
            return "Error"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = valueDouble.truncatingRemainder(dividingBy: 1) == 0 ? 0 : .max
        formatter.groupingSize = 3
        formatter.groupingSeparator = " "
            
        
        return formatter.string(from: NSNumber(value: valueDouble))!
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(valueToDisplay(self.value))
                        .bold()
                        .font(.system(size: 150))
                        .foregroundColor(.white)
                }
                .padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 20) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.pressedButton(button: button)
                            }, label: {
                                Text(button.rawValue)
                                    .font(.system(size: 64))
                                    .frame(width: self.buttonWidth(button: button) / 1.35,
                                           height: self.buttonHeight() / 1.35
                                    )
                                    .background(button.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(button: button) / 2)
                            })
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    func add (_ storedValue: Double, _ value: String) -> Double { storedValue + Double(value)! }
    
    func subtract (_ storedValue: Double, _ value: String) -> Double { storedValue - Double(value)! }
    
    func multiply (_ storedValue: Double, _ value: String) -> Double { storedValue * Double(value)! }
    
    func divide (_ storedValue: Double, _ value: String) -> Double { storedValue / Double(value)! }
    
    func executeOperation(operation: Operation) -> Void {
        var newValue = 0.0
        
        switch operation {
        case .add:
            newValue = add(self.storedValue, self.value)
        case .subtract:
            newValue = subtract(self.storedValue, self.value)
        case .multiply:
            newValue = multiply(self.storedValue, self.value)
        case .divide:
            newValue = divide(self.storedValue, self.value)
        case .equal:
            executeOperation(operation: self.currentOperation)
            self.currentOperation = .none
            return
        case .none, .decimal:
            return
        }
        
        self.value = "\(newValue)"
        self.storedValue = newValue
    }
    
    func pressedButton(button: CalculatorButton) {
        switch button {
        case .add:
            self.currentOperation = .add
            self.storedValue = Double(self.value) ?? 0
        case .subtract:
            self.currentOperation = .subtract
            self.storedValue = Double(self.value) ?? 0
        case .multiply:
            self.currentOperation = .multiply
            self.storedValue = Double(self.value) ?? 0
        case .divide:
            self.currentOperation = .divide
            self.storedValue = Double(self.value) ?? 0
        case .equal:
            let stored = self.storedValue
            let current = Double(self.value) ?? 0
            switch self.currentOperation {
            case .add: self.value = "\(stored + current)"
            case .subtract: self.value = "\(stored - current)"
            case .multiply: self.value = "\(stored * current)"
            case .divide: self.value = current == 0 ? "Error" : "\(stored / current)"
            case .none, .equal, .decimal: //Fix equal
                break
            }
        case .clear:
            self.value = "0"
            self.storedValue = 0.0
            self.currentOperation = .none
            lastButtonPressedIsDigit = false
        case .decimal:
            self.currentOperation = .decimal
        case .negative, .percent:
            break
        default:
            if (self.currentOperation == .decimal) {
                self.value = "\(self.value).\(button.rawValue)"
                self.currentOperation = .none
            }
            else if (self.lastButtonPressedIsDigit) {
                self.value = "\(self.value)\(button.rawValue)"
            } else {
                self.value = button.rawValue
            }
            self.lastButtonPressedIsDigit = true
            return
        }
        self.lastButtonPressedIsDigit = false
    }
    
    func buttonWidth(button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return ((UIScreen.main.bounds.width - (4 * 12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12 )) / 4
    }
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

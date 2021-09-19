//
//  ContentView.swift
//  Calnewlator
//
//  Created by Aaryaman Saini on 17/09/21.
//

import SwiftUI

//MARK: - Buttons Design

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "✕"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "±"
    
    var ButtonColor: Color{
        switch self{
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1))
        }
    }
    
    var ButtonForColor: Color{
        switch self{
        case .clear, .negative, .percent:
            return .black
        default:
            return .white
        }
    }
}

//MARK: - Operations

enum Operation {
    case add, subtract, multiply, divide, none
}

//MARK: - Content View

struct ContentView: View {
    
    @State var value = "0"
    @State var runningNumber = 0
    @State var newNumber = 0
    @State var currentOperation: Operation = .none
    @State var firstDigitAfterOperation: Bool = false
    @State var answerAfterEqual: Bool = false
    @State var oneOperationPresent: Bool = false
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                // Text Dispaly
                HStack{
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }
                .padding()
                
                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12){
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTapButton(button: item)
                            }, label: {
                                
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item), height: self.buttonHeight()
                                    )
                                    .background(item.ButtonColor)
                                    .foregroundColor(item.ButtonForColor)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                                
                            })
                        }
                        
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func didTapButton(button: CalcButton){
        
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            
            //MARK: - Add Button
            if button == .add{
                if self.oneOperationPresent {
                    let newValue = Int(self.value) ?? 0
                    let oldValue = self.runningNumber
                    var ans = 0
                    if self.currentOperation == .add{
                        ans = newValue + oldValue
                    }
                    if self.currentOperation == .subtract{
                        ans = oldValue - newValue
                    }
                    if self.currentOperation == .multiply{
                        ans = oldValue * newValue
                    }
                    if self.currentOperation == .divide{
                        ans = oldValue / newValue
                    }
                    self.value = "\(ans)"
                    self.runningNumber = ans
                    self.currentOperation = .add
                    self.firstDigitAfterOperation = true
                    self.oneOperationPresent = false
                    break
                }else{
                    self.currentOperation = .add
                    if self.answerAfterEqual{
                        self.runningNumber = Int(self.value) ?? 0
                        self.answerAfterEqual = false
                    }else{
                        self.runningNumber = self.newNumber
                    }
                    self.firstDigitAfterOperation = true
                    self.oneOperationPresent = true
                }
            }
            
            //MARK: - Subtract Button
            else if button == .subtract{
                if self.oneOperationPresent {
                    let newValue = Int(self.value) ?? 0
                    let oldValue = self.runningNumber
                    var ans = 0
                    if self.currentOperation == .add{
                        ans = newValue + oldValue
                    }
                    if self.currentOperation == .subtract{
                        ans = oldValue - newValue
                    }
                    if self.currentOperation == .multiply{
                        ans = oldValue * newValue
                    }
                    if self.currentOperation == .divide{
                        ans = oldValue / newValue
                    }
                    self.value = "\(ans)"
                    self.runningNumber = ans
                    self.currentOperation = .subtract
                    self.firstDigitAfterOperation = true
                    self.oneOperationPresent = false
                    break
                }else{
                    self.currentOperation = .subtract
                    if self.answerAfterEqual{
                        self.runningNumber = Int(self.value) ?? 0
                        self.answerAfterEqual = false
                    }else{
                        self.runningNumber = self.newNumber
                    }
                    self.firstDigitAfterOperation = true
                    self.oneOperationPresent = true
                }
                
            }
            
            //MARK: - Multiply Button
            else if button == .multiply{
                if self.oneOperationPresent {
                    let newValue = Int(self.value) ?? 0
                    let oldValue = self.runningNumber
                    var ans = 0
                    if self.currentOperation == .add{
                        ans = newValue + oldValue
                    }
                    if self.currentOperation == .subtract{
                        ans = oldValue - newValue
                    }
                    if self.currentOperation == .multiply{
                        ans = oldValue * newValue
                    }
                    if self.currentOperation == .divide{
                        ans = oldValue / newValue
                    }
                    self.value = "\(ans)"
                    self.runningNumber = ans
                    self.currentOperation = .multiply
                    self.firstDigitAfterOperation = true
                    self.oneOperationPresent = false
                    break
                }else{
                    self.currentOperation = .multiply
                    if self.answerAfterEqual{
                        self.runningNumber = Int(self.value) ?? 0
                        self.answerAfterEqual = false
                    }else{
                        self.runningNumber = self.newNumber
                    }
                    self.firstDigitAfterOperation = true
                    self.oneOperationPresent = true
                }
            }
            
            //MARK: - Divide Button
            else if button == .divide{
                if self.oneOperationPresent {
                    let newValue = Int(self.value) ?? 0
                    let oldValue = self.runningNumber
                    var ans = 0
                    if self.currentOperation == .add{
                        ans = newValue + oldValue
                    }
                    if self.currentOperation == .subtract{
                        ans = oldValue - newValue
                    }
                    if self.currentOperation == .multiply{
                        ans = oldValue * newValue
                    }
                    if self.currentOperation == .divide{
                        ans = oldValue / newValue
                    }
                    self.value = "\(ans)"
                    self.runningNumber = ans
                    self.currentOperation = .divide
                    self.firstDigitAfterOperation = true
                    self.oneOperationPresent = false
                    break
                }else{
                    self.currentOperation = .divide
                    if self.answerAfterEqual{
                        self.runningNumber = Int(self.value) ?? 0
                        self.answerAfterEqual = false
                    }else{
                        self.runningNumber = self.newNumber
                    }
                    self.firstDigitAfterOperation = true
                    self.oneOperationPresent = true
                }
                
            }
            
            //MARK: - Equal Button
            else if button == .equal{
                
                self.answerAfterEqual = true
                let currentValue = self.newNumber
                let runningValue = self.runningNumber
                switch self.currentOperation {
                case .add:
                    let resultValue = runningValue + currentValue
                    self.value = "\(resultValue)"
                    self.runningNumber = resultValue
                    self.currentOperation = .none
                    self.oneOperationPresent = false
                case .subtract:
                    let resultValue = runningValue - currentValue
                    self.value = "\(resultValue)"
                    self.runningNumber = resultValue
                    self.currentOperation = .none
                    self.oneOperationPresent = false
                case .divide:
                    if currentValue == 0{
                        self.value = "Error"
                        break
                    }
                    let resultValue = runningValue / currentValue
                    self.value = "\(resultValue)"
                    self.runningNumber = resultValue
                    self.currentOperation = .none
                    self.oneOperationPresent = false
                case .multiply:
                    let resultValue = runningValue * currentValue
                    self.value = "\(resultValue)"
                    self.runningNumber = resultValue
                    self.currentOperation = .none
                    self.oneOperationPresent = false
                case .none:
                    break
                }
            }
        
        //MARK: - All Clear Button
        case .clear:
            self.value = "0"
            self.currentOperation = .none
            self.runningNumber = 0
            self.newNumber = 0
            self.firstDigitAfterOperation = false
            self.answerAfterEqual = false
            self.oneOperationPresent = false
        
        //MARK: - Negative Button
        case .negative:
            let numberPresent = Int(self.value) ?? 0
            let numberToShow = -1 * numberPresent
            self.value = "\(numberToShow)"
            self.newNumber = Int(self.value) ?? 0
            
        case .decimal, .percent:
            break
            
        //MARK: - Numbers Button
        default:
            let number = button.rawValue
            
            if self.currentOperation == .none{
                
                if answerAfterEqual{
                    self.runningNumber = 0
                    self.value = ""
                }
                
                if self.value == "0"{
                    self.value = number
                }else{
                    self.value = "\(self.value)\(number)"
                }
                self.newNumber = Int(self.value) ?? 0
                
            } else {
                
                if self.firstDigitAfterOperation{
                    self.value = number
                    self.firstDigitAfterOperation = false
                }else{
                    self.value = "\(self.value)\(number)"
                }
                self.newNumber = Int(self.value) ?? 0
                self.oneOperationPresent = true
                
            }
        
        }
    }
    
    //MARK: - Button Width And Height
    func buttonWidth(item: CalcButton) -> CGFloat{
        if item == .zero{
            return ((UIScreen.main.bounds.width - (4*12))/4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat{
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

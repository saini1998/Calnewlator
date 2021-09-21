//
//  ContentView.swift
//  Calnewlator
//
//  Created by Aaryaman Saini on 17/09/21.
//

import SwiftUI
import AVKit

//MARK: - Buttons Design

class SoundManager {
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(){
        guard let url = Bundle.main.url(forResource: "nsound", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch _{
            
        }
    }
}

class HapticManager{
    static let instance = HapticManager() // Singleton
    func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle){
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

extension Color{
    static let offWhite = Color(red: 225/255, green: 225/255, blue: 235/255)
}

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
    case answer = "ANS"
    case negative = "±"
    
    var ButtonColor: Color{
        switch self{
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .answer, .negative:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1))
        }
    }
    
    var ButtonForColor: Color{
        switch self{
        case .clear, .answer:
            return .red
        case .negative:
            return .blue
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        default:
            return .black
        }
    }
    
    var ButtonFontSize: CGFloat{
        switch self{
        case .clear, .answer:
            return 29
        case .multiply:
            return 33
        case .negative, .divide, .subtract, .add, .equal:
            return 50
        default:
            return 33
        }
    }
}

//MARK: - Operations

enum Operation {
    case add, subtract, multiply, divide, none
}

extension LinearGradient {
    init(_ colors: Color...){
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Circle())
            .background(
                Group{
                    if configuration.isPressed{
                        Circle()
                            .fill(Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray , lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(
                                        Circle()
                                            .fill(LinearGradient(Color.black, Color.clear))
                                    )
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(
                                        Circle()
                                            .fill(LinearGradient(Color.clear, Color.black))
                                    )
                            )
                    }else{
                    Circle()
    //                    .padding(30)
                        .fill(Color.offWhite)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
                
            )
            .animation(nil)
    }
}

//MARK: - Content View

struct ContentView: View {
    
    @State var value = "0"
    @State var runningNumber: Float = 0
    @State var newNumber: Float = 0
    @State var ansNumber: Float = 0
    @State var currentOperation: Operation = .none
    @State var firstDigitAfterOperation: Bool = false
    @State var answerAfterEqual: Bool = false
    @State var oneOperationPresent: Bool = false
    @State var operationInUse: Bool = false
    @State var decimalPointPresent: Bool = false
    
    let buttons: [[CalcButton]] = [
        [.clear, .answer, .negative, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack{
            Color.offWhite.edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                // Text Dispaly
                HStack{
//                    Spacer()
                    Text(value)
                        .bold()
//                        .multilineTextAlignment(.leading)
                        .padding()
                        .font(.system(size: 80))
                        .frame(alignment: .leading)
                        .foregroundColor(Color(.systemGray))
                        .background(
                            Rectangle()
                                .fill(Color.offWhite)
                                .frame(width: (UIScreen.main.bounds.width - 5*12) / 1)
                                .frame(minHeight: 0, maxHeight: .infinity)
                                .cornerRadius(25)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        )
                        
                        
                }
                .padding()
                Spacer()
                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 14){
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                HapticManager.instance.impact(style: .rigid)
                                SoundManager.instance.playSound()
//                                HapticManager.instance.notification(type: .warning)
//                                HapticManager.instance.notification(type: .error)
                                self.didTapButton(button: item)
                            }, label: {
                                
                                Text(item.rawValue)
                                    .font(.system(size: item.ButtonFontSize))
                                    .frame(
//                                        width: self.buttonWidth(item: item), height: self.buttonHeight()
                                        width: 80, height: 80
                                    )
                                    //
//                                    .background(Color.offWhite)
                                    //
                                    .foregroundColor(item.ButtonForColor)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                                
                            }
                            )
                            .buttonStyle(SimpleButtonStyle())
                        }
                        
                    }
                    .padding(.bottom, 5)
                    
//                    .hapticFeedbackOnTap(style: .rigid)
//                    .padding(.leading, 3)
//                    .padding(.trailing, 2)
                }
            }
            .padding(.bottom, 10)
            
        }
    }
    
    func textSize(textStyle: UIFont.TextStyle) -> CGFloat {
       return UIFont.preferredFont(forTextStyle: textStyle).pointSize
    }
    
    func didTapButton(button: CalcButton){
        
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            
            //MARK: - Add Button
            if button == .add{
                if self.oneOperationPresent {
                    if self.operationInUse == false{
                        let newValue = Float(self.value) ?? 0
                        let oldValue = self.runningNumber
                        var ans: Float = 0
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
                        if floor(ans) == ans{
                            self.value = "\(Int(ans))"
                        }else{
                            self.value = "\(Float(ans))"
                        }
                        self.runningNumber = ans
//                        self.ansNumber = self.runningNumber
                        self.currentOperation = .add
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = false
                        self.operationInUse = true
                        break
                        
                    }else{
                        self.currentOperation = .add
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = false
                        break
                    }
                }else{
                    if self.operationInUse == false{
                        self.currentOperation = .add
                        if self.answerAfterEqual{
                            self.runningNumber = Float(self.value) ?? 0
//                            self.ansNumber = self.runningNumber
                            self.answerAfterEqual = false
                        }else{
                            self.runningNumber = self.newNumber
//                            self.ansNumber = self.runningNumber
                        }
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = true
                        self.operationInUse = true
                    }else{
                        self.currentOperation = .add
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = true
                    }
                    
                }
            }
            
            //MARK: - Subtract Button
            else if button == .subtract{
                if self.oneOperationPresent {
                    if self.operationInUse == false{
                        let newValue = Float(self.value) ?? 0
                        let oldValue = self.runningNumber
                        var ans: Float = 0
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
                        if floor(ans) == ans{
                            self.value = "\(Int(ans))"
                        }else{
                            self.value = "\(Float(ans))"
                        }
                        self.runningNumber = ans
//                        self.ansNumber = self.runningNumber
                        self.currentOperation = .subtract // --------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = false
                        self.operationInUse = true
                    }else{
                        self.currentOperation = .subtract // --------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = false
                    }
                    break
                }else{
                    if self.operationInUse == false{
                        self.currentOperation = .subtract // -----------
                        if self.answerAfterEqual{
                            self.runningNumber = Float(self.value) ?? 0
//                            self.ansNumber = self.runningNumber
                            self.answerAfterEqual = false
                        }else{
                            self.runningNumber = self.newNumber
//                            self.ansNumber = self.runningNumber
                        }
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = true
                        self.operationInUse = true
                    }else{
                        self.currentOperation = .subtract // --------------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = true
                    }
                    
                }
                
            }
            
            //MARK: - Multiply Button
            else if button == .multiply{
                if self.oneOperationPresent {
                    if self.operationInUse == false{
                        let newValue = Float(self.value) ?? 0
                        let oldValue = self.runningNumber
                        var ans: Float = 0
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
                        if floor(ans) == ans{
                            self.value = "\(Int(ans))"
                        }else{
                            self.value = "\(Float(ans))"
                        }
                        self.runningNumber = ans
//                        self.ansNumber = self.runningNumber
                        self.currentOperation = .multiply // --------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = false
                        self.operationInUse = true
                    }else{
                        self.currentOperation = .multiply // --------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = false
                    }
                    break
                }else{
                    if self.operationInUse == false{
                        self.currentOperation = .multiply // -----------
                        if self.answerAfterEqual{
                            self.runningNumber = Float(self.value) ?? 0
//                            self.ansNumber = self.runningNumber
                            self.answerAfterEqual = false
                        }else{
                            self.runningNumber = self.newNumber
//                            self.ansNumber = self.runningNumber
                        }
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = true
                        self.operationInUse = true
                    }else{
                        self.currentOperation = .multiply // --------------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = true
                    }
                    
                }
            }
            
            //MARK: - Divide Button
            else if button == .divide{
                if self.oneOperationPresent {
                    if self.operationInUse == false{
                        let newValue = Float(self.value) ?? 0
                        let oldValue = self.runningNumber
                        var ans: Float = 0
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
                        if floor(ans) == ans{
                            self.value = "\(Int(ans))"
                        }else{
                            self.value = "\(Float(ans))"
                        }
                        self.runningNumber = ans
//                        self.ansNumber = self.runningNumber
                        self.currentOperation = .divide // --------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = false
                        self.operationInUse = true
                    }else{
                        self.currentOperation = .divide // --------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = false
                    }
                    break
                }else{
                    if self.operationInUse == false{
                        self.currentOperation = .divide // -----------
                        if self.answerAfterEqual{
                            self.runningNumber = Float(self.value) ?? 0
//                            self.ansNumber = self.runningNumber
                            self.answerAfterEqual = false
                        }else{
                            self.runningNumber = self.newNumber
//                            self.ansNumber = self.runningNumber
                        }
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = true
                        self.operationInUse = true
                    }else{
                        self.currentOperation = .divide // --------------
                        self.firstDigitAfterOperation = true
                        self.oneOperationPresent = true
                    }
                    
                }
                
            }
            
            //MARK: - Equal Button
            else if button == .equal{
                
                self.answerAfterEqual = true
                let currentValue = self.newNumber
                let runningValue = self.runningNumber
                switch self.currentOperation {
                case .add:
                    let resultValue = Float(runningValue) + Float(currentValue)
                    if floor(resultValue) == resultValue{
                        self.value = "\(Int(resultValue))"
                    }else{
                        self.value = "\(Float(resultValue))"
                    }
                    
                    self.runningNumber = Float(resultValue)
                    self.ansNumber = self.runningNumber
                    self.currentOperation = .none
                    self.oneOperationPresent = false
                case .subtract:
                    let resultValue = runningValue - currentValue
                    if floor(resultValue) == resultValue{
                        self.value = "\(Int(resultValue))"
                    }else{
                        self.value = "\(Float(resultValue))"
                    }
                    self.runningNumber = resultValue
                    self.ansNumber = self.runningNumber
                    self.currentOperation = .none
                    self.oneOperationPresent = false
                case .divide:
                    if currentValue == 0{
                        self.value = "Error"
                        break
                    }
                    let resultValue = runningValue / currentValue
                    if floor(resultValue) == resultValue{
                        self.value = "\(Int(resultValue))"
                    }else{
                        self.value = "\(Float(resultValue))"
                    }
                    self.runningNumber = resultValue
                    self.ansNumber = self.runningNumber
                    self.currentOperation = .none
                    self.oneOperationPresent = false
                case .multiply:
                    let resultValue = runningValue * currentValue
                    if floor(resultValue) == resultValue{
                        self.value = "\(Int(resultValue))"
                    }else{
                        self.value = "\(Float(resultValue))"
                    }
                    self.runningNumber = resultValue
                    self.ansNumber = self.runningNumber
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
            self.operationInUse = false
            self.decimalPointPresent = false
        
        //MARK: - Negative Button
        case .negative:
            let numberPresent = Float(self.value) ?? 0
            let numberToShow: Float = -1 * numberPresent
            if floor(numberToShow) == numberToShow{
                self.value = "\(Int(numberToShow))"
            }else{
                self.value = "\(Float(numberToShow))"
            }
            self.newNumber = Float(self.value) ?? 0
          
        //MARK: - Answer Button
        case .answer:
            let previousAns = Float(self.ansNumber)
            if floor(previousAns) == previousAns{
                self.value = "\(Int(previousAns))"
            }else{
                self.value = "\(Float(previousAns))"
            }
            self.newNumber = Float(self.value) ?? 0
            self.firstDigitAfterOperation = false
            self.operationInUse = false
            self.oneOperationPresent = true
            
            break
            
        //MARK: - Decimal Button
        case .decimal:
            let element: Character = "."
            if self.value.contains(element){
                break
            }else{
                self.value = "\(self.value)."
            }
            
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
                self.newNumber = Float(self.value) ?? 0
                
            } else {
                
                if self.firstDigitAfterOperation{
                    self.value = number
                    self.firstDigitAfterOperation = false
                    self.operationInUse = false
                }else{
                    self.value = "\(self.value)\(number)"
                }
                self.newNumber = Float(self.value) ?? 0
                self.oneOperationPresent = true
                
            }
        
        }
        
    }
    
    //MARK: - Button Width And Height
    func buttonWidth(item: CalcButton) -> CGFloat{
//        if item == .zero{
//            return ((UIScreen.main.bounds.width - (4*12))/4) * 2
//        }
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

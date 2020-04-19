//
//  ContentView.swift
//  SwiftUI-Calculator
//
//  Created by Mohamed Abd ElNasser on 4/12/20.
//  Copyright © 2020 MohamedAENasser. All rights reserved.
//

import SwiftUI

struct Constants {
    static let plus = "+"
    static let minus = "-"
    static let multiply = "X"
    static let devide = "÷"
    static let equals = "="
    static let precentage = "%"
    static let plusMinus = "±"
    static let clear = "AC"

    static let basicOperators = "=+-÷X"
    static let extraOperators = "AC±%"
    static let allOperators = "=+-÷XAC±%"
}

class GlobalEnvironment: ObservableObject {

    @Published var displayedText = "0"

    var firstNumber = ""
    var secondNumber = ""
    var equationOperation = ""

    func handleButton(_ button: CalculatorButton) {
        if button.title == Constants.plusMinus {
        } else if button.title == Constants.clear {
            clearData()
            displayedText = "0"
        } else if button.title == Constants.equals {
            calculateResult()
        } else if Constants.allOperators.contains(button.title) {
            equationOperation = button.title
        } else if equationOperation.isEmpty {
            firstNumber += button.title
            displayedText = firstNumber
        } else {
            secondNumber += button.title
            displayedText = secondNumber
        }
    }

    func clearData() {
        firstNumber = ""
        secondNumber = ""
        equationOperation = ""
    }

    func calculateResult() {
        let firstFloat = (firstNumber as NSString).floatValue
        let secondFloat = (secondNumber as NSString).floatValue
        var result: Float = 0
        switch equationOperation {
        case Constants.plus:
            result = firstFloat + secondFloat
        case Constants.minus:
            result = firstFloat - secondFloat
        case Constants.devide:
            result = firstFloat / secondFloat
        case Constants.multiply:
            result = firstFloat * secondFloat
        case Constants.devide:
            result = firstFloat.truncatingRemainder(dividingBy: secondFloat)
        default:
            break
        }
        if floor(result) == result {
            displayedText = "\(Int(result))"
        } else {
            displayedText = "\(result)"
        }
        clearData()
    }
}

struct CalculatorButton: Hashable {
    var title: String = ""
    var bgColor: Color = .white

    init(_ title: String) {
        self.title = title
        if Int(title) != nil || title == "." {
            bgColor = Color(.darkGray)
        } else if Constants.basicOperators.contains(title) {
            bgColor = Color(.orange)
        } else if Constants.extraOperators.contains(title) {
            bgColor = Color(.lightGray)
        }
    }
}

struct ContentView: View {

    @EnvironmentObject var env: GlobalEnvironment

    let numbers: [[CalculatorButton]] = [
        [CalculatorButton(Constants.clear), CalculatorButton(Constants.plusMinus), CalculatorButton(Constants.precentage), CalculatorButton(Constants.devide)],
        [CalculatorButton("9"), CalculatorButton("8"), CalculatorButton("7"), CalculatorButton(Constants.multiply)],
        [CalculatorButton("4"), CalculatorButton("5"), CalculatorButton("6"), CalculatorButton(Constants.minus)],
        [CalculatorButton("1"), CalculatorButton("2"), CalculatorButton("3"), CalculatorButton(Constants.plus)],
        [CalculatorButton("0"), CalculatorButton("."), CalculatorButton(Constants.equals)]
    ]
    var body: some View {
        ZStack (alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack (spacing: 15) {
                HStack {
                    Spacer()
                    Text(env.displayedText)
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                }.padding()
                ForEach(numbers, id: \.self) { row in
                    HStack (spacing: 15) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button)
                        }
                    }
                }
            }.padding(.bottom)
        }
    }
}

struct CalculatorButtonView: View {
    var button: CalculatorButton

    @EnvironmentObject var env: GlobalEnvironment

    var body: some View{
        Button(action: {
            self.env.handleButton(self.button)
        }) {
            Text(button.title)
                .font(.system(size: 40))
                .frame(width: self.buttonWidth(button.title), height: self.buttonHeight())
                .background(button.bgColor)
                .foregroundColor(Color.white)
                .cornerRadius(self.buttonHeight())
        }
    }

    private func buttonWidth(_ title: String) -> CGFloat {
        if title == "0" {
            return ((UIScreen.main.bounds.width - 15*5)/4) * 2
        }
        return (UIScreen.main.bounds.width - 15*5)/4
    }

    private func buttonHeight() -> CGFloat {
        (UIScreen.main.bounds.width - 15*5)/4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}

//
//  ContentView.swift
//  SwiftUI-Calculator
//
//  Created by Mohamed Abd ElNasser on 4/12/20.
//  Copyright © 2020 MohamedAENasser. All rights reserved.
//

import SwiftUI

class GlobalEnvironment: ObservableObject {

    @Published var displayedText = ""

    func handleButton(_ button: CalculatorButton) {
        displayedText = button.title
    }
}

struct CalculatorButton: Hashable {
    var title: String = ""
    var bgColor: Color = .white

    init(_ title: String) {
        self.title = title
        if Int(title) != nil || title == "." {
            bgColor = Color(.darkGray)
        } else if "=+-/÷X".contains(title) {
            bgColor = Color(.orange)
        } else if "AC±%".contains(title) {
            bgColor = Color(.lightGray)
        }
    }
}

struct ContentView: View {

    @EnvironmentObject var env: GlobalEnvironment

    let numbers: [[CalculatorButton]] = [
        [CalculatorButton("AC"), CalculatorButton("±"), CalculatorButton("%"), CalculatorButton("÷")],
        [CalculatorButton("9"), CalculatorButton("8"), CalculatorButton("7"), CalculatorButton("X")],
        [CalculatorButton("4"), CalculatorButton("5"), CalculatorButton("6"), CalculatorButton("-")],
        [CalculatorButton("1"), CalculatorButton("2"), CalculatorButton("3"), CalculatorButton("+")],
        [CalculatorButton("0"), CalculatorButton("."), CalculatorButton("=")]
    ]
    var body: some View {
        ZStack (alignment: .bottom) {
            Color.gray.edgesIgnoringSafeArea(.all)
            VStack (spacing: 15) {
                HStack {
                    Spacer()
                    Text(env.displayedText)
                        .font(.system(size: 40))
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

    func buttonWidth(_ title: String) -> CGFloat {
        if title == "0" {
            return ((UIScreen.main.bounds.width - 15*5)/4) * 2
        }
        return (UIScreen.main.bounds.width - 15*5)/4
    }

    func buttonHeight() -> CGFloat {
        (UIScreen.main.bounds.width - 15*5)/4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}

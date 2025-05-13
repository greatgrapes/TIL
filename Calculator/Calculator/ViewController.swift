//
//  ViewController.swift
//  Calculator
//
//  Created by grape on 5/13/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 48, weight: .light)
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 상태 저장 변수
    
    var currentInput: String = "0"
    var previousValue: Double?
    var currentOperator: String?
    var isTypingNumber = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCalculatorUI()
    }
    
    // MARK: - UI Setup
    
    func setupCalculatorUI() {
        view.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.6 - 30),
            resultLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let buttonTitles: [[String]] = [
            ["AC", "+/-", "%", "÷"],
            ["7", "8", "9", "X"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["Cal", "0", ".", "="]
        ]
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.distribution = .fillEqually
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        for row in buttonTitles {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.distribution = .fillEqually
            
            for title in row {
                let button = createButton(title: title)
                rowStack.addArrangedSubview(button)
            }
            mainStack.addArrangedSubview(rowStack)
        }
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mainStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    // MARK: - 버튼 생성
    
    func createButton(title: String) -> CircleButton {
        let button = CircleButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.backgroundColor = isOperator(title) ? .orange : .darkGray
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    func isOperator(_ symbol: String) -> Bool {
        return ["÷", "X", "-", "+", "="].contains(symbol)
    }
    
    // MARK: - 버튼 터치 핸들러
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        
        switch title {
        case "0"..."9", ".":
            handleNumberInput(title)
        case "+", "-", "X", "÷":
            handleOperatorInput(title)
        case "=":
            calculateResult()
        case "AC":
            clearAll()
        case "+/-":
            toggleSign()
        case "%":
            applyPercentage()
        default:
            break
        }
    }
    
    // MARK: - 동작 구현
    
    func handleNumberInput(_ number: String) {
        if isTypingNumber {
            if number == "." && currentInput.contains(".") { return }
            currentInput += number
        } else {
            currentInput = (number == ".") ? "0." : number
            isTypingNumber = true
        }
        resultLabel.text = currentInput
    }
    
    func handleOperatorInput(_ op: String) {
        previousValue = Double(currentInput)
        currentOperator = op
        isTypingNumber = false
    }
    
    func calculateResult() {
        guard let op = currentOperator,
              let prev = previousValue,
              let current = Double(currentInput) else { return }

        let result: Double
        switch op {
        case "+": result = prev + current
        case "-": result = prev - current
        case "X": result = prev * current
        case "÷": result = current != 0 ? prev / current : 0
        default: return
        }
        
        currentInput = String(result)
        resultLabel.text = currentInput
        isTypingNumber = false
        currentOperator = nil
        previousValue = nil
    }
    
    func clearAll() {
        currentInput = "0"
        previousValue = nil
        currentOperator = nil
        isTypingNumber = false
        resultLabel.text = "0"
    }
    
    func toggleSign() {
        if let value = Double(currentInput) {
            currentInput = String(-value)
            resultLabel.text = currentInput
        }
    }
    
    func applyPercentage() {
        if let value = Double(currentInput) {
            currentInput = String(value / 100)
            resultLabel.text = currentInput
        }
    }
}

// MARK: - CircleButton 커스텀

class CircleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

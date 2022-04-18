//
//  ViewController.swift
//  Swifty_Words_App
//
//  Created by Alex Paramonov on 16.03.22.
//

import UIKit

class ViewController: UIViewController {
     
     var cluesLabel: UILabel!
     var answerLabel: UILabel!
     var currentAnswer: UITextField!
     var scoreLabel: UILabel!
     var letterButtons = [UIButton]()
     
     var activatedButton = [UIButton]()
     var solutions = [String]()
     
     var numberOfGuessedWords = 0
     var score = 0 {
          didSet {
               scoreLabel.text = "Score - \(score)"
          }
     }
     var level = 1
     
     
     override func loadView() {
          setUIElements()
     }
     override func viewDidLoad() {
          super.viewDidLoad()
          loadLevel()
     }
     
     @objc func letterTapped (_ sender: UIButton) {
          guard let buttonTitle = sender.titleLabel?.text else {return}
          currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
          activatedButton.append(sender)
          sender.isHidden = true
     }
     
     @objc func submitTapped (_ sender: UIButton) {
          guard let answerText = currentAnswer.text else {return}
          
          if let solutionPosition = solutions.firstIndex(of: answerText) {
               activatedButton.removeAll()
               
               var splitAnswer = answerLabel.text?.components(separatedBy: "\n")
               splitAnswer?[solutionPosition] = answerText
               answerLabel.text = splitAnswer?.joined(separator: "\n")
               
               currentAnswer.text = ""
               score += 1
               numberOfGuessedWords += 1
               
               if numberOfGuessedWords % 7 == 0 {
                    let alertController = UIAlertController(title: "Well done!", message: "Are you ready for the next level? ", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                    present(alertController, animated: true)
               }
          } else {
               
               if score > 0 {
                    score -= 1
               } else {
                    score = 0
               }
               
               let alertController = UIAlertController(title: "Uppsss!", message: "This is incorrect word", preferredStyle: .alert)
               alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
                    self.currentAnswer.text = ""
                    
                    for button in self.activatedButton {
                         button.isHidden = false
                    }
                    self.activatedButton.removeAll()
               }))
               present(alertController, animated: true)
          }
     }
     
     @objc func clearTapped (_ sender: UIButton) {
          currentAnswer.text = ""
          
          for button in activatedButton {
               button.isHidden = false
          }
          activatedButton.removeAll()
     }
     
     private func levelUp(action: UIAlertAction) {
          level += 1
          solutions.removeAll(keepingCapacity: true)
          
          loadLevel()
          
          for btn in letterButtons {
               btn.isHidden = true
          }
     }
     
     private func setUIElements() {
          
          view = UIView()
          view.backgroundColor = .white
          
          // set UIlabel
          scoreLabel = UILabel()
          scoreLabel.translatesAutoresizingMaskIntoConstraints = false
          scoreLabel.textAlignment = .right
          scoreLabel.text = "Score: 0"
          scoreLabel.backgroundColor = .green
          view.addSubview(scoreLabel)
          
          cluesLabel = UILabel()
          cluesLabel.translatesAutoresizingMaskIntoConstraints = false
          cluesLabel.font = UIFont.systemFont(ofSize: 24)
          cluesLabel.text = "CLUES"
          cluesLabel.numberOfLines = 0
          cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
          view.addSubview(cluesLabel)
          
          
          answerLabel = UILabel()
          answerLabel.translatesAutoresizingMaskIntoConstraints = false
          answerLabel.font = UIFont.systemFont(ofSize: 24)
          answerLabel.numberOfLines = 0
          answerLabel.textAlignment = .right
          answerLabel.text = "ANSWER"
          answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
          view.addSubview(answerLabel)
          
          // setUITextField
          
          currentAnswer = UITextField()
          currentAnswer.translatesAutoresizingMaskIntoConstraints = false
          currentAnswer.placeholder = "Tab letters to guess"
          currentAnswer.textAlignment = .center
          currentAnswer.font = UIFont.systemFont(ofSize: 44)
          currentAnswer.isUserInteractionEnabled = false
          view.addSubview(currentAnswer)
          
          // setUIButton
          
          let submit = UIButton(type: .system)
          submit.translatesAutoresizingMaskIntoConstraints = false
          submit.setTitle("SUBMIT", for: .normal)
          submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
          submit.layer.borderWidth = 2.0
          submit.layer.cornerRadius = 15
          submit.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0).cgColor
          view.addSubview(submit)
          
          let clear = UIButton(type: .system)
          clear.translatesAutoresizingMaskIntoConstraints = false
          clear.setTitle("CLEAR", for: .normal)
          clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
          clear.layer.borderWidth = 2.0
          clear.layer.cornerRadius = 15
          clear.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0).cgColor
          view.addSubview(clear)
          
          // setContainerView
          
          let buttonView = UIView()
          buttonView.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(buttonView)
          
          
          
          // setConstrains
          NSLayoutConstraint.activate([
               scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
               scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
               cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
               cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
               cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
               answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
               answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
               answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
               answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
               currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
               currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
               submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
               submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
               submit.heightAnchor.constraint(equalToConstant: 44),
               clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
               clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
               clear.heightAnchor.constraint(equalToConstant: 44),
               buttonView.widthAnchor.constraint(equalToConstant: 750),
               buttonView.heightAnchor.constraint(equalToConstant: 320),
               buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               buttonView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
               buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
          ])
          
          let width = 150
          let height = 80
          
          for row in 0...3 {
               for col in 0...4 {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                    letterButton.layer.borderWidth = 2.0
                    letterButton.layer.cornerRadius = 15
                    letterButton.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0).cgColor
                    letterButton.setTitle("WWW", for: .normal)
                    
                    let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                    letterButton.frame = frame
                    
                    buttonView.addSubview(letterButton)
                    
                    letterButtons.append(letterButton)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    
               }
          }
          
     }
     
     private func loadLevel(){
          var clueString = ""
          var solutionString = ""
          var letterBits = [String]()
          
          DispatchQueue.global(qos: .userInitiated).async {
               if let levelFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: "txt") {
                    if let levelContents  = try? String(contentsOf: levelFileURL) {
                         var lines = levelContents.components(separatedBy: "\n")
                         lines.shuffle()
                         
                         for (index, line) in lines.enumerated() {
                              let parts = line.components(separatedBy: ": ") // разбивает строку на массив
                              let answer = parts[0]
                              let clue = parts[1]
                              
                              clueString += "\(index + 1). \(clue)\n"
                              
                              let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                              solutionString += "\(solutionWord.count) letters\n"
                              self.solutions.append(solutionWord)
                              
                              let bits = answer.components(separatedBy: "|")
                              letterBits += bits
                         }
                    }
               }
          }
          DispatchQueue.main.async {
               self.cluesLabel.text  = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
               self.answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
               
               letterBits.shuffle()  // shufle случайно изменяет порядок массива
               
               if letterBits.count == self.letterButtons.count {
                    for i in 0..<self.letterButtons.count {
                         self.letterButtons[i].setTitle(letterBits[i], for: .normal)
                         
                    }
               }
          }
     }
}


//
//  ViewController.swift
//  TTT
//
//  Created by Cyril Garcia on 8/14/18.
//  Copyright © 2018 Cyril Garcia. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    
    let AI = TicTacToeAI()
    
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var turnLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var pieceButtonZero: UIButton!
    @IBOutlet var pieceButtonOne: UIButton!
    @IBOutlet var pieceButtonTwo: UIButton!
    @IBOutlet var pieceButtonThree: UIButton!
    @IBOutlet var pieceButtonFour: UIButton!
    @IBOutlet var pieceButtonFive: UIButton!
    @IBOutlet var pieceButtonSix: UIButton!
    @IBOutlet var pieceButtonSeven: UIButton!
    @IBOutlet var pieceButtonEight: UIButton!
    
    @IBOutlet var restartButton: UIButton!
    
    var turnState = 1
    var turnCount = 0
    var binaryBoardState = [0,0,0,0,0,0,0,0,0]
    var boardState = ["","","","","","","","",""]
    var gameover = false
    
    let winningCombo = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        turnLabel.text = "Player One's Turn"
        
        restartButton.isHidden = true
        winnerLabel.isHidden = true
        
    }
    
    func buttonChange(tag: Int, piece: String) {
        let button = view.viewWithTag(tag) as! UIButton
        button.isEnabled = false
        button.setTitle(piece, for: .normal)
        
        if piece == "X" {
            button.setTitleColor(ColorMods.hex(hexValue: 0xF5B841), for: .normal)
            
        } else {
            button.setTitleColor(ColorMods.hex(hexValue: 0x6A041D), for: .normal)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let tag = sender.tag
        
        if turnState == 1 {
            buttonChange(tag: tag, piece: "X")
            boardState[tag] = "X"
            binaryBoardState[tag] = 1
            turnLabel.text = "Player Two's Turn"
            
        }
        
        turnState *= -1
        turnCount += 1
        
        checkDraw()
        checkWinner()
        aiDecision()
        
    }
    
    func checkWinner() {
        for combo in winningCombo {
            let x = combo[0]
            let y = combo[1]
            let z = combo[2]
            
            if boardState[x] == boardState[y] && boardState[x] == boardState[z] && boardState[x] != "" {
                
                winnerLabel.isHidden = false
                restartButton.isHidden = false
                winnerLabel.text = "Winner is " + boardState[x]
                disableButtons()
                gameover = true
                break
                
            }
            
        }
        
    }
    
    func checkDraw() {
        var count = 0
        for state in boardState {
            if state == "" {
                count += 1
            }
        }
        
        if count == 0 {
            winnerLabel.text = "Draw"
            winnerLabel.isHidden = false
            restartButton.isHidden = false
        }
        
    }
    
    
    
    func aiDecision() {
        var winningProbability = [Double]()
        
        for i in 0..<binaryBoardState.count {
            if self.binaryBoardState[i] == 0 {
                var sampleBoardState = self.binaryBoardState
                sampleBoardState[i] = -1
                let prob = try? AI.prediction(board_state: self.convertToMLArray(sampleBoardState))
                winningProbability.append(prob!.winning_probability[0] as! Double)
            } else {
                winningProbability.append(0.0)
            }
        }
        
        var maxProb = -1.0
        var maxProbIndex = -1
        
        for i in 0..<winningProbability.count {
            if winningProbability[i] > maxProb {
                maxProb = winningProbability[i]
                maxProbIndex = i
            }
        }
        
        binaryBoardState[maxProbIndex] = -1
        boardState[maxProbIndex] = "O"
        buttonChange(tag: maxProbIndex, piece: "O")
        turnState *= -1
        turnCount += 1
        
        checkDraw()
        checkWinner()
    }
    
    func convertToMLArray(_ array: [Int]) -> MLMultiArray {
        let arr = try? MLMultiArray(shape: [1,1,9], dataType: MLMultiArrayDataType.float32)
        
        for i in 0..<array.count {
            arr?[i] = NSNumber(value: array[i])
        }
        return arr!
    }
    
    func disableButtons() {
        pieceButtonZero.isEnabled = false
        pieceButtonOne.isEnabled = false
        pieceButtonTwo.isEnabled = false
        pieceButtonThree.isEnabled = false
        pieceButtonFour.isEnabled = false
        pieceButtonFive.isEnabled = false
        pieceButtonSix.isEnabled = false
        pieceButtonSeven.isEnabled = false
        pieceButtonEight.isEnabled = false
        
    }
    
    
    
    
    
}


//
//  ViewController.swift
//  ColorSwipe
//
//  Created by Eken Özlü on 14.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var colorCard: UIView!
    @IBOutlet weak var cardText: UILabel!
    
    var score: Int = 0
    var divisor: CGFloat!
    var randForText : Int!
    var randForBG : Int!
    var randForTextColor : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCard()
        
        divisor = (view.frame.width / 2) / 0.61
        
        colorCard.layer.cornerRadius = 9
        colorCard.layer.shadowColor = UIColor.black.cgColor
        colorCard.layer.shadowOffset = .zero
        colorCard.layer.shadowOpacity = 0.5
        colorCard.layer.shadowRadius = colorCard.frame.width/8
    }

    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        //Image for swiping right and left
        //if xFromCenter > 0 {}else{}
        
        //Image Tint
        //cardImageView.alpha = abs(xFromCenter) / view.center.x
        
        //Moving Card with anchor in center of the card
        card.center = CGPoint(x:(view.center.x + point.x), y:view.center.y)
        
        
        
        //Tilting the Card in radian according to the position
        //In divisor variable I calculated the correct number which converts card cordinate to radiant value with increasing style at 35 degree max
        //Scaling the card down when it is closer to the edge
        let scale = min(100/abs(xFromCenter), 1)
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
        //Position the card after gesture ends
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 75 {
                //Move off to the left
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                //Check if text and bg color is different (Needs to be different to success)
                if randForText != randForBG{
                    score += 1
                    newCard()
                }else{
                    endGame()
                }
                
            }
            else if card.center.x > (view.frame.width - 75) {
                //Move off to the right
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                //Check if text and bg color is different (Needs to be same to success)
                if randForText == randForBG{
                    score += 1
                    newCard()
                }else{
                    endGame()
                }
            }
            else {
                //Back to the Center
                UIView.animate(withDuration: 0.2) {
                    self.colorCard.center = self.view.center
                    self.colorCard.alpha = 1
                    self.colorCard.transform = .identity
                    //self.cardImageView.image = nil
                }
            }
        }
    }
    
    func newCard() {
        scoreLabel.text = "\(score)"
        setTheCardColorAndTitle()
        UIView.animate(withDuration: 0.2) {
            self.colorCard.center = self.view.center
            self.colorCard.alpha = 1
            self.colorCard.transform = .identity
            //self.cardImageView.image = nil
        }
    }
    
    func setTheCardColorAndTitle() {
        let listLen = textList.count-1
        randForText = Int.random(in: 0...listLen)
        cardText.text = textList[randForText]
        randForBG = Int.random(in: 0...listLen)
        colorCard.backgroundColor = colorList[randForBG]
        
        randForTextColor = Int.random(in: 0...listLen)
        while randForTextColor == randForBG {
            randForTextColor = Int.random(in: 0...listLen)
        }
        cardText.textColor = colorList[randForTextColor]
    }
    
    func endGame() {
        let ac = UIAlertController(title: "Game Over", message: "Game ends with \(score) Points", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Start New Game", style: .cancel, handler: { _ in
            //START NEW GAME
            self.score = 0
            self.newCard()
        }))
        self.present(ac, animated: true)
    }
}


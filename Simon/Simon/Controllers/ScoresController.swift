//
//  ScoresController.swift
//  Simon
//
//  Created by Zohar Bergman on 19/07/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import Foundation
import UIKit

class ScoresController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // Consts
    let LIMIT = 10
    let NAME = "Name"
    let SCORE = "Score"
    
    // Properties
    @IBOutlet weak var cvScores: UICollectionView!
    private var scores : [Score]?
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scores = Score.fetchData(limit: LIMIT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (scores?.count)! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Getting a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScoreCell", for: indexPath) as! ScoreCell
        
        cell.lblText.textColor = UIColor.white
        
        // Setting the cell's content
        if (indexPath.section == 0) {
            if (indexPath.item == 0) {
                cell.lblText.text = NAME
            } else if (indexPath.item == 1){
                cell.lblText.text = SCORE
            }
        
            cell.lblText.font = UIFont(name: "Chalkboard SE", size: 35)
        } else {
            if (indexPath.item == 0) {
                cell.lblText.text = scores![indexPath.section - 1].name
            } else if (indexPath.item == 1){
                cell.lblText.text = String(scores![indexPath.section - 1].points.intValue)
            }
            
            cell.lblText.font = UIFont(name: cell.lblText.font.fontName, size: 24)
        }
        
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // Set the dimentions of each cell in the board
        let dimentionWidth = collectionView.frame.width / 2 - 10
        let dimentionHeight = CGFloat(40)
        
        return CGSize(width: dimentionWidth, height: dimentionHeight)
    }
}

class ScoreCell : UICollectionViewCell {
    @IBOutlet weak internal var lblText: UILabel!
    
    override func awakeFromNib() {
    }
}

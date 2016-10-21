//
//  ViewController.swift
//  GameCenterTutorial
//
//  Created by FV iMAGINATION on 21/10/2016.
//  Copyright © 2016 FV iMAGINATION. All rights reserved.
//

import UIKit
import GameKit


class ViewController: UIViewController,
GKGameCenterControllerDelegate
{

    /* Views */
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.score.mygamename"
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    // Show initial score
    scoreLabel.text = "\(score)"
 
    
    // Call the GC authentication controller
    authenticateLocalPlayer()
}

   
   
    
// MARK: - AUTHENTICATE LOCAL PLAYER
func authenticateLocalPlayer() {
    let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
    localPlayer.authenticateHandler = {(ViewController, error) -> Void in
        if((ViewController) != nil) {
            // 1 Show login if player is not logged in
            self.present(ViewController!, animated: true, completion: nil)
        } else if (localPlayer.isAuthenticated) {
            // 2 Player is already euthenticated & logged in, load game center
            self.gcEnabled = true
                
            // Get the default leaderboard ID
            localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                if error != nil { print(error)
                } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
            })
            
        } else {
            // 3 Game center is not enabled on the users device
            self.gcEnabled = false
            print("Local player could not be authenticated!")
            print(error)
        }
    }
}

    
    
    
    
    
    
// MARK: - ADD 10 POINTS TO THE SCORE AND SUBMIT THE UPDATED SCORE TO GAME CENTER
@IBAction func addScoreAndSubmitToGC(_ sender: AnyObject) {
    // Add 10 points to current score
    score += 10
    scoreLabel.text = "\(score)"
    
    // Submit score to GC leaderboard
    let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
    bestScoreInt.value = Int64(score)
    GKScore.report([bestScoreInt]) { (error) in
        if error != nil {
            print(error!.localizedDescription)
        } else {
            print("Best Score submitted to your Leaderboard!")
        }
    }
}
  
    
// Delegate to dismiss the GC controller
func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
}


    
    
// MARK: - OPEN GAME CENTER LEADERBOARD
@IBAction func checkGCLeaderboard(_ sender: AnyObject) {
    let gcVC = GKGameCenterViewController()
    gcVC.gameCenterDelegate = self
    gcVC.viewState = .leaderboards
    gcVC.leaderboardIdentifier = LEADERBOARD_ID
    present(gcVC, animated: true, completion: nil)
}
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//  GameViewController.swift
//  Hint.e
//
//  Created by Emily Lynam on 9/21/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import UIKit; import Foundation; import AVFoundation;

class GameViewController: UIViewController, RoundOverViewControllerDelegate {
    
    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    var movies = [Movie]()
    var randIndex: Int?
    var timer = Timer()
    var timerCount = 10
    var score = 0
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBAction func correctButtonPressed(_ sender: UIButton) {
        movies.remove(at: randIndex!)
        setAnswerLabel()
        score += 1
        scoreLabel.text = String(score)
        if let asset = NSDataAsset(name: "Correct Answer Sound Effect") {
            do {
                try audioPlayer = AVAudioPlayer(data:asset.data, fileTypeHint: "mp3")
                audioPlayer.play()
            } catch let error as NSError {
                print(error.localizedDescription)
    
            }
        }
    }
    
    func startGame () {
        timerCount = 30
        score = 0
        timerLabel.text = String(timerCount)
        scoreLabel.text = String(score)
        Movie.getMovieRequest(url: "https://api.themoviedb.org/3/movie/109445/similar?language=en-US&api_key=a9f9a3f34caecf352497c069126e23b7"){
            (movies:[Movie]) in
            self.movies = movies
            DispatchQueue.main.async {
                self.setAnswerLabel()
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iphone.jpg")!)

        answerLabel.text = "Get Ready!"
        if let asset = NSDataAsset(name: "Hint.e") {
            do {
                try audioPlayer2 = AVAudioPlayer(data:asset.data, fileTypeHint: "mp3")
                audioPlayer2.play()
            } catch let error as NSError {
                print(error.localizedDescription)
                
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        answerLabel.text = "Get Ready!"
        timerLabel.text = ""
        startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAnswerLabel() {
        randIndex = Int(arc4random_uniform(UInt32(movies.count)))
        if movies.count < 1 {
            answerLabel.text = "Game Over!"
        } else {
            answerLabel.text = movies[randIndex!].title
        }
    }
    
    func updateTime() {
        if timerCount > 0 {
            timerCount -= 1
            timerLabel.text = String(timerCount)
        } else {
            timer.invalidate()
            performSegue(withIdentifier: "GameOver", sender: self)
            print(timerCount)
//            timer.fire()
            answerLabel.text = ""
            timerLabel.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RoundOverViewController
        destination.delegate = self
        destination.score = score
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  Hint.e
//
//  Created by Emily Lynam on 9/21/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class HomeViewController: UIViewController, CancelButtonDelegate, AddPlayerTableViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var players = [Player]()
    var currentPlayers = [String]()
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        currentPlayers = [String]()
        playPlayerButton.setTitle("Add Player", for: UIControlState.normal)
        playerTableView.reloadData()
    }
    @IBOutlet weak var playerTableView: UITableView!
    @IBAction func playPlayerButtonPressed(_ sender: UIButton) {
        if playPlayerButton.titleLabel?.text == "Play" {
            performSegue(withIdentifier: "Play", sender: self)

        } else {
            performSegue(withIdentifier: "AddPlayer", sender: self)
        }
    }
    @IBOutlet weak var playPlayerButton: UIButton!
    func cancelButtonPressedFrom(controller: UITableViewController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: HomeViewController) {
        
    }
    func addPlayerTableViewController(controller: AddPlayerTableViewController, didFinishAddingPlayer names: [String]) {
        dismiss(animated: true, completion: nil)
        //append to an array 
        print(names)
        currentPlayers = names
        for name in names {
            let newPlayer = NSEntityDescription.insertNewObject(forEntityName: "Player", into: context) as NSManagedObject
            do {
                // need check for existing players
                newPlayer.setValue(name, forKey: "name")
                try self.context.save()
                print("Success! \(name) added!")
            } catch {
                print("Error: \(error)")
            }
        }
        playPlayerButton.setTitle("Play", for: UIControlState.normal)
        playerTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentPlayers.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentPlayerCell", for: indexPath)
        cell.textLabel?.text = currentPlayers[indexPath.row]

        return cell
        
    }
    
    // for leaderboard
    func fetchAllPlayers() {
        do {
            let results = try context.fetch(Player.fetchRequest())
            players = results as! [Player]
            print(players)
        } catch {
            print("\(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerTableView.delegate = self
        playerTableView.dataSource = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iphone.jpg")!)
//        playerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CurrentPlayerCell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playerTableView.reloadData()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iphone.jpg")!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPlayer" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddPlayerTableViewController
            controller.cancelButtonDelegate = self
            controller.delegate = self
        } else {
//            let controller = segue.destination as! UIViewController
//            let controller = navigationController.topViewController as! AddPlayerTableViewController
            
        }
    }

}


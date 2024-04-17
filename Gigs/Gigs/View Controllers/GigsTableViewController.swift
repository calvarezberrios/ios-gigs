//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Carlos E. Alvarez-Berrios on 4/15/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let reuseidentifier = "GigCell"
    
    let authController = AuthController()
    let gigController = GigController()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if authController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        
        //  TODO: fetch gigs here
        if let bearer = authController.bearer {
            gigController.getAllGigs(with: bearer) { error in
                if let error = error {
                    NSLog("Error getting gigs: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        let gig = gigController.gigs[indexPath.row]
        
        content.text = gig.title
        content.secondaryText = dateFormatter.string(from: gig.dueDate)
        
        cell.contentConfiguration = content
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginViewModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.authController = authController
            }
        } else if segue.identifier == "AddGigSegue" {
            if let addGigVC = segue.destination as? GigDetailViewController {
                addGigVC.bearer = authController.bearer
                addGigVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
            if let showGigVC = segue.destination as? GigDetailViewController {
                guard let indexPath = tableView.indexPathForSelectedRow else {
                    NSLog("Unable to get indexPath for selected cell")
                    return
                }
                showGigVC.bearer = authController.bearer
                showGigVC.gigController = gigController
                let gig = gigController.gigs[indexPath.row]
                print(gig)
                showGigVC.gig = gig
            }
        }
    }
    

}

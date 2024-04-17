//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Carlos E. Alvarez-Berrios on 4/17/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var bearer: Bearer?
    var gigController: GigController?
    var gig: Gig?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let gig = gig {
            updateViews()
        }
    }
    
    private func updateViews() {
        navigationItem.title = gig?.title
        titleTextField.text = gig?.title
        
        if let dueDate = gig?.dueDate {
            datePickerView.date = dueDate
        }
        
        descriptionTextView.text = gig?.description
        
    }


    @IBAction func saveGig(_ sender: Any) {
        if gig == nil {
            guard let title = titleTextField.text, !title.isEmpty,
                  let description = descriptionTextView.text, !description.isEmpty
            else {
                NSLog("Title and description fields not field in.")
                return
            }
            
            guard let bearer = bearer else {
                NSLog("No Bearer Token found.")
                return
            }
            
            let dueDate = datePickerView.date
            
            let newGig = Gig(title: title, description: description, dueDate: dueDate)
            
            gigController?.createGig(with: bearer, newGig: newGig, completion: { error in
                if let error = error {
                    NSLog("Error creating gig: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
}

//
//  NewEntryViewController.swift
//  myJournal
//
//  Created by Angus yeung on 11/1/18.
//  Copyright © 2018 Server Side Swift. All rights reserved.
//

import UIKit

// Define the delegate protocol to inform Main Screen View Controller
protocol EntryDetailsViewControllerDelegate: class {
    // Delegate Cancel Event
    func entryDetailsViewControllerDidCancel(_ controller: EntryDetailsViewController)
    // Delegate Done Adding Event
    func entryDetailsViewController(_ controller: EntryDetailsViewController,
                                didFinishAdding entry: JournalEntry)
    // Delegate Done Editing Event
    func entryDetailsViewController(_ controller: EntryDetailsViewController,
                                didFinishEditing entry: JournalEntry)
}

class EntryDetailsViewController : UIViewController {
    
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryContent: UITextView!
    
    weak var delegate : EntryDetailsViewControllerDelegate?
    
    var existEntry: JournalEntry?
    
    @IBAction func done() {
        
        // edit mode
        if let exist = existEntry {
            exist.title = entryTitle.text!
            exist.content = entryContent.text!
            delegate?.entryDetailsViewController(self, didFinishEditing: exist)
        }
        // create mode
        else {
            let entry = JournalEntry(title: entryTitle.text!,
                                     content: entryContent.text!)
            delegate?.entryDetailsViewController(self, didFinishAdding: entry)
        }
    }
    
    @IBAction func cancel() {
        delegate?.entryDetailsViewControllerDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entryTitle.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = existEntry {
            entryTitle.text = entry.title
            entryContent.text = entry.content
        } else {
            title = "Create an Entry"
        }
    }
    
}

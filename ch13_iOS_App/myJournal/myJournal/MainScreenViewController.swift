//
//  MainScreenViewController.swift
//  myJournal
//
//  Created by Angus yeung on 10/25/18.
//  Copyright © 2018 Server Side Swift. All rights reserved.
//

import UIKit

class MainScreenViewController: UITableViewController, EntryDetailsViewControllerDelegate {
    
    
    let apiURL : String  = "http://localhost:8080/api"
    var journalEntries = [JournalEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAll()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // tell NewEntryViewController
        if segue.identifier == "NewEntry" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! EntryDetailsViewController
            controller.delegate = self
        } else if segue.identifier == "EditEntry" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! EntryDetailsViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.existEntry = journalEntries[indexPath.row]
            }
        } else if segue.identifier == "ViewEntry" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! EntryDetailsViewController
            controller.delegate = self
            if let indexPath = self.tableView.indexPathForSelectedRow {
                controller.existEntry = journalEntries[indexPath.row]
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return journalEntries.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell",
                                                 for: indexPath)
        if let title = journalEntries[indexPath.row].title {
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = title
            //cell.textLabel!.text = title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // remove from database first before deleting it locally
        removeEntry(entry: journalEntries[indexPath.row])
        journalEntries.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func createEntry(entry: JournalEntry) {
        let newRowIndex = journalEntries.count
        journalEntries.append(entry)
        newEntry(entry: entry)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func updateEntry(entry: JournalEntry) {
        guard let index = journalEntries.index(of: entry) else {
            print("Error in reading the specified journal entry.")
            return
        }
        journalEntries[index] = entry
        editEntry(entry: entry)
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
            // cell.textLabel!.text = entry.title
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = entry.title
        }
    }

    func entryDetailsViewControllerDidCancel(_ controller: EntryDetailsViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func entryDetailsViewController(_ controller: EntryDetailsViewController, didFinishAdding entry: JournalEntry) {
        createEntry(entry: entry)
        dismiss(animated: true, completion: nil)
    }
    
    func entryDetailsViewController(_ controller: EntryDetailsViewController, didFinishEditing entry: JournalEntry) {
        updateEntry(entry: entry)
        dismiss(animated: true, completion: nil)
    }
    
}


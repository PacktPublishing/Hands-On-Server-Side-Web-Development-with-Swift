//
//  ApiRoutes.swift
//  Application
//
//  Created by Angus yeung on 11/12/18.
//

import Foundation
import Kitura
import SwiftKueryORM
import SwiftKueryPostgreSQL
import LoggerAPI

extension App 
{

  // retrieve all items
  func getAllHandler(completion: @escaping([JournalItem]?, RequestError?) -> Void) {
    JournalItem.findAll() { items, error in
      guard let items = items else {
        return completion(nil, error)
      }
      completion(items, nil)
    }
  }

  // retrieve an item by ID and return it
  func getItemHandler(id: Int, 
                      completion: @escaping(JournalItem?, RequestError?) -> Void) {
    JournalItem.find(id: id) { item, error in 
      guard let item = item else {
        return completion(nil, error)
      }
      completion(item, nil)
    }
  }

  // find an item by ID and replace it
  func updateItemHandler(id: Int, 
                         item: JournalItem,
                         completion: @escaping(JournalItem?, RequestError?) -> Void) {
    item.update(id: id, completion)
  }

  // save a new item
  func createItemHandler(item: JournalItem, 
                        completion: @escaping(JournalItem?, RequestError?) -> Void) {
    item.save(completion)
  }

  // delete an item by ID
  func deleteItemHandler(id: Int, 
                         completion: @escaping(RequestError?) -> Void) {
    JournalItem.delete(id: id, completion)
  }

  // delete all items
  func deleteAllHandler(completion: @escaping(RequestError?) -> Void) {
    JournalItem.deleteAll(completion)
  }
}

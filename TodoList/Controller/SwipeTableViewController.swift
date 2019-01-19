//
//  SwipeTableViewController.swift
//  TodoList
//
//  Created by Алесь Шеншин on 16/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65.0
        tableView.separatorStyle = .none
    }
    //MARK: - TableView data source methods
    
    func bgColour(_ table: Table, _ cell: UITableViewCell) {
        
        if table.colour == "" {
            if let colour: String = UIColor.randomFlat()?.hexValue(){
                saveColour(colour, table)
                cell.backgroundColor = UIColor(hexString: colour)
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: UIColor(hexString: colour), returnFlat: true)
            } else {
                saveColour(UIColor.white.hexValue(), table)
                cell.backgroundColor = UIColor.white
            }
        } else {
            cell.backgroundColor = UIColor(hexString: table.colour)
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: UIColor(hexString: table.colour), returnFlat: true)
        }
    }
    
    func saveColour(_ colour: String, _ table: Table){
        do {
            try realm.write {
                table.colour = colour
            }
        } catch {
            print("Can't save table view cell bg colour: ", error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
    
    // MARK: - Data manipulation methods
    
//    func realmLoadCats(){
//        realmCatsResults = realm.objects(RealmCategory.self)
//        tableView.reloadData()
//    }
//    
//    func realmSaveCats(_ category: RealmCategory) {
//        do {
//            try realm.write {
//                realm.add(category)
//            }
//        } catch {
//            print("Error saving Realm Category data: \(error)")
//        }
//        tableView.reloadData()
//    }
}

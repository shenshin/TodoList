//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Ales Shenshin on 14/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var realmCatsResults: Results<RealmCategory>?
    
    //хранит ссылку на категорию, которая была выбрана при нажатии на ячейку table view
    var selectedCategory: RealmCategory?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realmLoadCats()
    }
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmCatsResults?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = realmCatsResults?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    // MARK: - Data manipulation methods
    
    func realmLoadCats(){
        realmCatsResults = realm.objects(RealmCategory.self)
        tableView.reloadData()
    }
    
    func realmSaveCats(_ category: RealmCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Realm Category data: \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text!.count > 0 {
                let category = RealmCategory()
                category.name = textField.text!
                self.realmSaveCats(category)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table view Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCategory = realmCatsResults?[indexPath.row]
        //выполнить переход в TodoList view controller со списком Item, соответствующим выбранной категории
        performSegue(withIdentifier: "TodoItems", sender: self)
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodoItems" {
            let todoListVC = segue.destination as! TodoListViewController
            todoListVC.selectedCategory = selectedCategory
        }
    }
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}

//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Ales Shenshin on 14/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var realmCatsResults: Results<RealmCategory>?
    
    //хранит ссылку на категорию, которая была выбрана при нажатии на ячейку table view
    var selectedCategory: RealmCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realmLoadCats() 
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.flatWhite()
    }
    
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmCatsResults?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = realmCatsResults?[indexPath.row].name ?? NSLocalizedString("No categories added yet", comment: "")
        if let table = realmCatsResults?[indexPath.row] {
            bgColour(table, cell)
        }
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
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.realmCatsResults?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error saving Realm Category data: \(error)")
            }
            //tableView.reloadData()
        }
    }
    
    // MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: NSLocalizedString("Add new category", comment: "hello world"), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Add", comment: ""), style: .default) { (action) in
            if textField.text!.count > 0 {
                let category = RealmCategory()
                category.name = textField.text!
                self.realmSaveCats(category)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = NSLocalizedString("Create new Category", comment: "")
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
}


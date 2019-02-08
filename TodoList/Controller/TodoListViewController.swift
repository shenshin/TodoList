//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Ales Shenshin on 09/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    
    var selectedCategory: RealmCategory? {
        didSet{
            loadItems()
        }
    }
    var realmItems: Results<RealmItem>?
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let navbar = navigationController?.navigationBar else {fatalError("Navigation bar is not accessible")}
        guard let bgColor = UIColor(hexString: selectedCategory?.colour) else {fatalError("Background colour can't be known")}
        navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: bgColor, returnFlat: true)]
        navbar.barTintColor = bgColor
        navbar.tintColor = ContrastColorOf(backgroundColor: bgColor, returnFlat: true)
        searchBar.barTintColor = bgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let orinalColour = UIColor(hexString: "1D9BF6") else {fatalError()}
        navigationController?.navigationBar.barTintColor = orinalColour
        //navigationController?.navigationBar.tintColor = UIColor.flatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.flatWhite()]
    }
    
    //MARK: - Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = realmItems?[indexPath.row] {
            //текст ячейки таблицы
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour).darken(byPercentage:CGFloat(indexPath.row) / CGFloat(realmItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: colour, returnFlat: true)
            }
            //отображать ли галочку в ячейке таблицы в зависимости от параметра done
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added yet"
        }
//        if let table = realmItems?[indexPath.row] {
//            bgColour(table, cell)
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmItems?.count ?? 1
    }
    
    //MARK: - Table view delagate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = realmItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving Item \"done\" status: ", error)
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
        }
        self.searchBar.resignFirstResponder()
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //выношу поле для ввода текста в UIAlertController в область видимости функции для доступности его внутри замыканий
        var textField = UITextField()
        
        //создание контроллера окна всплывающего предупреждения
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //то, что случится, когда пользователь нажмёт кнопку Add Item в окне контроллера предупреждения alert
            
            //добавить новый элемент в массив realmItems
            if textField.text!.count > 0 {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = RealmItem()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                            //self.realm.add(newItem)
                        }
                    } catch {
                        print("Error saving Realm Category data: \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        //добавляю поле ввода текста во всплывающее окно
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            //присваиваю внешней переменной ссылку на поле ввода текста
            textField = alertTextfield
        }
        alert.addAction(action)
        
        //вызов вьюконтроллера        
        present(alert, animated: true, completion: nil)
        
    }

    
    func loadItems(){
        realmItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.realmItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error saving Realm Category data: \(error)")
            }
        }
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        realmItems = realmItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
}

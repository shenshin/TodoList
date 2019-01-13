//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Ales Shenshin on 09/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //создаю контекст для CoreData (временное хранилище информации)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
    }
    
    //MARK: - Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        //текст ячейки таблицы
        cell.textLabel?.text = itemArray[indexPath.row].title
        //отобрать ли галочку в ячейке таблицы в зависимости от параметра done
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Table view delagate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //выношу поле для ввода текста в UIAlertController в область видимости функции для доступности его внутри замыканий
        var textField = UITextField()
        
        //создание контроллера окна всплывающего предупреждения
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //то, что случится, когда пользователь нажмёт кнопку Add Item в окне контроллера предупреждения alert
            //получаю доступ к обьекту класса AppDelegate, из него вынимаю ссылку на CoreData
            
            let newItem = Item(context: self.context)
            //добавить новый элемент в массив itemArray
            if textField.text!.count > 0 {
                newItem.title = textField.text!
                newItem.done = false
                self.itemArray.append(newItem)
            }
            //сохранить массив элементов во время выгрузки программы из памяти
            self.saveItems()
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
    
    private func saveItems(){
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    private func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(request)
    }

}

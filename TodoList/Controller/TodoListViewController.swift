//
//  ViewController.swift
//  TodoList
//
//  Created by Алесь Шеншин on 09/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemArray.append(Item(title: "Покормить Луну", done: false))
        itemArray.append(Item(title: "Выкормить ворона", done: false))
        itemArray.append(Item(title: "Спасти всех голодающих кошек", done: false))
        
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
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
        
        tableView.reloadData()
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //выношу поле для ввода текста в UIAlertController в область видимости функции для доступности его внутри замыканий
        var textField = UITextField()
        
        //создание контроллера окна всплывающего предупреждения
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //то, что случится, когда пользователь нажмёт кнопку Add Item в окне контроллера предупреждения alert
            
            //добавить новый элемент в массив itemArray
            self.itemArray.append(Item(title: textField.text!, done: false))
            //сохранить массив элементов во время выгрузки программы из памяти
            self.defaults.set(self.itemArray, forKey: "TodoListArray1")
            //обновить tableView
            self.tableView.reloadData()
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
    
    
}


//
//  ViewController.swift
//  TodoList
//
//  Created by Алесь Шеншин on 09/01/2019.
//  Copyright © 2019 Shenshin. All rights reserved.
//

import UIKit
//имя файла для сохранения массива элементов Item
let PATH_COMPONENT = "Items.plist"

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //создание файла хранения данных
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(PATH_COMPONENT)

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
            
            //добавить новый элемент в массив itemArray
            if textField.text!.count > 0 {
                self.itemArray.append(Item(title: textField.text!, done: false))
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
        // создаёт .plist файл и записывает в него содержимое массива itemArray
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath)
        } catch {
            print("Error encoding Item array: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    private func loadItems(){
        do {
            if let data = try? Data(contentsOf: dataFilePath) {
                let decoder = PropertyListDecoder()
                self.itemArray = try decoder.decode([Item].self, from: data)
            }
        } catch {
            print("Error decoding Item array: \(error.localizedDescription)")
        }
    }
    
}


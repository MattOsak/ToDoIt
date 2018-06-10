//
//  ViewController.swift
//  ToDoIt
//
//  Created by Matt Osak on 2018-05-16.
//  Copyright © 2018 Matt Osak. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController {
   
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }

  
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
    
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
      
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
            
           
            
        }
        
        // add a button
        alert.addTextField { (alertTextfield) in
                alertTextfield.placeholder = "Create new item"
                textField = alertTextfield
            }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems() {
    
        
        do {
          try context.save()
            
        } catch {
         print("Error saving Context\(error)")
        }
       
        tableView.reloadData()
  
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching dta from context \(error)")
        }
        
         tableView.reloadData()
    }
        
        

}

//MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

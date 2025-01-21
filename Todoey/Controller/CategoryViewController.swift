//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Miguel Angel Reyes Sánchez on 09/01/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonSwift

class CategoryViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist yet.")
        }
        navBar.backgroundColor = FlatNavyBlueDark().lighten(byPercentage: 0.45)
        navBar.tintColor = ContrastColorOf(navBar.backgroundColor!, returnFlat: true)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let categoryName = categories?[indexPath.row].name ?? "No Categories added yet"
        
        if let category = categories?[indexPath.row] {
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = categoryName
                
                guard let cellColor = UIColor(hexString: category.color) else {
                    fatalError("Could not load the cell color")
                }
                
                cell.backgroundColor = cellColor
                content.textProperties.color = ContrastColorOf(cellColor, returnFlat: true)
                
                cell.contentConfiguration = content
            } else {
                // Fallback on earlier versions
                cell.textLabel?.text = categoryName
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let category = categories?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(category)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
            }
            self.tableView.reloadData()
        }
    }

//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self](action, sourceView, completionHandler) in
//            if let deleteCategory = categories?[indexPath.row]{
//                do {
//                    try realm.write {
//                        realm.delete(deleteCategory)
//                        tableView.deleteRows(at: [indexPath], with: .automatic)
//                    }
//                } catch {
//                    fatalError("Faild to delete Category from Realm")
//                }
//                completionHandler(true)
//                tableView.reloadData()
//            }
//        }
//        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
//        return actions
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategories(){
        categories = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data from context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add List", style: .default) { UIAlertAction in
            if alertTextField.text != "" {
                let newCategory = Category()
                newCategory.name = alertTextField.text!
                newCategory.color = RandomFlatColorWithShade(.light).hexValue()
                
                self.save(category: newCategory)
                print("List added succesfully")
            }
        }
        
        alert.addTextField { UITextField in
            alertTextField = UITextField
            alertTextField.placeholder = "Name the new list"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
}

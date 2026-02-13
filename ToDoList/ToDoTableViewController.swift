//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Claude
//

import UIKit
import UserNotifications

class ToDoTableViewController: UITableViewController {
    
    // MARK: - Properties
    var todos: [ToDoItem] = []
    var filteredTodos: [ToDoItem] = []
    var isFiltering: Bool = false
    var selectedCategory: ToDoItem.Category?
    
    // Search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation
        title = "To-Do List"
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Setup search controller
        setupSearchController()
        
        // Setup notification permissions
        requestNotificationPermissions()
        
        // Load data
        loadToDos()
        
        // If no data, load sample data
        if todos.isEmpty {
            todos = ToDoItem.sampleData
            saveToDos()
        }
    }
    
    // MARK: - Setup Methods
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Add scope buttons for categories
        searchController.searchBar.scopeButtonTitles = ["All"] + ToDoItem.Category.allCases.map { "\($0.emoji) \($0.rawValue)" }
        searchController.searchBar.delegate = self
    }
    
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    // MARK: - Data Persistence
    func saveToDos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: "todos")
        }
    }
    
    func loadToDos() {
        if let savedData = UserDefaults.standard.data(forKey: "todos"),
           let decoded = try? JSONDecoder().decode([ToDoItem].self, from: savedData) {
            todos = decoded
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredTodos.count : todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let todo = isFiltering ? filteredTodos[indexPath.row] : todos[indexPath.row]
        
        // Configure cell
        var content = cell.defaultContentConfiguration()
        
        // Title with completion strike-through
        let titleAttributes: [NSAttributedString.Key: Any] = todo.isComplete ?
        [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.gray] :
        [:]
        content.attributedText = NSAttributedString(string: todo.title, attributes: titleAttributes)
        
        // Secondary text: category and due date
        var secondaryText = "\(todo.category.emoji) \(todo.category.rawValue)"
        if let dueDate = todo.dueDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            secondaryText += " • Due: \(formatter.string(from: dueDate))"
        }
        if todo.hasReminder {
            secondaryText += " 🔔"
        }
        content.secondaryText = secondaryText
        
        // Style based on status
        if todo.isOverdue {
            content.secondaryTextProperties.color = .systemRed
        } else if todo.isDueSoon {
            content.secondaryTextProperties.color = .systemOrange
        }
        
        cell.contentConfiguration = content
        
        // Checkmark for completed items
        cell.accessoryType = todo.isComplete ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let todo = isFiltering ? filteredTodos[indexPath.row] : todos[indexPath.row]
        performSegue(withIdentifier: "ShowDetail", sender: todo)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = isFiltering ? filteredTodos[indexPath.row] : todos[indexPath.row]
            
            // Remove from main array
            if let index = todos.firstIndex(of: todo) {
                todos.remove(at: index)
            }
            
            // Remove from filtered array if filtering
            if isFiltering {
                filteredTodos.remove(at: indexPath.row)
            }
            
            // Cancel notification if exists
            if todo.hasReminder {
                cancelNotification(for: todo)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveToDos()
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = isFiltering ? filteredTodos[indexPath.row] : todos[indexPath.row]
        
        // Toggle complete action
        let completeAction = UIContextualAction(style: .normal, title: todo.isComplete ? "Incomplete" : "Complete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            // Find in main array and update
            if let index = self.todos.firstIndex(of: todo) {
                self.todos[index].isComplete.toggle()
                
                // Update filtered array if filtering
                if self.isFiltering, let filteredIndex = self.filteredTodos.firstIndex(of: todo) {
                    self.filteredTodos[filteredIndex].isComplete.toggle()
                }
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.saveToDos()
            }
            
            completionHandler(true)
        }
        
        completeAction.backgroundColor = todo.isComplete ? .systemOrange : .systemGreen
        completeAction.image = UIImage(systemName: todo.isComplete ? "arrow.uturn.backward" : "checkmark")
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = isFiltering ? filteredTodos[indexPath.row] : todos[indexPath.row]
        
        // Share action
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] (action, view, completionHandler) in
            self?.shareItem(todo)
            completionHandler(true)
        }
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            // Remove from main array
            if let index = self.todos.firstIndex(of: todo) {
                self.todos.remove(at: index)
            }
            
            // Remove from filtered array
            if self.isFiltering {
                self.filteredTodos.remove(at: indexPath.row)
            }
            
            // Cancel notification
            if todo.hasReminder {
                self.cancelNotification(for: todo)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveToDos()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    // MARK: - Share Functionality
    func shareItem(_ item: ToDoItem) {
        var text = "📋 \(item.title)"
        
        if let notes = item.notes {
            text += "\n\n\(notes)"
        }
        
        if let dueDate = item.dueDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            text += "\n\nDue: \(formatter.string(from: dueDate))"
        }
        
        text += "\n\nCategory: \(item.category.emoji) \(item.category.rawValue)"
        text += "\nStatus: \(item.isComplete ? "✅ Complete" : "⏳ Pending")"
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        // For iPad
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(activityVC, animated: true)
    }
    
    // MARK: - Notifications
    func scheduleNotification(for item: ToDoItem) {
        guard let dueDate = item.dueDate, item.hasReminder else { return }
        
        // Cancel existing notification
        cancelNotification(for: item)
        
        let content = UNMutableNotificationContent()
        content.title = "To-Do Reminder"
        content.body = item.title
        content.sound = .default
        content.badge = 1
        
        // Schedule for 9 AM on due date
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: dueDate)
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelNotification(for item: ToDoItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }
    
    // MARK: - Navigation
    @IBAction func unwindToToDoList(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceVC = unwindSegue.source as? ToDoDetailTableViewController,
              let todo = sourceVC.todo else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Update existing item
            todos[selectedIndexPath.row] = todo
            
            // Update filtered array if filtering
            if isFiltering {
                if let filteredIndex = filteredTodos.firstIndex(where: { $0.id == todo.id }) {
                    filteredTodos[filteredIndex] = todo
                }
            }
            
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            // Add new item
            todos.append(todo)
            
            let newIndexPath = IndexPath(row: todos.count - 1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        // Schedule notification if needed
        if todo.hasReminder && todo.dueDate != nil {
            scheduleNotification(for: todo)
        } else {
            cancelNotification(for: todo)
        }
        
        saveToDos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let navController = segue.destination as! UINavigationController
            let detailVC = navController.topViewController as! ToDoDetailTableViewController
            
            if let todo = sender as? ToDoItem {
                detailVC.todo = todo
            }
        }
    }
}
// MARK: - Search Results Updating
extension ToDoTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text ?? ""
        let selectedScope = searchBar.selectedScopeButtonIndex
        
        filterContentForSearchText(searchText, category: selectedScope)
    }
    
    func filterContentForSearchText(_ searchText: String, category: Int) {
        // Determine category filter
        var categoryFilter: ToDoItem.Category?
        if category > 0 {
            categoryFilter = ToDoItem.Category.allCases[category - 1]
        }
        
        filteredTodos = todos.filter { todo in
            // Category filter
            let categoryMatch = categoryFilter == nil || todo.category == categoryFilter
            
            // Search text filter
            let searchMatch = searchText.isEmpty || todo.title.lowercased().contains(searchText.lowercased()) ||
                             (todo.notes?.lowercased().contains(searchText.lowercased()) ?? false)
            
            return categoryMatch && searchMatch
        }
        
        isFiltering = !searchText.isEmpty || category > 0
        tableView.reloadData()
    }
}

// MARK: - Search Bar Delegate
extension ToDoTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text ?? "", category: selectedScope)
    }
}

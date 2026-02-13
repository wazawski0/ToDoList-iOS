//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Claude
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Properties
    var todo: ToDoItem?
    var isPickerHidden = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure date picker
        dueDatePicker.minimumDate = Date()
        dueDatePicker.date = Date()
        
        // Setup notes text view
        notesTextView.layer.borderColor = UIColor.systemGray5.cgColor
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.cornerRadius = 8
        
        // Load existing todo if editing
        if let todo = todo {
            navigationItem.title = "Edit Task"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            updateCompleteButton()
            
            if let dueDate = todo.dueDate {
                dueDatePicker.date = dueDate
                updateDueDateLabel(date: dueDate)
            } else {
                updateDueDateLabel(date: nil)
            }
            
            notesTextView.text = todo.notes
            
            // Set category
            if let index = ToDoItem.Category.allCases.firstIndex(of: todo.category) {
                categorySegmentedControl.selectedSegmentIndex = index
            }
            
            reminderSwitch.isOn = todo.hasReminder
        } else {
            navigationItem.title = "New Task"
            updateDueDateLabel(date: nil)
        }
        
        updateSaveButtonState()
        
        notesTextView.isEditable = true
            notesTextView.isSelectable = true
            notesTextView.isUserInteractionEnabled = true
            notesTextView.isScrollEnabled = true
            
            // Add border for visual feedback (optional)
            notesTextView.layer.borderColor = UIColor.systemGray5.cgColor
            notesTextView.layer.borderWidth = 1
            notesTextView.layer.cornerRadius = 8
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Date picker row
        if indexPath.section == 1 && indexPath.row == 1 {
                return isPickerHidden ? 0 : 320
            }
            return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Toggle date picker visibility when tapping due date row
        if indexPath.section == 1 && indexPath.row == 0 {
            isPickerHidden.toggle()
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        // Don't highlight the notes row (Section 2, Row 1)
        if indexPath.section == 2 && indexPath.row == 1 {
            return false
        }
        return true
    }
    
    // MARK: - Actions
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateCompleteButton()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Save is handled by unwind segue
    }
    
    // MARK: - Helper Methods
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func updateCompleteButton() {
        let buttonTitle = isCompleteButton.isSelected ? "Complete" : "Incomplete"
        isCompleteButton.setTitle(buttonTitle, for: .normal)
        
        let buttonColor: UIColor = isCompleteButton.isSelected ? .systemGreen : .systemGray
        isCompleteButton.backgroundColor = buttonColor
        isCompleteButton.setTitleColor(.white, for: .normal)
    }
    
    func updateDueDateLabel(date: Date?) {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            dueDateLabel.text = formatter.string(from: date)
        } else {
            dueDateLabel.text = "No due date"
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwind" else { return }
        
        let title = titleTextField.text ?? ""
        let isComplete = isCompleteButton.isSelected
        let dueDate = isPickerHidden ? nil : dueDatePicker.date
        let notes = notesTextView.text.isEmpty ? nil : notesTextView.text
        let categoryIndex = categorySegmentedControl.selectedSegmentIndex
        let category = ToDoItem.Category.allCases[categoryIndex]
        let hasReminder = reminderSwitch.isOn
        
        if var existingTodo = todo {
            // Update existing todo
            existingTodo.title = title
            existingTodo.isComplete = isComplete
            existingTodo.dueDate = dueDate
            existingTodo.notes = notes
            existingTodo.category = category
            existingTodo.hasReminder = hasReminder
            
            todo = existingTodo
        } else {
            // Create new todo
            todo = ToDoItem(
                title: title,
                isComplete: isComplete,
                dueDate: dueDate,
                notes: notes,
                category: category,
                hasReminder: hasReminder
            )
        }
    }
}

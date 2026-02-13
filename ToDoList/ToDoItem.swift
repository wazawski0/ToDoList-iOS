//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Claude
//

import Foundation

struct ToDoItem: Codable, Equatable {
    var id: UUID
    var title: String
    var isComplete: Bool
    var dueDate: Date?
    var notes: String?
    var category: Category
    var hasReminder: Bool
    
    init(title: String, isComplete: Bool = false, dueDate: Date? = nil, notes: String? = nil, category: Category = .personal, hasReminder: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.category = category
        self.hasReminder = hasReminder
    }
    
    enum Category: String, Codable, CaseIterable {
        case work = "Work"
        case personal = "Personal"
        case shopping = "Shopping"
        case health = "Health"
        case other = "Other"
        
        var emoji: String {
            switch self {
            case .work: return "💼"
            case .personal: return "👤"
            case .shopping: return "🛒"
            case .health: return "💪"
            case .other: return "📝"
            }
        }
        
        var color: String {
            switch self {
            case .work: return "systemBlue"
            case .personal: return "systemGreen"
            case .shopping: return "systemOrange"
            case .health: return "systemRed"
            case .other: return "systemGray"
            }
        }
    }
    
    var isOverdue: Bool {
        guard let dueDate = dueDate else { return false }
        return dueDate < Date() && !isComplete
    }
    
    var isDueSoon: Bool {
        guard let dueDate = dueDate else { return false }
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return dueDate < tomorrow && dueDate > Date() && !isComplete
    }
    
    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Sample Data
extension ToDoItem {
    static let sampleData: [ToDoItem] = [
        ToDoItem(
            title: "Complete iOS assignment",
            isComplete: false,
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            notes: "Finish both guided projects and stretch goals",
            category: .work,
            hasReminder: true
        ),
        ToDoItem(
            title: "Buy groceries",
            isComplete: false,
            dueDate: Calendar.current.date(byAdding: .day, value: 0, to: Date()),
            notes: "Milk, eggs, bread, vegetables",
            category: .shopping,
            hasReminder: false
        ),
        ToDoItem(
            title: "Morning workout",
            isComplete: true,
            dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            notes: "30 min cardio + stretching",
            category: .health,
            hasReminder: true
        ),
        ToDoItem(
            title: "Call dentist",
            isComplete: false,
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            notes: "Schedule checkup appointment",
            category: .personal,
            hasReminder: true
        ),
        ToDoItem(
            title: "Review project documentation",
            isComplete: false,
            dueDate: nil,
            notes: "Go through all README files",
            category: .work,
            hasReminder: false
        )
    ]
}

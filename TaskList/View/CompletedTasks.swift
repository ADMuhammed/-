//
//  CompletedTasks.swift
//  TaskList
//
//  Created by Muhammed on 31.05.2023.
//
import SwiftUI
import CoreData

struct CompletedTasks: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [])
    var tasks: FetchedResults<Task>
    
    enum SortOption {
        case none
        case alphabetical
        case date
        case priority
    }
    
    @State private var sortOption: SortOption = .none
    @State private var isSortingOptionsPresented = false
    @State private var searchText = ""
    @State private var selectedTask: Task? = nil
    @State private var isTaskDetailPresented = false
    
    var sortedTasks: [Task] {
        switch sortOption {
        case .alphabetical:
            return Array(tasks.sorted { $0.title?.localizedCaseInsensitiveCompare($1.title ?? "") == .orderedAscending })
        case .date:
            return Array(tasks.sorted { $0.createdAt ?? Date() < $1.createdAt ?? Date() })
        case .priority:
            return Array(tasks.sorted { task1, task2 in
                let priority1 = TaskPriority(rawValue: task1.priority ?? "") ?? .low
                let priority2 = TaskPriority(rawValue: task2.priority ?? "") ?? .low
                
                if priority1 == .high && priority2 != .high {
                    return true
                } else if priority1 == .medium && priority2 != .high && priority2 != .medium {
                    return true
                } else {
                    return false
                }
            })
        case .none:
            return Array(tasks)
        }
    }
    
    var filteredTasks: [Task] {
        if searchText.isEmpty {
            return sortedTasks
        } else {
            return sortedTasks.filter { task in
                task.title?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isSortingOptionsPresented = true
                    }) {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .font(.title)
                    }
                    .padding()
                    .actionSheet(isPresented: $isSortingOptionsPresented) {
                        ActionSheet(
                            title: Text("Sorted by"),
                            buttons: [
                                .default(Text("Date")) { sortOption = .date },
                                .default(Text("Alphabet")) { sortOption = .alphabetical },
                                .default(Text("Priority")) { sortOption = .priority },
                                .cancel()
                            ]
                        )
                    }
                }
                
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
                
                List {
                    ForEach(filteredTasks, id: \.self) { task in
                        Button(action: {
                            selectedTask = task
                            isTaskDetailPresented = true
                        }) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(task.title ?? "")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundColor(.blue)
                                    )
                                
                                HStack {
                                    priorityIcon(for: task)
                                        .foregroundColor(priorityColor(for: task))
                                }
                                .font(.caption)
                                .padding(.bottom, 4)
                                
                                if let createdAt = task.createdAt {
                                    Text(dateFormatter.string(from: createdAt))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete(perform: deleteTasks)
                }
                .listStyle(PlainListStyle())
                .background(Color.white)
            }
            .background(Color.gray.opacity(0.1))
            .navigationBarTitle("CompletedTasks")
            .sheet(item: $selectedTask) { task in
                TaskDetailView(task: task)
            }
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    func deleteTasks(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = filteredTasks[index]
            managedObjectContext.delete(task)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Ошибка удаления задач: \(error.localizedDescription)")
        }
    }
    
    func priorityColor(for task: Task) -> Color {
        guard let priorityString = task.priority,
              let priority = TaskPriority(rawValue: priorityString) else {
            return .black
        }
        
        switch priority {
        case .high:
            return .red
        case .medium:
            return .yellow
        case .low:
            return .green
        }
    }
    
    func priorityIcon(for task: Task) -> some View {
        guard let priorityString = task.priority,
              let priority = TaskPriority(rawValue: priorityString) else {
            return Image(systemName: "exclamationmark.circle")
        }
        
        switch priority {
        case .high:
            return Image(systemName: "exclamationmark.circle.fill")
        case .medium:
            return Image(systemName: "exclamationmark.triangle.fill")
        case .low:
            return Image(systemName: "exclamationmark.square.fill")
        }
    }
}

struct CompletedTasks_Previews: PreviewProvider {
    static var previews: some View {
        CompletedTasks()
    }
}

struct TaskDetailView: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(task.title ?? "")
                .font(.title)
                .foregroundColor(.black)
            
            HStack {
                priorityIcon(for: task)
                    .foregroundColor(priorityColor(for: task))
                
                Text(task.priority ?? "")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            Text("Date of creation:")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(dateFormatter.string(from: task.createdAt ?? Date()))
                .font(.subheadline)
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Task details", displayMode: .inline)
    }
    //
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    func priorityColor(for task: Task) -> Color {
        guard let priorityString = task.priority,
              let priority = TaskPriority(rawValue: priorityString) else {
            return .black
        }
        
        switch priority {
        case .high:
            return .red
        case .medium:
            return .yellow
        case .low:
            return .green
        }
    }
    
    func priorityIcon(for task: Task) -> Image {
        guard let priorityString = task.priority,
              let priority = TaskPriority(rawValue: priorityString) else {
            return Image(systemName: "exclamationmark.circle")
        }
        
        switch priority {
        case .high:
            return Image(systemName: "exclamationmark.circle.fill")
        case .medium:
            return Image(systemName: "exclamationmark.triangle.fill")
        case .low:
            return Image(systemName: "exclamationmark.square.fill")
        }
    }
}





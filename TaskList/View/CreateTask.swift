//
//  TaskAtWork.swift
//  TaskList
//
//  Created by Muhammed on 29.05.2023.
//
import SwiftUI
import CoreData

enum TaskPriority: String, CaseIterable {
    case high = "high"
    case medium = "medium"
    case low = "low"
    
    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .yellow
        case .low:
            return .green
        }
    }
}

struct CreateTask: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var taskText = ""
    @State private var taskPriority: TaskPriority = .medium
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create A New Task")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            
            TextField("New Task", text: $taskText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Priorities")
                .font(.title2)
                .foregroundColor(.black)
                .padding(.bottom, 10)
            
            Picker("Priority", selection: $taskPriority) {
                ForEach(TaskPriority.allCases, id: \.self) { priority in
                    Text(priority.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Button(action: {
                saveTask()
            }) {
                Text("Create Task")
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [taskPriority.color.opacity(0.8), taskPriority.color.opacity(0.4)]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 4, x: 0, y: 2)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("New Task", displayMode: .inline)
    }
    
    func saveTask() {
        let newTask = Task(context: managedObjectContext)
        newTask.title = taskText
        newTask.completed = false
        newTask.createdAt = Date()
        newTask.priority = taskPriority.rawValue
        
        do {
            try managedObjectContext.save()
            taskText = ""
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
}

struct CreateTask_Previews: PreviewProvider {
    static var previews: some View {
        CreateTask()
    }
}





//данный код представляет пользовательский интерфейс для создания новой задачи.

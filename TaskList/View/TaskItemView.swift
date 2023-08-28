//
//  TaskItemView.swift
//  TaskList
//
//  Created by Muhammed on 16.06.2023.
//

import SwiftUI

struct TaskItemView: View {
    var task: Task
    @State private var onHover = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.list ?? "")
                    .font(.headline)
                    .foregroundColor(.black)
                Text(task.createdAt?.formattedDateString() ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .shadow(color: .gray, radius: 4, x: 0, y: 2)
        .animation(.spring())
        .onHover { hover in
            onHover = hover
        }//
    }
}

//данный код определяет представление для отдельной задачи (Task). Он отображает заголовок задачи и дату создания в виде текстовых представлений, которые настраиваются на основе свойств задачи

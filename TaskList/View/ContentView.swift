//
//  ContentView.swift
//  TaskList
//
//  Created by Muhammed on 16.06.2023.
//

//
//  ContentView.swift
//  TaskList
//
//  Created by Muhammed on 23.05.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var showingCreateTask = false
    @State private var showingCompletedTasks = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    self.showingCreateTask.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                        .frame(width: 120, height: 120)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                }
                .sheet(isPresented: self.$showingCreateTask, content: { CreateTask() })
                
                Divider()
                
                Button(action: {
                    self.showingCompletedTasks.toggle()
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .frame(width: 120, height: 120)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                }
                .sheet(isPresented: self.$showingCompletedTasks, content: { CompletedTasks() })
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("TaskListApp", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    //
                }) {
                    Text("Sup")
                        .foregroundColor(.blue)
                },
                trailing:
                Button(action: {
                    //
                }) {
                    Text("Suggestions")
                        .foregroundColor(.blue)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//slss

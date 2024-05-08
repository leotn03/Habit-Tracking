//
//  HabitView.swift
//  Habit-tracking
//
//  Created by Leo Torres Neyra on 21/1/24.
//

import SwiftUI

struct HabitView: View {
    @State private var description : String = "I chase the sun"
    @State private var showEditDescription = false
    
    var habit: Activity
    
    init(habit: Activity) {
        self.habit = habit
        self.description = habit.description
    }
    
    mutating func changeDescription() {
        habit.description = description
    }
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("MintPixel"), Color("GoldenYellow")], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack {
                    Text(habit.description)
                        .monospaced()
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(10)
                
            }
            .navigationTitle(habit.name)
            .toolbar {
                ToolbarItem {
                    Button {
                        showEditDescription = true
                    } label: {
                        Text("Edit")
                            .withToolbarTextStyle()
                    }
                }
            }
            .alert("Edit your description", isPresented: $showEditDescription) {
                
                TextField("Description", text: $description)
                
                
                
                Button("OK") {
                    //changeDescription()
                }
            }
            
        }
        
        
    }
}

#Preview {
    let habit = Activity(name: "Sing", description: "Sing something")
    
    return HabitView(habit: habit)
}

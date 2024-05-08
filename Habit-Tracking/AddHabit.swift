//
//  AddHabit.swift
//  Habit-tracking
//
//  Created by Leo Torres Neyra on 20/1/24.
//

import SwiftUI

struct AddHabit: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var showingAlert = false
    
    var habits: Data
    
    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(colors: [Color("MintPixel"), Color("GoldenYellow")], startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        TextField("Title: ", text: $name)
                            .textFieldStyle(.automatic)
                            .padding()
                        
                        
                        
                        TextField("Description", text: $description, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                        /**Limita las lineas a expandir al numero especificado, y reserveSpace reserva las lineas a mostrar **/
                            .lineLimit(5, reservesSpace: true)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Add Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !name.isEmpty && !description.isEmpty {
                            let habit = Activity(name: name, description: description)
                            habits.activities.append(habit)
                            dismiss()
                        }else {
                            showingAlert = true
                        }
                    }
                    .withToolbarTextStyle()
                }
                
                ToolbarItem (placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .withToolbarTextStyle()
                }
                
            }
            
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("ERROR 🤪"), message: Text("You need to fill the name and desription fields, buuudyyyyy"))
        }
    }
}

#Preview {
    AddHabit(habits: Data())
}

//
//  ContentView.swift
//  Habit-tracking
//
//  Created by Leo Torres Neyra on 20/1/24.
//

import SwiftUI

@Observable
class Data {
    var activities = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let savedActivities = UserDefaults.standard.data(forKey: "Activities") {
            if let decodedActivities = try? JSONDecoder().decode([Activity].self, from: savedActivities) {
                activities = decodedActivities
                return
            }
        }
        
        activities = []
    }
    
    func addCount (activity: Activity) {
        var copy = activity
        
        if let index = self.activities.firstIndex(where: {
            $0.id == activity.id}) {
            copy.count += 1
            self.activities[index] = copy
        } else {
            self.activities.append(activity)
        }
    }
    
    func isChecked (activity: Activity) -> Bool{
        var copy = activity
        
        return copy.isChecked
        
    }
}

struct ToolbarTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color("DarkGreenText"))
            .accentColor(Color("DarkGreenText"))
    }
}

struct BackButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accentColor(Color("DarkGreenText"))
    }
}

extension View {
    func withToolbarTextStyle() -> some View {
        modifier(ToolbarTextStyle())
    }
    
    func withBackButtonStyle() -> some View {
        modifier(BackButtonStyle())
    }
}

struct ContentView: View {
    @State private var data = Data()
    @State private var showingAddHabit = false
    @State private var isChecked = false
    
    func checkbox(for state: Bool) -> Image {
        return state ? Image(systemName: "checkmark.circle") : Image(systemName: "circle")
    }
    
    func removeHabits(at offsets: IndexSet) {
        data.activities.remove(atOffsets: offsets)
    }
    
    func moveHabits(from source: IndexSet, to destination: Int) {
        self.data.activities.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("MintPixel"), Color("GoldenYellow")], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            
            NavigationStack {
                List {
                    ForEach (data.activities) { activity in
                        HStack {
                            self.checkbox(for: isChecked).onTapGesture {
                                isChecked.toggle()
                                
                                data.addCount(activity: activity)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 15)
                            
                            NavigationLink (value: activity) {
                                HStack {
                                    VStack (alignment: .leading) {
                                        Text(activity.name)
                                            .padding(.vertical, 2)
                                            .font(.headline)
                                        
                                        Text(activity.description)
                                            .lineLimit(1)
                                            .font(.subheadline)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(activity.count)")
                                        .padding(.horizontal, 12)
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .navigationDestination(for: Activity.self) { activity in
                                HabitView(habit: activity)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                        /** Elimina los separadores entre las filas de los items*/
                        .listRowSeparator(.hidden)
                        
                    }
                    .onMove(perform: moveHabits)
                    .onDelete(perform: removeHabits)
                    
                }
                .navigationTitle("Habit-Tracking")
                .toolbar {
                    ToolbarItem {
                        Button {
                            showingAddHabit = true
                        } label: {
                            Image(systemName: "plus")
                                .withToolbarTextStyle()
                        }
                    }
                    
                    ToolbarItem {
                        EditButton()
                            .withToolbarTextStyle()
                    }
                }
                .sheet(isPresented: $showingAddHabit) {
                    AddHabit(habits: data)
                }
                .scrollContentBackground(.hidden)
                .background(LinearGradient(colors: [Color("MintPixel"), Color("GoldenYellow")], startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea())
                .listStyle(.plain)
            }
        }
        .withBackButtonStyle()
    }
}

#Preview {
    ContentView()
}

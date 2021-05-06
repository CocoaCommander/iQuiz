//
//  ContentView.swift
//  iQuiz
//
//  Created by Ryan Lee on 5/5/21.
//

import SwiftUI

//var image: String = "function"
//var subject: String = "Mathematics"
//var description: String = "Contains quizzes for Mathematics grades K-12"

struct quizItem: Identifiable {
    var id = UUID()
    var image: String
    var subject: String
    var description: String
    var questions: [String] = []
}



struct ContentView: View {
    
    @State var showAlert = false
    
    var allQuizzes: [quizItem] = [
        quizItem(image: "function", subject: "Mathematics", description: "Contains quizzes for Mathematics grades K-12"),
        quizItem(image: "m.circle", subject: "Marvel Super Heroes", description: "Contains quizzes about Marvel Super Heroes"),
        quizItem(image: "bolt.circle", subject: "Science", description: "Contains quizzes about Science grades K-12")
    ]
    
    var body: some View {
        VStack {
            NavigationView {
                List(allQuizzes) { quiz in
                    TableCell(quizItem: quiz)
                }
                .navigationTitle("SwiftUI")
                .toolbar {
                    ToolbarItem {
                        Button("Settings") {
                            self.showAlert.toggle()
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Not Implemented"),
                                message: Text("Settings go here")
                            )
                        }
                    }
                }
            }
        }
    }
}

struct TableCell: View {
    
    let quizItem: quizItem
    
    var body: some View {
        HStack(spacing: 50) {
            Image(systemName: quizItem.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                Text(quizItem.subject)
                    .bold()
                Text(quizItem.description)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

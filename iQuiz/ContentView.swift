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
    var questions: [question] = []
}

struct question {
    var questionText: String
    var answers: [String]
    var correctAnswer: String
}

struct ContentView: View {
    
    @State var showAlert = false
    
    var allQuizzes: [quizItem] = [
        quizItem(
            image: "function",
            subject: "Mathematics",
            description: "Contains quizzes for Mathematics grades K-12",
            questions: [
                question(
                    questionText: "What is 2 + 2?",
                    answers: [
                        "1",
                        "2",
                        "3",
                        "4"
                    ],
                    correctAnswer: "4"
                ),
                question(
                    questionText: "What is 4 - 2?",
                    answers: [
                        "1",
                        "2",
                        "3",
                        "4"
                    ],
                    correctAnswer: "2"
                ),
                question(
                    questionText: "What is 3 * 1?",
                    answers: [
                        "1",
                        "2",
                        "3",
                        "4"
                    ],
                    correctAnswer: "3"
                )
            ]
        ),
        quizItem(
            image: "m.circle",
            subject: "Marvel Super Heroes",
            description: "Contains quizzes about Marvel Super Heroes",
            questions: [
                question(
                    questionText: "Who is Iron Man's identity?",
                    answers: [
                        "Tony Stark",
                        "Peter Parker",
                        "Bruce Wayne",
                        "Sheldon Cooper"                    ],
                    correctAnswer: "Tony Stark"
                ),
                question(
                    questionText: "What proportion of the universe did Thanos kill?",
                    answers: [
                        "1/2",
                        "2/3",
                        "3/7",
                        "4/9"
                    ],
                    correctAnswer: "1/2"
                ),
                question(
                    questionText: "Fill in the blank: Captain _______",
                    answers: [
                        "America",
                        "Planet",
                        "Crunch",
                        "Kirk"
                    ],
                    correctAnswer: "America"
                )
            ]
        ),
        quizItem(
            image: "bolt.circle",
            subject: "Science",
            description: "Contains quizzes about Science grades K-12",
            questions: [
                question(
                    questionText: "Mitochondria?",
                    answers: [
                        "The powerhouse of the cell.",
                        "A debugging method",
                        "32nd element on the periodic table.",
                        "What stars are made of."
                    ],
                    correctAnswer: "The powerhouse of the cell"
                ),
                question(
                    questionText: "What is the boiling point of water?",
                    answers: [
                        "100 C",
                        "200 C",
                        "300 C",
                        "400 C"
                    ],
                    correctAnswer: "100 C"
                ),
                question(
                    questionText: "Force = Mass * ____________",
                    answers: [
                        "Acceleration",
                        "Inertia",
                        "Energy",
                        "Speed of light"
                    ],
                    correctAnswer: "Acceleration"
                )
            ]
        )
    ]
    
    var body: some View {
        VStack {
            NavigationView {
                List(allQuizzes) { quiz in
                    NavigationLink(
                        destination: QuestionView()
                    ) {
                        TopicCell(quizItem: quiz)
                    }
                }
                .navigationTitle("iQuiz")
                .toolbar {
                    ToolbarItem {
                        Button("Settings") {
                            self.showAlert.toggle()
                            print("\($showAlert)")
                        }
                    }
                }
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Not Implemented"),
                message: Text("Settings go here")
            )
        }
    }
}

struct TopicCell: View {
    
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

struct QuestionView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Text()
                
                Picker("Answers:", selection: ) {
                    ForEach() {
                        Text()
                    }
                }
                Text("Selected answer: ")
                NavigationLink() {
                    Text("submit")
                }
            }
        }
    }
}

struct AnswerView: View {
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack {
                Text("Wrong answer, \n actual answer was abc.")
                Button("Next") {
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

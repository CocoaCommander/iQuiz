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
                    correctAnswer: "The powerhouse of the cell."
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
                        destination: QuestionView(
                            allQuestions: quiz.questions,
                            index: 0,
                            currQuestion: quiz.questions[0].questionText,
                            currAnswers: quiz.questions[0].answers,
                            selectedAnswer: quiz.questions[0].answers[0],
                            correctAnswer: quiz.questions[0].correctAnswer,
                            numCorrect: 0,
                            totalQuestions: quiz.questions.count
                        )
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
    
    var allQuestions: [question]
    @State var index: Int
    var currQuestion: String
    var currAnswers: [String]
    @State var selectedAnswer: String
    var correctAnswer: String
    @State var numCorrect: Int
    var totalQuestions: Int
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Question \(index + 1) of \(totalQuestions)").padding()
                Text(self.currQuestion)
                Picker("Answers:", selection: $selectedAnswer) {
                    ForEach(currAnswers, id: \.self) {
                        Text($0)
                    }
                }
                NavigationLink(
                    destination: AnswerView(
                        allQuestions: allQuestions,
                        index: $index,
                        currQuestion: currQuestion,
                        currAnswers: currAnswers,
                        selectedAnswer: selectedAnswer,
                        correctAnswer: correctAnswer,
                        numCorrect: $numCorrect,
                        totalQuestions: totalQuestions
                ).navigationBarHidden(true)
                ) {
                    Text("Submit")
                }
            }
        }
    }
}

struct AnswerView: View {
    
    var allQuestions: [question]
    @Binding var index: Int
    var currQuestion: String
    var currAnswers: [String]
    var selectedAnswer: String
    var correctAnswer: String
    @Binding var numCorrect: Int
    var totalQuestions: Int
    @State var userIsCorrect = false
    
    func updateSelf(expectedAnswer expected: String, receivedAnswer received: String) -> Void {
        if (expected == received) {
            numCorrect += 1
        }
        index += 1
        self.userIsCorrect = expected == received
    }
    
    @ViewBuilder
    var body: some View {
        if index < totalQuestions {
            NavigationView {
                VStack {
                    Text(currQuestion).bold().padding()
                    Text(self.userIsCorrect ? "You got it right!" : "You got it wrong...")
                    Text("Score: \(numCorrect)")
                    Text("\(totalQuestions - index) more questions.")
                    NavigationLink(
                        destination: QuestionView(
                            allQuestions: allQuestions,
                            index: index,
                            currQuestion: allQuestions[index].questionText,
                            currAnswers: allQuestions[index].answers,
                            selectedAnswer: allQuestions[index].answers[0],
                            correctAnswer: allQuestions[index].correctAnswer,
                            numCorrect: numCorrect,
                            totalQuestions: totalQuestions
                        ).navigationBarHidden(true)
                    ) {
                        Text("Next")
                    }
                }
            }.onAppear {
                self.updateSelf(
                    expectedAnswer: self.correctAnswer,
                    receivedAnswer: self.selectedAnswer
                )
            }
        } else {
            NavigationView {
                VStack {
                    Text(currQuestion).bold().padding()
                    Text(self.userIsCorrect ? "You got it right!" : "You got it wrong...")
                    Text("Score: \(numCorrect)")
                    Text("You have completed the quiz.")
                    NavigationLink(
                        destination: FinishView(numCorrect: numCorrect, totalQuestions: totalQuestions
                        ).navigationBarHidden(true)
                    ) {
                        Text("Finish")
                    }
                }
            }
        }
    }
}

struct FinishView: View {
    
    var numCorrect: Int
    var totalQuestions: Int
    
    var body: some View {
        VStack {
            Text("You've finished the quiz.")
            Text("You got \(numCorrect) out of \(totalQuestions) right\(numCorrect < totalQuestions ? "..." : "!")")
            Text("\(numCorrect < totalQuestions ? "You didn't get all of them right; Better luck next time..." : "You got them all right! Congratulations!")")
            Text("Tap iQuiz to return to the home screen.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

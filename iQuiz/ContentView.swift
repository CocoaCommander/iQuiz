//
//  ContentView.swift
//  iQuiz
//
//  Created by Ryan Lee on 5/5/21.
//

import SwiftUI

struct Category: Codable {
    var title: String
    var desc: String
    var questions: [Question]
}

struct Question: Codable {
    var text: String
    var answer: String
    var answers: [String]
}

struct ContentView: View {
    
    @State var showAlert = false
    @State var allQuizzes: [Category] = [
        Category(
            title: "Default",
            desc: "Default",
            questions: [
                Question(
                    text: "Default",
                    answer: "Default",
                    answers: ["default"]
                )
            ]
        )
    ]
    
    var images: [String: String] = [
        "Science!": "bolt.circle",
        "Marvel Super Heroes": "m.circle",
        "Mathematics": "function",
        "Default": "function"
    ]
    
    
    var body: some View {
        VStack {
            NavigationView {
                List(self.allQuizzes, id: \.title) { category in
                    NavigationLink(
                        destination:
                            QuestionView(
                                allQuestions: category.questions,
                                index: 0,
                                currQuestion: category.questions[0].text,
                                currAnswers: category.questions[0].answers,
                                selectedAnswer: category.questions[0].answers[0],
                                correctAnswer: category.questions[0].answer,
                                numCorrect: 0,
                                totalQuestions: category.questions.count
                            )
                        ) {
                        TopicCell(quizItem: category, images: images)
                        }
                }.onAppear {
                    loadData()
                }.navigationTitle("iQuiz").toolbar {
                    ToolbarItem {
                        Button("Settings") {
                            self.showAlert = !self.showAlert
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Not Implemented"),
                message: Text("Settings go here")
            )
        }
    }
}

extension ContentView {
    func loadData() -> Void {
        guard let url = URL(string: "https://tednewardsandbox.site44.com/questions.json") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Category].self, from: data)
                    DispatchQueue.main.async {
                        self.allQuizzes = decodedResponse
                    }
                } catch DecodingError.keyNotFound(let key, let context) {
                    Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(let context) {
                    Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                } catch let error as NSError {
                    Swift.print("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

struct TopicCell: View {
    
    let quizItem: Category
    let images: [String: String]
    
    var body: some View {
        HStack(spacing: 50) {
            Image(systemName: images[quizItem.title]!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                Text(quizItem.title)
                    .bold()
                Text(quizItem.desc)
            }
        }
        .padding()
    }
}

struct QuestionView: View {
    
    var allQuestions: [Question]
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
                    destination:
                        AnswerView(
                            allQuestions: allQuestions,
                            index: $index,
                            currQuestion: currQuestion,
                            currAnswers: currAnswers,
                            numCorrect: $numCorrect,
                            totalQuestions: totalQuestions,
                            userIsCorrect: (selectedAnswer == currAnswers[Int(correctAnswer)! - 1])
                )
                        .navigationBarHidden(true)
                ) {
                    Text("Submit")
                }
            }
        }
    }
}

struct AnswerView: View {
    
    var allQuestions: [Question]
    @Binding var index: Int
    var currQuestion: String
    var currAnswers: [String]
    @Binding var numCorrect: Int
    var totalQuestions: Int
    var userIsCorrect: Bool
    
    func updateSelf() -> Void {
        if (self.userIsCorrect) {
            numCorrect += 1
        }
        index += 1
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
                            currQuestion: allQuestions[index].text,
                            currAnswers: allQuestions[index].answers,
                            selectedAnswer: allQuestions[index].answers[0],
                            correctAnswer: allQuestions[index].answer,
                            numCorrect: numCorrect,
                            totalQuestions: totalQuestions
                        ).navigationBarHidden(true)
                    ) {
                        Text("Next")
                    }
                }
            }.onAppear {
                self.updateSelf()
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

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

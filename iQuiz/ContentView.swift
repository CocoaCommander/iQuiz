//
//  ContentView.swift
//  iQuiz
//
//  Created by Ryan Lee on 5/5/21.
//

import SwiftUI
import Network

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
    
    @State var showError = false
    @State var loadError = ""
    @State var quizLocation = "https://tednewardsandbox.site44.com/questions.json"
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
    var monitor = NWPathMonitor()
    
    
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
                    if let data = UserDefaults.standard.data(forKey: "quizData") {
                        do {
                            // Create JSON Decoder
                            let decoder = JSONDecoder()

                            // Decode Note
                            self.allQuizzes = try decoder.decode([Category].self, from: data)

                        } catch {
                            print("Unable to Decode quizData (\(error))")
                        }
                    }
                    monitor.pathUpdateHandler = { path in
                        if path.status == .satisfied {
                            return
                        } else {
                            self.loadError = "No internet connection."
                        }
                    }
                    let queue = DispatchQueue(label: "Monitor")
                    monitor.start(queue: queue)
                    loadData()
                    if self.loadError != "" {
                        self.showError = !self.showError
                    }
                }.navigationTitle("iQuiz").toolbar {
                    ToolbarItem {
                        Button("Settings") {
                            self.showAlert = !self.showAlert
                        }
                    }
                }
            }
        }
        .textFieldAlert(isShowing: $showAlert, text: $quizLocation, title: "Alert!")
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(self.loadError)
            )
        }
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {

    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title)
                    TextField("", text: self.$text)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .id(self.isShowing)
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Check Now")
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

extension View {

    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
    }

}

extension ContentView {
    func loadData() -> Void {
        guard let url = URL(string: quizLocation) else {
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
                        UserDefaults.standard.set(data, forKey: "quizData")
                    }
                } catch DecodingError.keyNotFound(let key, let context) {
                    self.loadError = "could not find key \(key) in JSON: \(context.debugDescription)"
                } catch DecodingError.valueNotFound(let type, let context) {
                    self.loadError = "could not find type \(type) in JSON: \(context.debugDescription)"
                } catch DecodingError.typeMismatch(let type, let context) {
                    self.loadError = "type mismatch for type \(type) in JSON: \(context.debugDescription)"
                } catch DecodingError.dataCorrupted(let context) {
                    self.loadError = "data found to be corrupted in JSON: \(context.debugDescription)"
                } catch let error as NSError {
                    self.loadError = "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)"
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

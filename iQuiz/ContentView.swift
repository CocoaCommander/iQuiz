//
//  ContentView.swift
//  iQuiz
//
//  Created by Ryan Lee on 5/5/21.
//

import SwiftUI

//var image: String = "function"
//var titleString: String = "Mathematics"
//var bodyDesc: String = "Contains quizzes for Mathematics grades K-12"

struct ContentView: View {
    var body: some View {
        VStack {
            TableCell()
        }
    }
}

struct TableCell: View {
    
    var image: String = "function"
    var titleString: String = "Mathematics"
    var bodyDesc: String = "Contains quizzes for Mathematics grades K-12"
    
    var body: some View {
        HStack(spacing: 50) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                Text(titleString)
                    .bold()
                Text(bodyDesc)
            }
        }
        .padding()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

//
//  ViewsAndModifiersView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-17.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle).foregroundColor(.blue)
    }
}

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text).font(.caption).foregroundColor(.white).padding(5.0).background(Color.black)
        }
    }
}

struct CapsuleText: View {
    var text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }

    func blueTitleStyle() -> some View {
        modifier(BlueTitle())
    }

    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    // The @ViewBuilder modifier here allows us to return multiple views in the content closure and it'll get
    // wrapped in a stack for us.
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }

    var body: some View {
        VStack {
            ForEach(0..<rows) { row in
                HStack {
                    ForEach(0..<self.columns) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

struct ViewsAndModifiersView: View {

    var body: some View {

        VStack(spacing: 20.0) {

            Text("Hello World").modifier(Title())
            Text("Hello World").blueTitleStyle()
            Color.red.frame(width: 200.0, height: 100.0).watermarked(with: "Watermark")

            GridStack(rows: 4, columns: 4) { row, column in
                Image(systemName: "\(row * 4 + column).circle")
                Text("\(row), \(column)")
            }

            CapsuleText("Hello")
                .padding()
                .background(Color.red)
                .padding()
                .background(Color.blue)
                .padding()
                .background(Color.green)
                .padding()
                .background(Color.yellow)
        }
    }

}

struct ViewsAndModifiersView_Previews: PreviewProvider {
    static var previews: some View {
        ViewsAndModifiersView()
    }
}



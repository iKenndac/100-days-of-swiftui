//
//  AnimatingGesturesAndTransitionsView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-27.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90.0, anchor: .topLeading),
                  identity: CornerRotateModifier(amount: 0.0, anchor: .topLeading))
    }
}

struct AnimatingGesturesAndTransitionsView: View {

    @State private var cardDragAmount: CGSize = .zero
    @State private var cardShadowAmount: Double = 0.0

    let letters: [Character] = Array("Hello SwiftUI")
    @State private var lettersEnabled: Bool = false
    @State private var lettersDragAmount: CGSize = .zero

    @State private var isShowingRed: Bool = false

    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 300, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(cardDragAmount)
                .shadow(color: Color(.displayP3, white: 0.33, opacity: cardShadowAmount), radius: 20.0, x: 0.0, y: 15.0)
                .gesture(DragGesture().onChanged({
                    if self.cardShadowAmount == 0.0 {
                        withAnimation(.default) { self.cardShadowAmount = 0.5 }
                    }
                    self.cardDragAmount = $0.translation
                }).onEnded({ _ in
                    withAnimation(.default) { self.cardShadowAmount = 0.0 }
                    withAnimation(.spring()) { self.cardDragAmount = .zero }
                }))

            Divider().padding([.top, .bottom], 40.0)

            HStack {
                ForEach(0..<letters.count) { index in
                    Text(String(self.letters[index]))
                        .padding(5.0)
                        .font(.title)
                        .background(self.lettersEnabled ? Color.blue : Color.red)
                        .offset(self.lettersDragAmount)
                        .animation(Animation.default.delay(Double(index) / 20.0))
                }
            }
            .gesture(DragGesture().onChanged({
                self.lettersDragAmount = $0.translation
            }).onEnded({ _ in
                self.lettersDragAmount = .zero
                self.lettersEnabled.toggle()
            }))

            Divider().padding([.top, .bottom], 40.0)

            Button("Tap Me") { withAnimation { self.isShowingRed.toggle() }}
            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200.0, height: 80.0)
                    .transition(.pivot)
                //.transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

struct AnimatingGesturesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AnimatingGesturesAndTransitionsView()
        }
    }
}

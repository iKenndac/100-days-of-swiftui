//
//  AnimationsView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-25.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct AnimationsView: View {

    @State private var firstScaleAmount: CGFloat = 1.0
    @State private var secondScaleAmount: CGFloat = 1.0
    @State private var rotationAmount: Double = 0.0

    var body: some View {
        VStack {
            Button("Tap Me") {}
                .padding(50.0)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.red)
                        .scaleEffect(firstScaleAmount)
                        .opacity(Double(2.0 - firstScaleAmount))
                        .animation(
                            Animation.easeOut(duration: 2.0)
                                .repeatForever(autoreverses: false)))
                .onAppear { self.firstScaleAmount = 2.0 }
                .padding([.bottom], 80.0)

            Divider()

            Stepper("Scale amount", value: $secondScaleAmount.animation(
                Animation.easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)

            Button("Tap Me") {
                self.secondScaleAmount += 1
            }
            .padding(40)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(secondScaleAmount)

            Divider()

            Button("Spin") {
                withAnimation(.interpolatingSpring(stiffness: 5.0, damping: 1.0), {
                    self.rotationAmount += 360.0
                })
            }
            .padding(40)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(.degrees(rotationAmount), axis: (x: 1.0, y: 1.0, z: -1.0))

        }
    }
}

struct AnimationsView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView {
            AnimationsView()
        }
    }
}

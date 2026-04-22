//
//  CountdownTextView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 22/4/26.
//
import SwiftUI

struct CountdownTextView: View {
    let seconds: Int
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Text("\(seconds)")
            .font(.quickSandBold(100))
            .foregroundColor(.white)
            .bold()
            .scaleEffect(scale)
            .onChange(of: seconds) { _,_ in
                animate()
            }
    }
    
    private func animate() {
        scale = 1.5
        
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 1.0
        }
    }
}

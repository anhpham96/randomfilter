//
//  ProgressView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 16/4/26.
//

import SwiftUI

struct ProgressView: View {
    
    @Binding var progress: CGFloat
    
    var duration: CGFloat = 3
    var maxLength: CGFloat = 200
    var progressBarColor: Color = .pink
    var backgroundColor: Color = .gray.opacity(0.2)
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(backgroundColor)
                .frame(height: 4)
            
            Capsule()
                .fill(progressBarColor)
                .frame(width: progress*maxLength, height: 4)
                .animation(.linear(duration: duration), value: progress)
        }
        .frame(width: maxLength)
    }
}
#Preview {
    @Previewable @State var progress: CGFloat = 0.4

    ProgressView(progress: $progress)
}

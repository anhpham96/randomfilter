//
//  CameraControlButton.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct CameraControlButton: View {
    
    let systemName: String
    
    var action: Completion
    
    var body: some View {
        Circle()
            .fill(Color.black.opacity(0.5))
            .frame(width: 36, height: 36)
            .overlay {
                Image(systemName: systemName)
                    .bold()
                    .foregroundColor(.white)
                    .onTapGesture {
                        action()
                    }
            }
        
    }
}

#Preview {
    CameraControlButton(systemName: "arrow.triangle.2.circlepath", action: {
        
    })
}

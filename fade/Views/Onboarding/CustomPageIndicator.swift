//
//  CustomPageIndicator.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct CustomPageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.accentBrand : Color.primaryBrand.opacity(0.3))
                    .frame(width: index == currentPage ? 8 : 6, height: index == currentPage ? 8 : 6)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    VStack {
        CustomPageIndicator(numberOfPages: 3, currentPage: 0)
        CustomPageIndicator(numberOfPages: 3, currentPage: 1)
        CustomPageIndicator(numberOfPages: 3, currentPage: 2)
    }
    .padding()
    .background(Color.appBackground)
}

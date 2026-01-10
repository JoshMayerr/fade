//
//  SplashView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("fade")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    SplashView()
}

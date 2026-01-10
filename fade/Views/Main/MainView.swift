//
//  MainView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct MainView: View {
    @AppStorage("firstBlockDate") private var firstBlockDate: Double = 0
    
    private var daysFree: Int {
        if firstBlockDate == 0 {
            return 0
        }
        let date = Date(timeIntervalSince1970: firstBlockDate)
        return DateHelper.daysSince(date: date)
    }
    
    private var formattedDate: String {
        if firstBlockDate == 0 {
            return "Not started"
        }
        let date = Date(timeIntervalSince1970: firstBlockDate)
        return DateHelper.formatDate(date: date)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("\(daysFree)")
                        .font(.joshFont(size: 96))
                        .foregroundColor(.primaryBrand)
                    
                    Text("days free")
                        .font(.ibmPlexMono(size: 20))
                        .foregroundColor(.primaryBrand.opacity(0.7))
                    
                    Text(formattedDate)
                        .font(.ibmPlexMono(size: 14))
                        .foregroundColor(.primaryBrand.opacity(0.6))
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("fade")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    MainView()
}

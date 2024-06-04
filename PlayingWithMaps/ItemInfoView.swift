//
//  ItemInfoView.swift
//  PlayingWithMaps
//

//  Created by Jennifer Lee on 6/4/24.
//

import SwiftUI
import MapKit

struct ItemInfoView: View {
    var selectedResult: MKMapItem?
    var route: MKRoute?

    // fetch and look around scene
    @State private var lookAroundScene: MKLookAroundScene?

    
    private var travelTime: String? {
        guard let route else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: route.expectedTravelTime)
        
    }
    
    func getLookAroundScene(){
        if let selectedResult = selectedResult {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: selectedResult)
                lookAroundScene = try? await request.scene
            }
        }
    }
    
    var body: some View {
        //  Title, travel time, and Look Around
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("\(selectedResult?.name ?? "")")
                    if let travelTime {
                        Text(travelTime)
                    }
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(10)
            }
            .onAppear{
                getLookAroundScene()
            }
            .onChange(of: selectedResult){
                getLookAroundScene()
            }
    } // end view
} // end struct

//#Preview {
//    ItemInfoView()
//}

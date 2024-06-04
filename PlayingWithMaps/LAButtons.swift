//
//  LAButtons.swift
//  PlayingWithMaps
//
//  Created by Jennifer Lee on 6/2/24.
//

import SwiftUI
import MapKit

struct LAButtons: View {
    
    // these bindings are input params for the LAButtons
    @Binding var position: MapCameraPosition
    @Binding var searchResults: [MKMapItem]
    
    var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
       // to view all system images, open the SF Symbols app
        HStack {
            Button{
                search(for: "coffee")
            } label: {
                Label("Coffee Shops", systemImage: "cup.and.saucer.fill")
            }
            .buttonStyle(.borderedProminent)
        
            Button{
                search(for: "playground")
            } label: {
                Label("Playgrounds", systemImage: "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            
            Button{
                position = .region(.losangeles)
            }
             label: {
                 Label("Los Angeles", systemImage: "building.2.fill")
             }
            .buttonStyle(.borderedProminent)
            
            Button {
                position = .region(.hollywood)
            } label: {
                Label("Hollywood", systemImage: "movieclapper.fill")
            }
            .buttonStyle(.borderedProminent)
        }
        .labelStyle(.iconOnly)
    }
    
 

    func search(for query: String){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .initialLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
            
        }
    }
}

//#Preview {
//    LAButtons()
//}

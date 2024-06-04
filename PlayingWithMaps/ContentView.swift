//
//  ContentView.swift
//  PlayingWithMaps
//
//  Created by Jennifer Lee on 6/2/24.
//

import SwiftUI
import MapKit

// https://developer.apple.com/documentation/mapkit/mapkit_for_swiftui
// https://developer.apple.com/videos/play/wwdc2023/10043/

extension CLLocationCoordinate2D{
    static let initialLocation = CLLocationCoordinate2D(latitude: 34.1200, longitude: -118.310900)
    static let hollywoodSign = CLLocationCoordinate2D(latitude: 34.1340, longitude: -118.321495)
    static let griffithObservatory = CLLocationCoordinate2D(latitude: 34.1184, longitude: -118.3004)
    static let griffithParking = CLLocationCoordinate2D(latitude: 34.1172, longitude: -118.30710)
    static let griffithParking2 = CLLocationCoordinate2D(latitude: 34.1163, longitude: -118.30700)
    static let lalaland = CLLocationCoordinate2D(latitude: 34.0328, longitude: -118.4943)
    // MDR lat 33.98029 , long: -118.45174
    // 34.0328° N, 118.4943° W
}

extension MKCoordinateRegion {
    // can add multiple location regions
    static let losangeles = MKCoordinateRegion (
        center: CLLocationCoordinate2D(
            latitude: 34.1200, longitude: -118.30700
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5, longitudeDelta: 0.5
        )
    )
    
    static let hollywood = MKCoordinateRegion (
        center: CLLocationCoordinate2D(
            latitude: 34.1200, longitude: -118.30700
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1, longitudeDelta: 0.1
        )
    )
}



struct ContentView: View {

    // if a user pans away, will need to change the camera position state
    
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchResults:[MKMapItem] = []
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    // supporting selection with tag
    //@State private var selectedTag: Int?
    
    
    var body: some View {
            NavigationStack {
                Map(position: $position, selection: $selectedResult) {
                    Marker("Hollywood Sign", coordinate: .hollywoodSign)
                        .tint(.orange)
                    Marker("Griffith Observatory", coordinate: .griffithObservatory)
                    //Marker("LalaLand Kind Cafe", coordinate: .lalaland)
                    Annotation("Parking Spot", coordinate: .griffithParking) {
                        ZStack {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(.background)
                                                    RoundedRectangle(cornerRadius: 5)
                                                       .stroke(.secondary, lineWidth: 1)
                                                    Image(systemName: "car")
                                                                .padding(5)
                                                }
                    }
                    
                    Annotation("Parking Entrance", coordinate: .griffithParking2) {
                        Text("🅿️")
                            .padding(5)
                    }
                    .annotationTitles(.hidden)
                    
                    // this only works when getDirections uses a marker that is on a mapped adress. Not griffithParking
                    if let route {
                        MapPolyline(route)
                            .stroke(.blue, lineWidth: 5)
                    }
                    
                    ForEach(searchResults, id: \.self) { result in
                        Marker(item: result)
                    }
                    .annotationTitles(.hidden)
                    
                    UserAnnotation() //shows user as blue dot on map
                }
                .mapStyle(MapStyle.standard(elevation: .realistic))
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        Spacer()
                        VStack(spacing: 0) {
                            if let selectedResult {
                                ItemInfoView(selectedResult: selectedResult, route: route)
                                    .frame(height: 128)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding([.top, .horizontal])
                            }
                            LAButtons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                                .padding(.top)
                        }
                        Spacer()
                    }
                    .background(.thinMaterial)
                }
                .onChange(of: searchResults) { _ in
                    position = .automatic
                }
                .onChange(of: selectedResult) { _ in
                    getDirections()
                }
                .onMapCameraChange { context in
                    visibleRegion = context.region
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
            } // end NavigationStack
        }

        func getDirections() {
            route = nil
            guard let selectedResult else { return }
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: .griffithParking))
            request.destination = selectedResult
            
            Task {
                let directions = MKDirections(request: request)
                let response = try? await directions.calculate()
                route = response?.routes.first
            }
        }
        
} // struct


#Preview {
    ContentView()
}

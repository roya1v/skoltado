//
//  ShotLocationsMapBloc.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 24.07.2022.
//

import Foundation
import UIKitBloc

// MARK: - State

enum ShotLocationMapState {
    case loaded(locations: [ShotLocation])
    case showAddLocation
}

// MARK: - Event

enum ShotLocationMapEvent {
    case viewDidLoad
    case didTapNewLocation
    case didSubmitNewLocation(location: ShotLocation)
}

// MARK: - Bloc class

final class ShotLocationBloc: Bloc<ShotLocationMapEvent, ShotLocationMapState> {

    // MARK: - Private properties

    // MARK: - Dependencies

    private let shotLocationRepository: ShotLocationRepository

    // MARK: - Initializers

    init(shotLocationRepository: ShotLocationRepository) {
        self.shotLocationRepository = shotLocationRepository
        super.init()
    }

    // MARK: - Bloc

    override func map(_ event: ShotLocationMapEvent) {
        switch event {
        case .viewDidLoad:
            fetchLocations()
        case .didTapNewLocation:
            state.send(.showAddLocation)
        case .didSubmitNewLocation(location: let location):
            shotLocationRepository.create(shotLocation: location)
        }
    }

    // MARK: - Private methods

    private func fetchLocations() {
        Task {
            let coords = try! await shotLocationRepository.fetch()
            state.send(.loaded(locations: coords))
        }
    }
}

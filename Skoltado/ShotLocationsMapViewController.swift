//
//  ShotLocationsMapViewController.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 21.07.2022.
//

import UIKit
import MapKit
import UIKitBloc
import KeyboardLayoutGuide

final class ShotLocationsMapViewController: BlocViewController<ShotLocationMapEvent, ShotLocationMapState> {

    // MARK: - UI Elements

    private let mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let addLocationButton: UIButton = {
        let view = PrimaryButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.orange
        view.setTitleColor(Colors.white, for: .normal)
        view.setTitle("I know a cool place!", for: .normal)
        return view
    }()

    private let createShotLocationView: CreateShotLocationView = {
        let view = CreateShotLocationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let newShotLocationTarget: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "mappin"))
        view.tintColor = Colors.orange
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        events.send(.viewDidLoad)
    }


    // MARK: - Setup

    private func setup() {
        setupUI()

        addLocationButton.addAction(UIAction(handler: { action in
            self.events.send(.didTapNewLocation)
        }), for: .touchUpInside)

        createShotLocationView.didTapClose = { [weak self] in
            self?.view.endEditing(true)
            self?.animateCreateShotLocationViewDissappearing { [weak self] in
                self?.newShotLocationTarget.isHidden = true
                self?.animateAddLocationButtonAppearing()

            }
        }

        createShotLocationView.didTapSubmit = {
            let coord = self.mapView.centerCoordinate
            let title = self.createShotLocationView.titleText ?? ""
            let description = self.createShotLocationView.descriptionText ?? ""
            let shotLocation = ShotLocation(title: title,
                                            description: description,
                                            coordinatesLon: coord.longitude,
                                            coordinatesLat: coord.latitude)
            self.events.send(.didSubmitNewLocation(location: shotLocation))
        }
    }

    // MARK: - Bloc

    override func map(_ state: ShotLocationMapState) {
        switch state {
        case .loaded(let locations):
            display(locations: locations)
        case .showAddLocation:
            showAddLocation()
        }
    }

    private func display(locations: [ShotLocation]) {
        self.mapView.addAnnotations(
            locations.map({ shotLocation in
                let coord = CLLocationCoordinate2D(latitude: shotLocation.coordinatesLat, longitude: shotLocation.coordinatesLon)
                return Test(coordinate: coord)
            })
        )
    }

    private func showAddLocation() {
        animateAddLocationButtonDissappearing { [weak self] in
            self?.animateCreateShotLocationViewAppearing { [weak self] in
                self?.newShotLocationTarget.isHidden = false
            }
        }
    }

    // MARK: - UI Setup

    private lazy var buttonShownConstraints = [
        addLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacings.big)
    ]
    private lazy var buttonHiddenConstraints = [
        addLocationButton.topAnchor.constraint(equalTo: view.bottomAnchor)
    ]

    private lazy var createHiddenConstraints = [
        createShotLocationView.topAnchor.constraint(equalTo: view.keyboardLayoutGuideNoSafeArea.topAnchor)
    ]

    private lazy var createShownConstraints = [self.createShotLocationView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -Spacings.big)]


    private func setupUI() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuideNoSafeArea.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(addLocationButton)
        NSLayoutConstraint.activate([
            addLocationButton.heightAnchor.constraint(equalToConstant: Spacings.huge),
            addLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacings.big),
            addLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacings.big)
        ])

        NSLayoutConstraint.activate(buttonShownConstraints)

        view.addSubview(createShotLocationView)
        NSLayoutConstraint.activate([
            createShotLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacings.big),
            createShotLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacings.big)
        ])
        NSLayoutConstraint.activate(createHiddenConstraints)

        view.addSubview(newShotLocationTarget)
        newShotLocationTarget.isHidden = true
        NSLayoutConstraint.activate([
            newShotLocationTarget.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            newShotLocationTarget.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            newShotLocationTarget.heightAnchor.constraint(equalToConstant: Spacings.huge),
            newShotLocationTarget.widthAnchor.constraint(equalTo: newShotLocationTarget.heightAnchor)
        ])
    }

    private func animateAddLocationButtonDissappearing(completion: (() -> ())? = nil) {
        NSLayoutConstraint.deactivate(buttonShownConstraints)
        NSLayoutConstraint.activate(buttonHiddenConstraints)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }

    private func animateCreateShotLocationViewAppearing(completion: (() -> ())? = nil) {
        NSLayoutConstraint.deactivate(self.createHiddenConstraints)
        NSLayoutConstraint.activate(self.createShownConstraints)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }

    private func animateAddLocationButtonAppearing(completion: (() -> ())? = nil) {
        self.newShotLocationTarget.isHidden = true
        NSLayoutConstraint.deactivate(self.buttonHiddenConstraints)
        NSLayoutConstraint.activate(self.buttonShownConstraints)
        self.addLocationButton.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }

    private func animateCreateShotLocationViewDissappearing(completion: (() -> ())? = nil) {
        NSLayoutConstraint.deactivate(self.createShownConstraints)
        NSLayoutConstraint.activate(self.createHiddenConstraints)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        } completion: { something in
            completion?()
        }
    }
}

class Test: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}


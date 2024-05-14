//
//  AccreditedNetworkVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 14/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import GoogleMaps
import NotificationCenter

// MARK: - CameFrom Enum
enum CameFrom {
    case filterResult
    case other
}


class AssociatedNetworkVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwMap: GMSMapView!
    @IBOutlet weak var vwFilter: ShadowedView!
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var selectedAssociated: Associated?
    var selectedCoordinates: CLLocationCoordinate2D?
    var cameFrom = CameFrom.other
    
    // MARK: - Private properties
    private let _DEFAULT_MAP_ZOOM_LEVEL: Float = 16.3
    private var locationManager = CLLocationManager()
    private var mapMarkers =  [GMSMarker]()
    private var currentMarker: GMSMarker?
    private var currentLocation: CLLocationCoordinate2D?
    private var mapCenter: CLLocationCoordinate2D?
    private var reloadPins = true
    private var positions = [AssociatedPosition]()
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    override func configureScreen() {
        currentLocation = nil
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        vwMap.isMyLocationEnabled = true
        vwMap.settings.myLocationButton = true
        vwMap.settings.compassButton = true
        vwMap.settings.zoomGestures = true
        
        vwMap.delegate = self
        vwMap.mapStyle(withFilename: "map-style", andType: "json")
        
        lbTitle.text = "Rede Credenciada \(AppContext.shared.user.selectedCard != nil ? " - \(AppContext.shared.user.selectedCard!.label)" : "")"
        
        setupColors()
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        hideKeyboard()
        checkConnection()
    }

    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        vwFilter.backgroundColor = UIColor.cardBackground
        
        lbTitle.textColor = UIColor.degradeTitleFontColor
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
            
        } else {
            initiateView()
        }
    }
    
    private func initiateView() {
        vwFilter.isHidden = cameFrom == .filterResult
        if cameFrom == .filterResult, let selectedCoordinates = selectedCoordinates {
            reloadPins = false
            let camera = GMSCameraPosition(latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude, zoom: _DEFAULT_MAP_ZOOM_LEVEL)
            self.vwMap.animate(to: camera)
            
            serviceExecute { logged in
                if logged {
                    self.displayAssociatedOnMap(atLocation: selectedCoordinates) { (ok) in
                        if ok {
                            self.didTapMarker(marker: self.currentMarker)
                        }
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    private func displayAssociatedOnMap(atLocation location: CLLocationCoordinate2D, withCompletion completion: ((Bool) -> ())?) {
        vwMap.clear()
        AssociatedService.instance.getAssociatedCoordinatesAround(coordinate: location) { (positions, error) in
            if let error = error {
                self.handleNetworking(error: error, forViewController: self, completion: nil)
                completion?(false)
                
            } else {
                self.positions = positions
                DispatchQueue.main.async {
                    self.generateMapMarkers()
                    completion?(true)
                }
            }
        }
    }
    
    private func generateMapMarkers(_ animated: Bool = true) {
        if !positions.isEmpty {
            for position in positions {
                if let latitude = Double(position.latitude), let longitude = Double(position.longitude) {
                    let gmsMarker = GMSMarker()
                    gmsMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    gmsMarker.icon = Constants.IMAGES._GSM_MARKER_IMAGE
                    if animated { gmsMarker.appearAnimation = GMSMarkerAnimation.pop }
                    gmsMarker.userData = position
                    gmsMarker.map = self.vwMap
                    
                    if let selectedAssociated = self.selectedAssociated, selectedAssociated.id == position.code {
                        currentMarker = gmsMarker
                    }
                }
            }
        }
    }
    
    private func getAssociatedInfo(fromAssociatedCode associatedId: String) {
        serviceExecute { logged in
            if logged {
                AssociatedService.instance.getAssociatedDetails(fromAssociatedId: associatedId) { (associated, error) in
                    if let error = error {
                        self.handleNetworking(error: error, forViewController: self, completion: nil)
                        
                    } else if let associated = associated {
                        self.showSelectedAssociatedInfo(forController: self, withAssociated: associated)
                    }
                }
                
            } else {
                self.showGenericErrorAlert(forController: self)
            }
        }
    }
    
    private func didTapMarker(marker: GMSMarker?) {
        if let marker = marker {
            reloadPins = false
            
            if let currentMarker = currentMarker {
                currentMarker.icon = Constants.IMAGES._GSM_MARKER_IMAGE
            }
            
            currentMarker = marker
            marker.icon = Constants.IMAGES._GSM_MARKER_SELECTED_IMAGE
            
            if let position = marker.userData as? AssociatedPosition {
                getAssociatedInfo(fromAssociatedCode: position.code)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: UIButton) {
        switch cameFrom {
        case .filterResult:
            closeViewController()
            
        case .other:
            performSegue(withIdentifier: "homeUnwindSegue", sender: nil)
        }
        
        cameFrom = .other
        selectedAssociated = nil
    }
    
    @IBAction func didTapFilterButton(_ sender: Any) {
        performSegue(withIdentifier: "networkFilterVCSegue", sender: nil)
    }
    
    // MARK: - Unwind Segues
    @IBAction func associatedNetworkUnwindAction(unwindSegue: UIStoryboardSegue) { }
    
}


// MARK: - AlertDelegate
extension AssociatedNetworkVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}


// MARK: - CLLocationManagerDelegate
extension AssociatedNetworkVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: _DEFAULT_MAP_ZOOM_LEVEL)
            vwMap.animate(to: camera)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
}


// MARK: - GMSMapViewDelegate
extension AssociatedNetworkVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        didTapMarker(marker: marker)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if reloadPins {
            mapCenter = mapView.projection.coordinate(for: mapView.center)
            serviceExecute { logged in
                if logged {
                    self.displayAssociatedOnMap(atLocation: self.mapCenter!, withCompletion: nil)
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
            
        } else {
            reloadPins = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapCenter = nil
    }
    
}


// MARK: - SelectedAssociatedDelegate
extension AssociatedNetworkVC: SelectedAssociatedDelegate {
    
    func didCall(associated: Associated) {
        if let phoneNumber = associated.phone, !phoneNumber.isEmpty {
            Utils.makeCall(toPhoneNumber: phoneNumber, withCompletion: nil)
        }
    }
    
    func didRouteTo(associated: Associated) {
        if let currentLocation = currentLocation, !associated.fullAddress.isEmpty {
            RouteService.instance.drawRoute(forController: self, sourceCoordinate: currentLocation, andDestinationAddress: associated.fullAddress, withCompletion: nil)
        }
    }
    
    func didClose(isJustClosing: Bool) {
        if isJustClosing {
            selectedAssociated = nil
            vwMap.clear()
            generateMapMarkers(false)
        }
    }
    
}

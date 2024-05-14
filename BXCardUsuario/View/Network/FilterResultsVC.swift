//
//  FilterResultsVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 20/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import CoreLocation
import NotificationCenter

class FilterResultsVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var svNoRecords: UIStackView!
    @IBOutlet weak var tvAssociated: UITableView!
    @IBOutlet weak var lbScreenTitle: UILabel!
    
    // MARK: - Private Properties
    private var currentPage = 1
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var associatedList = [Associated]()
    var selectedSegment: Segment?
    var selectedActivity: Activity?
    var selectedSpecialty: Specialty?
    var selectedState: State?
    var selectedCity: City?
    var selectedNeighborhood: Neighborhood?
    var totalRecords: Int?
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectedAssociatedSegue", let associatedNetworkVC = segue.destination as? AssociatedNetworkVC, let associated = sender as? Associated, let latitude = associated.numericLatitude, let longitude = associated.numericLongitude {
            associatedNetworkVC.selectedCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            associatedNetworkVC.selectedAssociated = associated
            associatedNetworkVC.cameFrom = .filterResult
        }
    }
    
    override func configureScreen() {
        setupColors()
        
        tvAssociated.isHidden = associatedList.count == 0
        svNoRecords.isHidden = !tvAssociated.isHidden
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        hideKeyboard()
        checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        lbScreenTitle.textColor = UIColor.degradeTitleFontColor
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        }
    }
    
    private func showAssociatedOnMap(_ associated: Associated) {
        performSegue(withIdentifier: "showSelectedAssociatedSegue", sender: associated)
    }
    
    @objc private func reloadTableData() {
        tvAssociated.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        closeViewController()
    }
    
    // MARK: - Unwind Segues
    @IBAction func filterResultsUnwindAction(unwindSegue: UIStoryboardSegue) { }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterResultsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return associatedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let associatedCell = tableView.dequeueReusableCell(withIdentifier: AssociatedCell.identifier, for: indexPath) as? AssociatedCell {
            associatedCell.associated = associatedList[indexPath.row]
            return associatedCell
        }
        
        return AssociatedCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAssociatedOnMap(associatedList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == associatedList.count - 1 {
            if associatedList.count < totalRecords.intValue {
                serviceExecute { logged in
                    if logged {
                        AssociatedService.instance.getAssociated(forPage: self.currentPage, bySegment: self.selectedSegment, andActivity: self.selectedActivity, andSpecialty: self.selectedSpecialty, andState: self.selectedState, andCity: self.selectedCity, andNeighborhood: self.selectedNeighborhood) { (associatedList, totalRecords, error) in
                            if let error = error {
                                self.handleNetworking(error: error, forViewController: self, completion: nil)
                                
                            } else {
                                self.associatedList.append(contentsOf: associatedList)
                                self.perform(#selector(self.reloadTableData), with: nil, afterDelay: 0.5)
                                
                                self.currentPage += 1
                            }
                        }
                        
                    } else {
                        self.showGenericErrorAlert(forController: self)
                    }
                }
            }
        }
    }
    
}


// MARK: - AlertDelegate
extension FilterResultsVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}

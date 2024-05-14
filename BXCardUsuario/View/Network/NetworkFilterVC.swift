//
//  NetworkFilterVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 18/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit


class NetworkFilterVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lbSegmentFilter: UILabel!
    @IBOutlet weak var lbActivityFilter: UILabel!
    @IBOutlet weak var lbSpecialtyFilter: UILabel!
    @IBOutlet weak var lbStateFilter: UILabel!
    @IBOutlet weak var lbCityFilter: UILabel!
    @IBOutlet weak var lbNeighborhoodFilter: UILabel!
    @IBOutlet weak var btnFilter: Button!
    @IBOutlet weak var svActivity: UIStackView!
    @IBOutlet weak var svSpecialty: UIStackView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbSegmentLabel: UILabel!
    @IBOutlet weak var lbSegmentValue: UILabel!
    @IBOutlet weak var vwSegmentDownLine: UIView!
    
    @IBOutlet weak var lbActivityLabel: UILabel!
    @IBOutlet weak var lbActivityValue: UILabel!
    @IBOutlet weak var vwActivityDownLine: UIView!
    
    @IBOutlet weak var lbSpecialtyLabel: UILabel!
    @IBOutlet weak var lbSpecialtyValue: UILabel!
    @IBOutlet weak var vwSpecialtyDownLine: UIView!
    
    @IBOutlet weak var lbStateLabel: UILabel!
    @IBOutlet weak var lbStateValue: UILabel!
    @IBOutlet weak var vwStateDownLine: UIView!
    
    @IBOutlet weak var lbCityLabel: UILabel!
    @IBOutlet weak var lbCityValue: UILabel!
    @IBOutlet weak var vwCityDownLine: UIView!
    
    @IBOutlet weak var lbNeighborhoodLabel: UILabel!
    @IBOutlet weak var lbNeighborhoodValue: UILabel!
    @IBOutlet weak var vwNeighborhoodDownLine: UIView!
    
    
    // MARK: - Private Properties
    private var selectedSegment: Segment?
    private var selectedActivity: Activity?
    private var selectedSpecialty: Specialty?
    private var selectedState: State?
    private var selectedCity: City?
    private var selectedNeighborhood: Neighborhood?
    private var totalRecords: Int?
    
    // MARK: - Filter Enum
    enum Filter: Int {
        
        case segment = 1
        case activity = 2
        case specialty = 3
        case state = 4
        case city = 5
        case neighborhood = 6

        var description: String {
            switch self {
            case .segment:
                return "Segmento"
                
            case .activity:
                return "Ramo de Atividade"
                
            case .specialty:
                return "Especialidade"
                
            case .state:
                return "Estado"
                
            case .city:
                return "Cidade"
                
            case .neighborhood:
                return "Bairro"
            }
        }
        
    }
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        if segue.identifier == "filterResultsVCSegue", let filterResultsVC = segue.destination as? FilterResultsVC {
            filterResultsVC.associatedList = sender as? [Associated] ?? [Associated]()
            filterResultsVC.totalRecords = totalRecords
            filterResultsVC.selectedSegment = selectedSegment
            filterResultsVC.selectedActivity = selectedActivity
            filterResultsVC.selectedSpecialty = selectedSpecialty
            filterResultsVC.selectedState = selectedState
            filterResultsVC.selectedCity = selectedCity
            filterResultsVC.selectedNeighborhood = selectedNeighborhood
        }
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        setupColors()
        
        svActivity.isHidden = false
        svSpecialty.isHidden = !svActivity.isHidden
        
        loadSegments {
            self.loadStates()
        }
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        hideKeyboard()
        checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor

        lbTitle.textColor = UIColor.degradeTitleFontColor
        
        lbSegmentLabel.textColor = UIColor.secondaryFontColor
        lbSegmentValue.textColor = UIColor.primaryDarkFontColor
        vwSegmentDownLine.backgroundColor = UIColor.defaultBorderColor
        
        lbActivityLabel.textColor = UIColor.secondaryFontColor
        lbActivityValue.textColor = UIColor.primaryDarkFontColor
        vwActivityDownLine.backgroundColor = UIColor.defaultBorderColor
        
        lbSpecialtyLabel.textColor = UIColor.secondaryFontColor
        lbSpecialtyValue.textColor = UIColor.primaryDarkFontColor
        vwSpecialtyDownLine.backgroundColor = UIColor.defaultBorderColor
        
        lbStateLabel.textColor = UIColor.secondaryFontColor
        lbStateValue.textColor = UIColor.primaryDarkFontColor
        vwStateDownLine.backgroundColor = UIColor.defaultBorderColor
        
        lbCityLabel.textColor = UIColor.secondaryFontColor
        lbCityValue.textColor = UIColor.primaryDarkFontColor
        vwCityDownLine.backgroundColor = UIColor.defaultBorderColor
        
        lbNeighborhoodLabel.textColor = UIColor.secondaryFontColor
        lbNeighborhoodValue.textColor = UIColor.primaryDarkFontColor
        vwNeighborhoodDownLine.backgroundColor = UIColor.defaultBorderColor
        
        btnFilter.enable()
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        }
    }
    
    private func loadSegments(_ completion: (() -> ())? = nil) {
        if let selectedCard = AppContext.shared.user.selectedCard {
            serviceExecute { logged in
                if logged {
                    LoadingVC.instance.show()
                    SegmentService.instance.getSegments(forCard: selectedCard) { (error) in
                        LoadingVC.instance.hide()
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                        }
                        
                        completion?()
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    private func loadSpecialties(_ completion: (() -> ())? = nil) {
        if let selectedSegment = selectedSegment {
            serviceExecute { logged in
                if logged {
                    LoadingVC.instance.show()
                    self.selectedSpecialty = nil
                    self.lbSpecialtyFilter.clear()
                    SpecialtyService.instance.getSpecialties(forSegment: selectedSegment) { (error) in
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                        }
                        
                        completion?()
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    private func loadActivities(_ completion: (() -> ())? = nil) {
        if let selectedSegment = selectedSegment {
            serviceExecute { logged in
                if logged {
                    LoadingVC.instance.show()
                    self.selectedActivity = nil
                    self.lbActivityFilter.clear()
                    ActivityService.instance.getActivities(forSegment: selectedSegment, andSpecialty: self.selectedSpecialty, andState: self.selectedState, andCity: self.selectedCity) { (error) in
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                        }
                        
                        completion?()
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    private func loadStates(_ completion: (() -> ())? = nil) {
        serviceExecute { logged in
            if logged {
                LoadingVC.instance.show()
                self.selectedState = nil
                self.lbStateFilter.clear()
                StateService.instance.getStates(forSegment: self.selectedSegment, andActivity: self.selectedActivity, andSpecialty: self.selectedSpecialty) { (error) in
                    LoadingVC.instance.hide()
                    if let error = error {
                        self.handleNetworking(error: error, forViewController: self, completion: nil)
                    }
                    
                    completion?()
                }
                
            } else {
                self.showGenericErrorAlert(forController: self)
            }
        }
    }
    
    private func loadCities(_ completion: (() -> ())? = nil) {
        if let selectedState = selectedState {
            serviceExecute { logged in
                if logged {
                    LoadingVC.instance.show()
                    self.selectedCity = nil
                    self.lbCityFilter.clear()
                    CityService.instance.getCities(forSegment: self.selectedSegment, andActivity: self.selectedActivity, andSpecialty: self.selectedSpecialty, andState: selectedState) { (error) in
                        LoadingVC.instance.hide()
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                        }

                        completion?()
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    private func loadNeighborhoods(_ completion: (() -> ())? = nil) {
        if let selectedState = selectedState, let selectedCity = selectedCity {
            serviceExecute { logged in
                if logged {
                    LoadingVC.instance.show()
                    self.selectedNeighborhood = nil
                    self.lbNeighborhoodFilter.clear()
                    NeighborhoodService.instance.getNeighborhoods(forSegment: self.selectedSegment, andActivity: self.selectedActivity, andSpecialty: self.selectedSpecialty, andState: selectedState, andCity: selectedCity) { (error) in
                        LoadingVC.instance.hide()
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                        }
                        
                        completion?()
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    private func selectFilter(_ sender: UITapGestureRecognizer) {
        if let selectedDropDownMenu = sender.view as? UIImageView, let filter = Filter(rawValue: selectedDropDownMenu.tag) {
            let pickerData: [PickerData]
            let selectedData: PickerData?
            switch filter {
            case .segment:
                pickerData = SegmentService.instance.segments
                selectedData = selectedSegment
                
            case .activity:
                pickerData = ActivityService.instance.activities
                selectedData = selectedActivity
                
            case .specialty:
                pickerData = SpecialtyService.instance.specialties
                selectedData = selectedSpecialty
                
            case .state:
                pickerData = StateService.instance.states
                selectedData = selectedState
                
            case .city:
                pickerData = CityService.instance.cities
                selectedData = selectedCity
                
            case .neighborhood:
                pickerData = NeighborhoodService.instance.neighborhoods
                selectedData = selectedNeighborhood
            }
            
            showPicker(forController: self, withData: pickerData, withSelectedData: selectedData, andId: filter.description)
        }
    }
    
    private func validate() -> Bool {
        if selectedSegment == nil  || selectedState == nil || selectedCity == nil {
            self.showAlert(forController: self, title: "Atenção" , message: "Os campos\"Segmento\", \"Estado\" e \"Cidade\" devem ser informados.", leftButtonTitle: nil, leftButtonType: nil, leftButtonBorderColor: nil, rightButtonTitle: "Ok", rightButtonType: .normal, rightButtonBorderColor: nil, closeButtonImage: Constants.IMAGES._CANCEL_GRAY_IMAGE, withId: "", sender: nil)
            return false
        }
        
        return true
    }
    
    private func filter() {
        if !validate() { return }
        
        serviceExecute { logged in
            if logged {
                LoadingVC.instance.show()
                AssociatedService.instance.getAssociated(forPage: 1, bySegment: self.selectedSegment, andActivity: self.selectedActivity, andSpecialty: self.selectedSpecialty, andState: self.selectedState, andCity: self.selectedCity, andNeighborhood: self.selectedNeighborhood) { (associatedList, totalRecords, error) in
                    LoadingVC.instance.hide()
                    if let error = error {
                        self.handleNetworking(error: error, forViewController: self, completion: nil)
                        
                    } else {
                        self.totalRecords = totalRecords
                        self.performSegue(withIdentifier: "filterResultsVCSegue", sender: associatedList)
                    }
                }
                
            } else {
                self.showGenericErrorAlert(forController: self)
            }
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        closeViewController()
    }

    @IBAction func didTapFilterButton(_ sender: UIButton) {
        filter()
    }
    
    @IBAction func didTapDropDownMenu(_ sender: UITapGestureRecognizer) {
        selectFilter(sender)
    }
    
}


// MARK: - AlertDelegate
extension NetworkFilterVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right && id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}


// MARK: - PickerDelegate
extension NetworkFilterVC: PickerDelegate {
    
    func didConfirmSelection(data: PickerData, withId id: String) {
        switch id {
        case Filter.segment.description:
            lbSegmentFilter.text = data.pickerRowTitle
            selectedSegment = data as? Segment
            if let selectedSegment = selectedSegment {
                svActivity.isHidden = selectedSegment.type != SegmentType.normal.rawValue
                svSpecialty.isHidden = !svActivity.isHidden
                if !svActivity.isHidden {
                    loadActivities {
                        self.loadStates()
                    }
                } else {
                    loadSpecialties {
                        self.loadStates()
                    }
                }
            }
            
        case Filter.activity.description:
            lbActivityFilter.text = data.pickerRowTitle
            selectedActivity = data as? Activity
            selectedSpecialty = nil
            loadStates()

        case Filter.specialty.description:
            lbSpecialtyFilter.text = data.pickerRowTitle
            selectedSpecialty = data as? Specialty
            selectedActivity = nil
            loadStates()
            
        case Filter.state.description:
            lbStateFilter.text = data.pickerRowTitle
            selectedState = data as? State
            loadCities()
            
        case Filter.city.description:
            lbCityFilter.text = data.pickerRowTitle
            selectedCity = data as? City
            loadNeighborhoods()
            
        case Filter.neighborhood.description:
            lbNeighborhoodFilter.text = data.pickerRowTitle
            selectedNeighborhood = data as? Neighborhood
            
        default:
            print("")
        }
    }
    
    func didCancelSelection(withId id: String) {
        let noneOptionTitle = ""
        switch id {
        case Filter.segment.description:
            lbSegmentFilter.text = noneOptionTitle
            selectedSegment = nil

        case Filter.activity.description:
            lbActivityFilter.text = noneOptionTitle
            selectedActivity = nil

        case Filter.specialty.description:
            lbSpecialtyFilter.text = noneOptionTitle
            selectedSpecialty = nil

        case Filter.state.description:
            lbStateFilter.text = noneOptionTitle
            selectedState = nil

        case Filter.city.description:
            lbCityFilter.text = noneOptionTitle
            selectedCity = nil

        case Filter.neighborhood.description:
            lbNeighborhoodFilter.text = noneOptionTitle
            selectedNeighborhood = nil

        default:
            print("")
        }
    }
    
}

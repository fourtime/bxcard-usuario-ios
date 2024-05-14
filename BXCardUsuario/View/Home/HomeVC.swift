//
//  HomeVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import AVFoundation

class HomeVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwGreen: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var cvCollection: UICollectionView!
    @IBOutlet weak var pcPages: UIPageControl!
    @IBOutlet weak var tvTransactions: UITableView!
    @IBOutlet weak var vwIndicator: UIView!
    @IBOutlet weak var btnFilterButton1: UIButton!
    @IBOutlet weak var btnFilterButton2: UIButton!
    @IBOutlet weak var btnFilterButton3: UIButton!
    @IBOutlet weak var svFilterButtons: UIStackView!
    @IBOutlet weak var footerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwFooterContainer: UIView!
    @IBOutlet weak var vwTableViewHeader: UIView!
    @IBOutlet weak var vwNetworkButton: ShadowedView!
    @IBOutlet weak var lbNetworkButton: UILabel!
    @IBOutlet weak var vwQRCodeButton: ShadowedView!
    @IBOutlet weak var lbQRCodeButton: UILabel!
    @IBOutlet weak var vwBlockButton: ShadowedView!
    @IBOutlet weak var lbBlockButton: UILabel!
    @IBOutlet weak var vwTableViewTopFrame: ShadowedView!
    @IBOutlet weak var lbTableViewTitle: UILabel!
    @IBOutlet weak var vwFooter: ShadowedView!
    @IBOutlet weak var lbNoTransactions: UILabel!
    
    // MARK: - FilterButton Enum
    private enum FilterButton: Int {
        
        case days15 = 15
        case days30 = 30
        case days90 = 90
        
        var description: String {
            return "\(self.rawValue) dias"
        }
            
        func getInitialDate(fromDate date: Date) -> Date? {
            return Calendar.current.date(byAdding: Calendar.Component.day, value: self.rawValue * -1, to: date)
        }
        
    }
    
    // MARK: - FooterTopConstraint Enum
    private enum FooterTopConstraint: CGFloat {
        case normal = -80.0
        case noRecords = -10.0
    }
    
    // MARK: - FooterContainerHeight Enum
    private enum FooterContainerHeight: CGFloat {
        case normal = 20.0
        case noRecords = 90.0
    }
    
    // MARK: - Private Properties
    private var cellScaling: CGFloat = 0.81
    private var cardOffset: CGPoint?
    private var totalTransacations: Int = 0
    private var currentPage = 1
    private var selectedFilterButton: FilterButton?
    private var transactions = [Transaction]() {
        didSet {
            sortedTransactions = transactions.sorted(by: { $0.dateTime >= $1.dateTime } )
        }
    }
    private var sortedTransactions = [Transaction]()
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvTransactions.refreshControl = UIRefreshControl()
        self.tvTransactions.refreshControl?.addTarget(self, action: #selector(self.refreshAction), for: .valueChanged)
        
        configureScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cardOffset = cvCollection.contentOffset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
        checkConnection()
    }
    
    override func configureScreen() {
        configureRevealMenu(btnMenu)

        setupColors()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCardBalance), name: Notification.Name(Constants.NOTIFICATIONS._PAYMENT_CONFIRMATION_NOTIFICATION), object: nil)
        
        selectedFilterButton = .days15
        configDateFilterButtons()
    }
    
    func loadData() {
        serviceExecute { logged in
            if logged {
                self.loadProfile()
                self.saveFirebaseToken()
                self.loadCards()
                
            } else {
                self.showGenericErrorAlert(forController: self)
            }
        }
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }
    
    @objc func refreshAction() {
        self.updateInfo(forCard: nil)
        self.tvTransactions.refreshControl?.endRefreshing()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        //vwGreen.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        lbTitle.textColor = UIColor.degradeTitleFontColor
        
        vwNetworkButton.backgroundColor = UIColor.cardBackground
        lbNetworkButton.textColor = UIColor.primaryFontColor
        vwQRCodeButton.backgroundColor = UIColor.cardBackground
        lbQRCodeButton.textColor = UIColor.primaryFontColor
        vwBlockButton.backgroundColor = UIColor.cardBackground
        lbBlockButton.textColor = UIColor.primaryFontColor
        
        tvTransactions.backgroundColor = UIColor.defaultTableViewBackground
        tvTransactions.separatorColor = UIColor.defaultBorderColor
        vwTableViewHeader.backgroundColor = UIColor.defaultTableViewBackground
        vwTableViewTopFrame.backgroundColor = UIColor.cardBackground
        lbTableViewTitle.textColor = UIColor.primaryFontColor
        vwIndicator.backgroundColor = UIColor.highlightFontColor
        btnFilterButton1.tintColor = UIColor.highlightFontColor
        btnFilterButton2.tintColor = UIColor.secondaryFontColor
        btnFilterButton3.tintColor = UIColor.secondaryFontColor
        
        cvCollection.backgroundColor = UIColor.defaultTableViewBackground
        
        vwFooterContainer.backgroundColor = UIColor.defaultTableViewBackground
        vwFooter.backgroundColor = UIColor.cardBackground
        lbNoTransactions.textColor = UIColor.secondaryFontColor
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        }
    }
    
    func saveFirebaseToken() {
        let savedToken = AppContext.shared.firebaseToken
        let fcmToken = AppContext.shared.fcmToken
        
        if savedToken.isEmpty || savedToken != fcmToken {
            UserService.shared.saveToken(forFirebase: fcmToken, withCompletion: { (error) in
                if let error = error {
                    print("Save FCM token failed: \(error.localizedDescription)")
                    
                } else {
                    print("FCM registered successfully")
                    AppContext.shared.firebaseToken = fcmToken
                }
            })
        }
    }
    
    private func loadProfile() {
        UserService.shared.getUserProfile(withCompletion: { (profile, error) in
            if let profile = profile {
                AppContext.shared.user.profile = profile
            }
        })
    }
    
    private func loadCards() {
        LoadingVC.instance.show()
        CardService.instance.getCards { (error) in
            LoadingVC.instance.hide()
            if let error = error {
                self.handleNetworking(error: error, forViewController: self, completion: nil)
            } else {
                self.cvCollection.reloadData()

                var idx = IndexPath(item: 0, section: 0)
                if let card = AppContext.shared.user.selectedCard ?? CardService.instance.cards.first {
                    self.updateInfo(forCard: card)
                    idx = IndexPath(item: (CardService.instance.cards.firstIndex(of: card) ?? 0), section: 0)
                } else {
                    self.updateInfo(forCard: nil)
                }
                self.pcPages.numberOfPages = CardService.instance.cards.count
                self.pcPages.currentPage = idx.item
                
                let screenSize = UIScreen.main.bounds.size
                let cellWidth = floor(screenSize.width * self.cellScaling)
                self.cardOffset = CGPoint(x: cellWidth * CGFloat(idx.item), y: 0.0)
                
                self.configureCardCollection()
            }
        }
    }
    
    private func configDateFilterButtons() {
        btnFilterButton1.setTitle(FilterButton.days15.description, for: UIControl.State.normal)
        btnFilterButton2.setTitle(FilterButton.days30.description, for: UIControl.State.normal)
        btnFilterButton3.setTitle(FilterButton.days90.description, for: UIControl.State.normal)
        
        btnFilterButton1.tag = FilterButton.days15.rawValue
        btnFilterButton2.tag = FilterButton.days30.rawValue
        btnFilterButton3.tag = FilterButton.days90.rawValue
    }
    
    private func loadTransactions(forFilter filter: FilterButton, withCompletion completion: @escaping (Bool) -> ()) {
        guard let initialDate = filter.getInitialDate(fromDate: Date()) else { return }
        guard let card = AppContext.shared.user.selectedCard else { return }
        let finalDate = Date()

        LoadingVC.instance.show()
        TransactionService.instance.getTransactions(forPage: self.currentPage, andInitialDate: initialDate, andFinalDate: finalDate, ofCard: card) { (transactions, transactionsTotal, error) in
            LoadingVC.instance.hide()
            if let error = error {
                self.handleNetworking(error: error, forViewController: self, completion: nil)
                completion(false)
                
            } else {
                _ = self.currentPage == 1 ? self.transactions = transactions : self.transactions.append(contentsOf: transactions)
                self.totalTransacations = transactionsTotal
                
                self.currentPage += 1
                self.tvTransactions.reloadData()
                completion(true)
            }
        }
    }
    
    private func updateInfo(forCard card: Card?) {
        if let card = card {
            AppContext.shared.user.selectedCard = card
            
        } else if CardService.instance.cards.count > 0 {
            AppContext.shared.user.selectedCard = CardService.instance.cards[0]
        }
        lbTitle.text = AppContext.shared.user.selectedCard != nil ? AppContext.shared.user.selectedCard!.label : Constants.APLICATION._APP_NAME
        
        if let _ = AppContext.shared.user.selectedCard, let selectedFilterButton = selectedFilterButton {
            if let filterButton = selectedFilterButton == .days15 ? btnFilterButton1 : selectedFilterButton == .days30 ? btnFilterButton2 : selectedFilterButton == .days90 ? btnFilterButton3 : btnFilterButton1 {
                applyTransactionFilter(forFilterButton: filterButton)
            }
        }
    }
    
    private func configureCardCollection() {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        
        let layout = cvCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: 180.0)
        cvCollection.contentInset = UIEdgeInsets(top: 0.0, left: insetX, bottom: 0.0, right: insetX)
        
        if let cardOffset = cardOffset {
            cvCollection.contentOffset = cardOffset
        }
    }
    
    private func setIndicatorPositionFor(filterButton button: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.vwIndicator.center.x = self.svFilterButtons.frame.origin.x + button.frame.midX
            
        }) { (_) in
            self.btnFilterButton1.setTitleColor(UIColor.secondaryFontColor, for: UIControl.State())
            self.btnFilterButton2.setTitleColor(UIColor.secondaryFontColor, for: UIControl.State())
            self.btnFilterButton3.setTitleColor(UIColor.secondaryFontColor, for: UIControl.State())

            button.setTitleColor(UIColor.highlightFontColor, for: UIControl.State())
        }
    }
    
    private func applyTransactionFilter(forFilterButton button: UIButton) {
        setIndicatorPositionFor(filterButton: button)
        selectedFilterButton = FilterButton(rawValue: button.tag)
        
        self.currentPage = 1
        self.transactions.removeAll()
        self.tvTransactions.reloadData()
        serviceExecute { logged in
            if logged {
                self.loadTransactions(forFilter: self.selectedFilterButton!) { (loaded) in
                    if loaded {
                        if self.transactions.count == 0 {
                            self.vwFooterContainer.frame.size.height = FooterContainerHeight.noRecords.rawValue
                            self.footerViewTopConstraint.constant = FooterTopConstraint.noRecords.rawValue
                        } else {
                            self.vwFooterContainer.frame.size.height = FooterContainerHeight.normal.rawValue
                            self.footerViewTopConstraint.constant = FooterTopConstraint.normal.rawValue
                        }
                    }
                }
                
            } else {
                self.showGenericErrorAlert(forController: self)
            }
        }
    }
    
    private func associateNetwork() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse  {
            performSegue(withIdentifier: "associatedNetworkVCSegue", sender: nil)
            
        } else if CLLocationManager.authorizationStatus() == .denied {
            performSegue(withIdentifier: "noGeoLocationVCSegue", sender: nil)
            
        } else if CLLocationManager.authorizationStatus() == .notDetermined {
            performSegue(withIdentifier: "requestGeoLocationVCSegue", sender: nil)
        }
    }
    
    private func qrCodeCapture() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            performSegue(withIdentifier: "qrCodeReaderVCSegue", sender: nil)
            
        } else if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "qrCodeReaderVCSegue", sender: nil)
                    }
                    
                } else {
                    self.closeViewController()
                }
            }
            
        } else if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            showAlert(forController: self, message: "O aplicativo não possui acesso à câmera para a leitura do QRCode", messageImage: Constants.IMAGES._ALERT_GREEN_IMAGE, messageAlignment: .center, leftButtonTitle: nil, rightButtonTitle: "Dar permissão", canCloseClickingOutside: true, withId: "privacySettingsAlert", sender: nil)
        }
    }
    
    @objc private func updateCardBalance() {
        serviceExecute { logged in
            if logged {
                if let selectedCard = AppContext.shared.user.selectedCard {
                    LoadingVC.instance.show()
                    CardService.instance.getBalance(forCard: selectedCard) { (balance, error) in
                        LoadingVC.instance.hide()
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                            
                        } else if let index = CardService.instance.cards.firstIndex(where: { $0.id == selectedCard.id }) {
                                CardService.instance.cards[index].balance = balance
                                self.cvCollection.reloadItems(at: [IndexPath(item: index, section: 0)])
                        }
                    }
                }
                
            } else {
                self.showGenericErrorAlert(forController: self)
            }
        }
    }
    
    @objc private func reloadTableView() {
        tvTransactions.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func didTapAssociatedNetworkButton(_ sender: UITapGestureRecognizer) {
        associateNetwork()
    }
    
    @IBAction func didTapQRCodeReaderButton(_ sender: UITapGestureRecognizer) {
        qrCodeCapture()
    }
    
    @IBAction func didTapTransactionFilterButton(_ sender: UIButton) {
        applyTransactionFilter(forFilterButton: sender)
    }

    // MARK: - Unwind Segues
    @IBAction func homeUnwindAction(unwindSegue: UIStoryboardSegue) { }
    
}


// MARK: - AlertDelegate
extension HomeVC: AlertDelegate {

    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right {
            if id == "privacySettingsAlert" {
                Utils.openAppSettings(withCompletion: nil)
                
            } else if id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
                checkConnection()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let transactionCell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as? TransactionCell {
            transactionCell.transaction = transactions[indexPath.row]
            return transactionCell
        }
        return TransactionCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.SIZES._TRANSACTION_CELL_HEIGHT
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == transactions.count - 1 {
            if transactions.count < totalTransacations {
                serviceExecute { logged in
                    if logged {
                        self.loadTransactions(forFilter: self.selectedFilterButton ?? .days15) { (loaded) in
                            if loaded {
                                self.perform(#selector(self.reloadTableView), with: nil, afterDelay: 0.5)
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


// MARK: - UICollectionViewDelegate, UIColletionViewDataSource
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CardService.instance.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell {
            cardCell.card = CardService.instance.cards[indexPath.row]
            return cardCell
        }
        
        return CardCell()
    }
    
}


// MARK: - UIScrollViewDelegate
extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == cvCollection {
            var currentCellOffset: CGPoint = cvCollection.contentOffset
            currentCellOffset.x += cvCollection.frame.size.width / 2
            let indexPath: IndexPath? = cvCollection.indexPathForItem(at: currentCellOffset)
            if let indexPath = indexPath {
                //cvCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                pcPages.currentPage = indexPath.item
                
                AppContext.shared.user.selectedCard = CardService.instance.cards[indexPath.item]
                updateInfo(forCard: AppContext.shared.user.selectedCard)
            }
        }
    }
    
}

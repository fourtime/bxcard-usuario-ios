//
//  BaseVC.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.windowBackground
        configureLoading()
        
        NotificationCenter.default.addObserver(self, selector: #selector(lostConnection(_:)), name: Notification.Name(Constants.NOTIFICATIONS._UNREACHABLE_CONNECTION_NOTIFICATION), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.NOTIFICATIONS._UNREACHABLE_CONNECTION_NOTIFICATION), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    // MARK: - Keyboard Notifications
    @objc func keyboardWillAppear(_ notification: Notification) { }
    
    @objc func keyboardWillDisappear(_ notification: Notification) { }
    
    @objc func keyboardDidDisappear(_ notification: Notification) { }
    
    @objc func lostConnection(_ notification: Notification) { }
    
    // MARK: - Utils
    func configureScreen() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func handleNetworking(error: Error, forViewController vc: BaseVC, completion: (() -> ())?) {
        if Constants.ERRORS.isCatchedError(error: error) {
            if completion == nil {
                self.showAlert(forController: vc, message: error._domain, messageImage: Constants.IMAGES._ALERT_GREEN_IMAGE, messageAlignment: .center, leftButtonTitle: nil, rightButtonTitle: "Ok", canCloseClickingOutside: true, withId: "", sender: nil)
                
            } else {
                completion?()
            }
            
        } else {
            self.showGenericErrorAlert(forController: vc)
        }
    }
    
    func serviceExecute(completion: @escaping (Bool) -> ()) {
        let user = AppContext.shared.user
        if let username = user.login, let password = user.password, user.isAuthenticated == false {
            LoadingVC.instance.show()
            UserService.shared.authenticate(login: username, password: password) { (error) in
                LoadingVC.instance.hide()
                
                if let error = error {
                    self.handleNetworking(error: error, forViewController: self, completion: nil)
                    completion(false)
                } else {
                    completion(true)
                }
            }
            
        } else {
            completion(true)
        }
    }
    
    // MARK: - ViewControllers
    func instantiateViewControllerFrom(storyBoardName: String, withIdentifier identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    func closeViewController(_ animated: Bool = true) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Alerts
    func showAlert(forController vc: UIViewController, title: String, message: String, leftButtonTitle: String?, rightButtonTitle: String, closeButtonImage: UIImage?, withId id: String, sender: Any?) {
        if let alertVC = instantiateAlert(forController: vc, title: title, message: message, messageImage: nil, messageAlignment: nil, leftButtonTitle: leftButtonTitle, leftButtonType: nil, leftButtonBorderColor: nil, rightButtonTitle: rightButtonTitle, rightButtonType: nil, rightButtonBorderColor: nil, closeButtonImage: closeButtonImage, canCloseClickingOutside: true, withId: id, sender: sender) {
            self.present(alertVC, animated: false, completion: nil)
        }
    }
    
    func showAlert(forController vc: UIViewController, title: String, message: String, leftButtonTitle: String?, leftButtonType: ButtonType?, leftButtonBorderColor: UIColor?, rightButtonTitle: String, rightButtonType: ButtonType?, rightButtonBorderColor: UIColor?, closeButtonImage: UIImage?, withId id: String, sender: Any?) {
        if let alertVC = instantiateAlert(forController: vc, title: title, message: message, messageImage: nil, messageAlignment: nil, leftButtonTitle: leftButtonTitle, leftButtonType: leftButtonType, leftButtonBorderColor: leftButtonBorderColor, rightButtonTitle: rightButtonTitle, rightButtonType: rightButtonType, rightButtonBorderColor: rightButtonBorderColor, closeButtonImage: closeButtonImage, canCloseClickingOutside: true, withId: id, sender: sender) {
            present(alertVC, animated: false, completion: nil)
        }
    }
    
    func showAlert(forController vc: UIViewController, message: String, messageImage: UIImage?, messageAlignment: NSTextAlignment?, leftButtonTitle: String?, rightButtonTitle: String?,  canCloseClickingOutside: Bool = true, withId id: String, sender: Any?) {
        if let alertVC = instantiateAlert(forController: vc, title: nil, message: message, messageImage: messageImage, messageAlignment: messageAlignment, leftButtonTitle: leftButtonTitle, leftButtonType: nil, leftButtonBorderColor: nil, rightButtonTitle: rightButtonTitle, rightButtonType: .normal, rightButtonBorderColor: nil, closeButtonImage: nil, canCloseClickingOutside: canCloseClickingOutside, withId: id, sender: sender) {
            present(alertVC, animated: false, completion: nil)
        }
    }
    
    func showNetworkConnectionAlert(forController vc: UIViewController) {
        showAlert(forController: vc, message: "Parece que você está sem conexão com a internet, tente novamente.", messageImage: Constants.IMAGES._CONNECTION_ERROR_IMAGE, messageAlignment: NSTextAlignment.center, leftButtonTitle: nil, rightButtonTitle: "Tentar novamente", canCloseClickingOutside: false, withId: Constants.ALERTS._CHECK_CONNECTION_ALERT_ID, sender: nil)
    }
    
    func showPicker(forController controller: UIViewController, withData data: [PickerData], withSelectedData selectedData: PickerData?, andId id: String) {
        if let pickerVC = instantiateViewControllerFrom(storyBoardName: "Alerts", withIdentifier: "PickerVC") as? PickerVC {
            pickerVC.dataArray = data
            pickerVC.dataId = id
            pickerVC.dataAlreadySelected = selectedData
            pickerVC.delegate = controller as? PickerDelegate
            pickerVC.cancelButtonTitleColor = UIColor.white
            pickerVC.cancelButtonBackgroundColor = UIColor.clear
            pickerVC.selectButtonTitleColor = UIColor.white
            pickerVC.selectButtonBackgroundColor = UIColor.clear
            pickerVC.toolbarColor = UIColor.enabledDegradeDarkColor
            
            controller.providesPresentationContextTransitionStyle = true
            controller.definesPresentationContext = true
            pickerVC.modalPresentationStyle = .overCurrentContext
            
            controller.present(pickerVC, animated: false, completion: nil)
        }
    }
    
    func showGenericErrorAlert(forController vc: UIViewController) {
        if let alertVC = instantiateAlert(forController: vc, title: nil, message: "Ops! Ocorreu um erro inesperado.\nCaso persista, entre em contato conosco.", messageImage: Constants.IMAGES._ALERT_GREEN_IMAGE, messageAlignment: .center, leftButtonTitle: nil, leftButtonType: nil, leftButtonBorderColor: nil, rightButtonTitle: "Fechar", rightButtonType: .normal, rightButtonBorderColor: nil, closeButtonImage: nil, canCloseClickingOutside: true, withId: "", sender: nil) {
            present(alertVC, animated: false, completion: nil)
        }
    }
    
    func showTextAlert(forController controller: UIViewController, withTextType textType: TextType) {
        if let textVC = instantiateViewControllerFrom(storyBoardName: "Alerts", withIdentifier: "TextViewVC") as? TextViewVC {
            textVC.textType = textType
            
            controller.providesPresentationContextTransitionStyle = true
            controller.definesPresentationContext = true
            textVC.modalPresentationStyle = .overCurrentContext
            
            controller.present(textVC, animated: false, completion: nil)
        }
    }
    
    func showSelectedAssociatedInfo(forController controller: UIViewController, withAssociated associated: Associated) {
        if let selectedAssociatedVC = instantiateViewControllerFrom(storyBoardName: "Alerts", withIdentifier: "SelectedAssociatedVC") as? SelectedAssociatedVC {
            selectedAssociatedVC.associated = associated
            selectedAssociatedVC.delegate = controller as? SelectedAssociatedDelegate
            
            controller.providesPresentationContextTransitionStyle = true
            controller.definesPresentationContext = true
            selectedAssociatedVC.modalPresentationStyle = .overCurrentContext
            
            controller.present(selectedAssociatedVC, animated: false, completion: nil)
        }
    }
    
    // MARK: - Menus
    func openMenuController (_ controller: UIViewController){
        if let navController = revealViewController().frontViewController as? UINavigationController {
            navController.setViewControllers([controller], animated: false)
            revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
    }
    
    func configureRevealMenu(_ button: UIButton) {
        if let revealViewController = revealViewController() {
            button.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            view.addGestureRecognizer(revealViewController.panGestureRecognizer())
            revealViewController.rearViewRevealWidth = revealViewController.frontViewController.view.bounds.width - 40
        }
    }
    
    // MARK: - Private Methods
    private func instantiateAlert(forController vc: UIViewController, title: String?, message: String, messageImage: UIImage?, messageAlignment: NSTextAlignment?, leftButtonTitle: String?, leftButtonType: ButtonType?, leftButtonBorderColor: UIColor?, rightButtonTitle: String?, rightButtonType: ButtonType?, rightButtonBorderColor: UIColor?, closeButtonImage: UIImage?, canCloseClickingOutside: Bool, withId id: String, sender: Any?) -> AlertVC? {
        if let alertVC = instantiateViewControllerFrom(storyBoardName: "Alerts", withIdentifier: "AlertVC") as? AlertVC {
            alertVC.messageImage = messageImage
            alertVC.messageTitle = title
            alertVC.messageDescription = message
            alertVC.messageDescriptionAlignment = messageAlignment ?? .left
            alertVC.leftButtonTitle = leftButtonTitle
            alertVC.leftButtonType = leftButtonType
            alertVC.leftButtonBorderColor = leftButtonBorderColor
            alertVC.rightButtonTitle = rightButtonTitle
            alertVC.rightButtonType = rightButtonType
            alertVC.rightButtonBorderColor = rightButtonBorderColor
            alertVC.closeButtonImage = closeButtonImage
            alertVC.canCloseClickingOutside = canCloseClickingOutside
            alertVC.delegate = vc as? AlertDelegate
            alertVC.alertId = id
            alertVC.sender = sender
            
            providesPresentationContextTransitionStyle = true
            definesPresentationContext = true
            alertVC.modalPresentationStyle = .overCurrentContext
            
            return alertVC
        }
        
        return nil
    }
    
    private func configureLoading() {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.addSubview(LoadingVC.instance.view)
        }
        
        LoadingVC.instance.view.setNeedsDisplay()
    }
    
}

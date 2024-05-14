//
//  Constants.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 20/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Enums
enum Environment {
    case prd
    case hmg
}

class Constants {
    // MARK: - Private Properties
    private static let _ENVIRONMENT: Environment = .prd
    
    
    // MARK: - Public Properties
    static func isProductionEnvironment() -> Bool {
        return _ENVIRONMENT == .prd
    }
    
    // MARK: - Alerts ID's
    class ALERTS {
        static let _CHECK_CONNECTION_ALERT_ID = "tryNewConnectionAlert"
    }

    // MARK: - API Keys
    class APIS {
        static let _GOOGLE_MAPS_API_KEY = "AIzaSyAU51kt98S9kojLYcbAp0dQqsVHM4WUCg0"
    }
    
    // MARK: - Application Info
    class APLICATION {
        static let _APP_NAME = "BXCard"
    }
    
    // MARK: - Auth Credentials
    class AUTH {
        static let _APPLICATION_TOKEN = _ENVIRONMENT == .hmg ? "dd0717cc-5644-4d1b-a513-75b7bc0d7eed:b9bC1a60#68F24ff38EC2_@a62c8267Z30aV" : "dd0717cc-5644-4d1b-a513-75b7bc0d7eed:b9bC1a60#68F24ff38EC2_@a62c8267Z30aV"
        static let _OPERATOR_CODE = _ENVIRONMENT == .hmg ? 22 : 23
        static let _PADDED_OPERATOR_CODE = String(describing: _OPERATOR_CODE).paddingToLeft(upTo: 3, using: "0")
        static let _USER_TOKEN = _ENVIRONMENT == .hmg ? "44f2f865-f1e5-48d2-9554-5f5520b8b6e7:Z1df2dX632|d2c4P459b79c2-Eaebba3cfe#" : "44f2f865-f1e5-48d2-9554-5f5520b8b6e7:Z1df2dX632|d2c4P459b79c2-Eaebba3cfe#"
    }
    
    // MARK: - Color Constants
    class COLORS {
        static let _GRADIENT_ENABLED_COLORS: [UIColor] = [UIColor.enabledDegradeDarkColor, UIColor.enabledDegradeLightColor]
        static let _GRADIENT_DISABLED_COLORS: [UIColor] = [UIColor.disabledDegradeDarkColor, UIColor.disabledDegradeLightColor]
        static let _GRADIENT_ERROR_COLORS: [UIColor] = [UIColor.attentionDegradeDarkColor, UIColor.attentionDegradeLightColor]
    }
    
    // MARK: - Errors
    class ERRORS {
        static let _CATCHED_ERROR: [String : Any] = ["catchedError" : true]
        
        static func isCatchedError(error: Error?) -> Bool {
            return true
            if let error = error, let userInfo = error as? [String : Any], let catchedErrorFlag = userInfo["catchedError"] as? Bool, catchedErrorFlag {
                return true
            }
            
            return false
        }
    }
    
    // MARK: - Images
    class IMAGES {
        static let _ALERT_GREEN_IMAGE = UIImage(named: "image-alert-green")
        static let _CANCEL_GRAY_IMAGE = UIImage(named: "icon-cancel-gray")
        static let _TEXTFIELD_ERROR_IMAGE = UIImage(named: "icon-error-red")
        static let _CONNECTION_ERROR_IMAGE = UIImage(named: "icon-connection-error")
        
        static let _GSM_MARKER_IMAGE = UIImage(named: "image-location")
        static let _GSM_MARKER_SELECTED_IMAGE = UIImage(named: "image-location-selected")
    }
    
    // MARK: - Masks
    class MASKS {
        static let _DEFAULT_DATE_TIME = "yyyy-MM-dd'T'HH:mm:ss"
        static let _BR_DATE = "dd/MM/yyyy"
        static let _BR_DATE_TIME = "dd/MM/yyyy HH:mm:ss"
        static let _BR_DATE_TIME_NO_SECONDS = "dd/MM/yyyy HH:mm"
        static let _BR_SHORT_TIME = "HH:mm"
        static let _BR_TIME = "HH:mm:ss"
        static let _US_DATE = "yyyy-MM-dd"
    }
    
    // MARK: - Error Messages
    class MESSAGES {
        static let _NETWORK_UNCATCHED_ERROR = "error.message.no_connection".localized
        static let _NO_HTTP_RESPONSE_ERROR = "No http response code"
        static let _PASSWORD_ENCRYPT_ERROR = "Password encryption failed"
    }
    
    // MARK: - Custom Notifications
    class NOTIFICATIONS {
        static let _DELETE_EDIT_TEXT_CHAR_NOTIFICATION = "DeleteEditTextCharNotification"
        static let _REACHABLE_CONNECTION_NOTIFICATION = "ReachableConnectionNotification"
        static let _UNREACHABLE_CONNECTION_NOTIFICATION = "UnreachableConnectionNotification"
        static let _PAYMENT_CONFIRMATION_NOTIFICATION = "PaymentConfirmationNotification"
        static let _SELECTED_ASSOCIATED_FROM_FILTER_NOTIFICATION = "SelectedAssociatedFromFilterNotification"
    }
    
    // MARK: - Pagination
    class PAGINATION {
        static let _PAGE_SIZE = 10
    }
    
    // MARK: - Regex
    class REGEX {
        static let _EMAIL_VALIDATE_REGEX = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        static let _PASSWORD_VALIDATE_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
    }
    
    // MARK: - Sizes
    class SIZES {
        static let _CAPTURE_RECT_MARGIN: CGFloat = 63.0
        static let _CAPTURE_INSTRUCTION_DOWN_MARGIN: CGFloat = 10.0
        static let _CARD_CELL_HEIGHT: CGFloat = 180.0
        static let _TRANSACTION_CELL_HEIGHT: CGFloat = 70.0
    }
    
    // MARK: - URL Constants
    class URLS {
        // MARK: - Private Properties
        private static let _HOST_URL = _ENVIRONMENT == .hmg ? "https://www3.tln.com.br": "https://www1.tln.com.br"
        private static let _SECURITY_URL = "\(_HOST_URL)/security"
        private static let _SERVICES_URL = "\(_HOST_URL)/services"
        private static let _QUERIES_URL = "\(_SERVICES_URL)/consulta"
        private static let _TRANSACTION_URL = "\(_SERVICES_URL)/transacao"
        private static let _USER_URL = "\(_SERVICES_URL)/usuario"
        
        // MARK: - Public Properties
        static let _TOKEN_REQUEST_URL = "\(_SECURITY_URL)/authentication/token"
        
        static let _CHANGE_USER_PASSWORD_URL = "\(_USER_URL)/mobile/alterasenha"
        static let _RECOVER_USER_PASSWORD_URL = "\(_USER_URL)/mobile/reiniciasenha"
        
        static let _USER_INITIALIZE_URL = "\(_USER_URL)/mobile/inicializaapp"
        static let _USER_PROFILE_URL = "\(_USER_URL)/mobile/perfil"
        static let _CHANGE_USER_PROFILE_URL = "\(_USER_URL)/mobile/alteraperfil"
        static let _USER_CARDS_URL = "\(_QUERIES_URL)/cartao/cartoesusuario"
        
        static let _TRANSACTIONS_URL = "\(_QUERIES_URL)/cartao/extrato"
        
        static let _USE_TERMS_URL = "\(_USER_URL)/mobile/termouso"
        static let _PRIVACY_POLITICS_URL = "\(_USER_URL)/mobile/politicaprivacidade"
        static let _USEFULL_LINKS_URL = "\(_USER_URL)/mobile/linksuteis"
        
        static let _PAYMENT_IDENTIFICATION_URL = "\(_TRANSACTION_URL)/cartao/identificatopkenpagamento"
        static let _PAYMENT_URL = "\(_TRANSACTION_URL)/cartao/pagamentoviatoken"
        
        static let _ASSOCIATED_DATA_URL = "\(_QUERIES_URL)/cartao/dadoscredenciado"
        static let _SEGMENTS_URL = "\(_QUERIES_URL)/cartao/segmentos"
        static let _ACTIVITIES_URL = "\(_QUERIES_URL)/cartao/atividades"
        static let _SPECIALTIES_URL = "\(_QUERIES_URL)/cartao/especialidades"
        static let _STATES_URL = "\(_QUERIES_URL)/cartao/ufs"
        static let _CITIES_URL = "\(_QUERIES_URL)/cartao/cidades"
        static let _NEIGHBORHOODS_URL = "\(_QUERIES_URL)/cartao/bairros"
        static let _ASSOCIATED_SEARCH_URL = "\(_QUERIES_URL)/cartao/redecredenciada"
        static let _ASSOCIATED_GEOLOCATION_SEARCH_URL = "\(_QUERIES_URL)/cartao/redecredenciadagl"
        static let _CARD_BALANCE_URL = "\(_QUERIES_URL)/cartao/saldo"
        
        static let _PROFILE_PHOTO_DOWNLOAD_URL = "\(_USER_URL)/mobile/fotoperfil"
        static let _PROFILE_PHOTO_UPLOAD_URL = "\(_USER_URL)/mobile/definefotoperfil"
        
        static let _FIREBASE_TOKEN_SAVE_URL = "\(_USER_URL)/mobile/configurainstanciaapp"
    }
    
}

//
//  ProfileService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 23/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class ProfileService: BaseService {
    
    // MARK: - Singleton
    static let instance = ProfileService()
    
    // MARK: - Public API
    func getProfilePhoto(withCompletion completion: @escaping (UIImage?, Error?) -> ()) {
        request(Constants.URLS._PROFILE_PHOTO_DOWNLOAD_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: userAuthHeader()).responseData(completionHandler: { (response) in
            if response.error == nil, let imageData = response.data {
                completion(UIImage(data: imageData), nil)
                
            } else {
                completion(nil, response.error)
            }
        })
    }
    
    func saveProfilePhoto(photo: UIImage?, withCompletion completion: @escaping (Error?) -> ()) {
        if let photoData = photo?.jpegData(compressionQuality: 0.3) {
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(photoData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            }, to: Constants.URLS._PROFILE_PHOTO_UPLOAD_URL, usingThreshold: MultipartFormData.encodingMemoryThreshold, method: .post, headers: userAuthHeader()).response { (response) in
                switch response.result {
                case .success(_):
                    completion(nil)

                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
}

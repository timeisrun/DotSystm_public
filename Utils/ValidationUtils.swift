//
//  ValidationUtils.swift
//  DotSystem
//
//  Created by ccc on 2022/1/23.
//

import Foundation

enum AppDataErrorType {
    case isNewVersion
    case haveNewVersion
    case urlError
    case urlGetDataError
    case convertJsonError
    case resultsFieldError
    case resultsArrayCountError
    case versionFieldError
    case releaseNotesFieldError
    case localVersionNumError
}

class ValidationUtils {
    
    // 檢查是否有新版本
    // (_ appDataErrorType: AppDataErrorType, _ version: String?, _ releaseNotes: String?)
    static func checkVersionProcess(completion: @escaping (AppDataErrorType, String?, String?) -> Void) {
        
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(CommonUtils.appID)") else {
            completion(.urlError, nil, nil)
            return
        }
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch _ as NSError {
            completion(.urlGetDataError, nil, nil)
            return
        }
        
        let json: [String: Any]
        do {
            let tmpJson = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            
            guard let tmp2Json = tmpJson as? [String: Any] else {
                completion(.convertJsonError, nil, nil)
                return
            }
            
            json = tmp2Json
            
        } catch _ as NSError {
            completion(.convertJsonError, nil, nil)
            return
        }
        
        guard let results = json["results"] as? [Dictionary<String, Any>] else {
            completion(.resultsFieldError, nil, nil)
            return
        }
        
        if results.count < 1 {
            completion(.resultsArrayCountError, nil, nil)
            return
        }
        
        let appData = results[0]
        
        guard let version = appData["version"] as? String else {
            completion(.versionFieldError, nil, nil)
            return
        }
        
        guard let releaseNotes = appData["releaseNotes"] as? String else {
            completion(.releaseNotesFieldError, nil, nil)
            return
        }
        
        // 判斷是否為新版本
        guard let appVersion1 = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            completion(.localVersionNumError, nil, nil)
            return
        }
        
        // 本機版本大於等於最新版本, 則不需更新
        if appVersion1 >= version {
            completion(.isNewVersion, version, releaseNotes)
            return
        }
        
        completion(.haveNewVersion, version, releaseNotes)
    }
    
}

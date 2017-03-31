//
//  UserPreferences.swift
//  wirk
//
//  Created by Edward on 3/30/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation

class UserPreferences {
    
    // MARK: User Company Preferences
    static func updatePreferencesToUserDefaults(companyName: String, emailSubject: String, emailMessage: String) {
        guard let uid = System.uid else { return }
        let userDefaults = UserDefaults.standard
        let preferences: [String: String] = ["\(uid)_company_name": companyName,
                                          "\(uid)_email_subject": emailSubject,
                                          "\(uid)_email_message": emailMessage]
        userDefaults.setValuesForKeys(preferences)
    }
    
    static func getCompanyName() -> String? {
        guard let uid = System.uid else { return nil }
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "\(uid)_company_name")
    }
    
    static func getEmailSubject() -> String? {
        guard let uid = System.uid else { return nil }
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "\(uid)_email_subject")
    }
    
    static func getEmailMessage() -> String? {
        guard let uid = System.uid else { return nil }
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "\(uid)_email_message")
    }
}

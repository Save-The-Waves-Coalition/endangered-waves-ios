//
//  Extension + UserDefault.swift
//
//
import Foundation

enum UserDefaultKeys: String {
    case currentUser       = "currentLoginUser"
}

/*####################################################
 #### function storg value on user default using key and value
####################################################*/

func store_in_userdefault<T>(value: T?, key: UserDefaultKeys) {
    UserDefaults.standard.setValue(value, forKey: key.rawValue)
    UserDefaults.standard.synchronize()
}

/*####################################################
 #### function get value from user default using key
 ####################################################*/

func read_from_userdefault<T>(key: UserDefaultKeys) -> T? {
    return UserDefaults.standard.value(forKey: key.rawValue) as? T
}

/*####################################################
 #### function get value from user default using key
 ####################################################*/

func delete_from_userdefault(key: UserDefaultKeys) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
    UserDefaults.standard.synchronize()
}

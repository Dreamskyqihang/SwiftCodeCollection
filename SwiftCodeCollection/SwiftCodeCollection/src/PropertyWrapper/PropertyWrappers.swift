//
//  PropertyWrappers.swift
//  SwiftCodeCollection
//
//  Created by 张鸿运 on 2020/12/5.
//

import UIKit
import Foundation


/// 对UserDefaults的封装
/// 特性：1.可以存储遵循Codable协议的自定义 Class 和 Struct
///      2.可以支持不同的UserDefaults，在App Group之间共享数据
@propertyWrapper
public struct UserDefaultEncoded<T: Codable> {
    let defaultsName: String?
    let key: String
    let defaultValue: T

    /// Init
    /// - Parameters:
    ///   - defaultsName: UserDefault SuitName (App Group Name)
    ///   - key: UserDefaults Key
    ///   - default: UserDefaults default Value
    init(defaultsName: String? = nil, key: String, default: T) {
        self.defaultsName = defaultsName
        self.key = key
        defaultValue = `default`
    }

    public var wrappedValue: T {
        
        get {
            var userDefaults: UserDefaults = UserDefaults.standard
            if let defaultName = defaultsName {
                userDefaults = UserDefaults(suiteName: defaultName) ?? UserDefaults.standard
            }
            guard let jsonString = userDefaults.string(forKey: key) else {
                return defaultValue
            }
            guard let jsonData = jsonString.data(using: .utf8) else {
                return defaultValue
            }
            guard let value = try? JSONDecoder().decode(T.self, from: jsonData) else {
                return defaultValue
            }
            return value
        }
        
        set {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            guard let jsonData = try? encoder.encode(newValue) else { return }
            let jsonString = String(bytes: jsonData, encoding: .utf8)
            var userDefaults: UserDefaults = UserDefaults.standard
            if let defaultName = defaultsName {
                userDefaults = UserDefaults(suiteName: defaultName) ?? UserDefaults.standard
            }
            userDefaults.set(jsonString, forKey: key)
        }
    }
}

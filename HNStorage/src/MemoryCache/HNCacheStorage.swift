//
//  HNCacheStorage.swift
//  HNStorage
//
//  Created by Hadi Nourallah on 2021-01-08.
//

import Foundation

//struct+classWrapper wrapper
fileprivate class StructWrapper: NSObject {
    let value: Storable?
    let objcValue: AnyObject?
    
    init(_ value: Storable?, objcValue: AnyObject?) {
        self.value = value
        self.objcValue = objcValue
    }
}

final public class HNCacheStorage: Storage {
    private static let cache = NSCache<NSString, StructWrapper>.init()

    public init(id: String?) { }
    
    public func insert(_ object: Storable) {
        let wrapper = StructWrapper(object, objcValue: nil)
        HNCacheStorage.cache.setObject(wrapper, forKey: object.primaryKey as NSString)
    }
    
    public func update(_ object: Storable) {
        let wrapper = StructWrapper(object, objcValue: nil)
        HNCacheStorage.cache.setObject(wrapper, forKey: object.primaryKey as NSString)
    }
    
    public func delete(_ object: Storable) {
        HNCacheStorage.cache.removeObject(forKey: object.primaryKey as NSString)
    }
    
    public func exists(_ object: Storable) -> Bool {
        return HNCacheStorage.cache.object(forKey: object.primaryKey as NSString) != nil
    }

    public func get<T>(_ key: String) throws -> T? where T : Storable {
        return HNCacheStorage.cache.object(forKey: key as NSString)?.value as? T
    }
}

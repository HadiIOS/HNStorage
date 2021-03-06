//
//  HNDiskStorage.swift
//  HNStorage
//
//  Created by Hadi Nourallah on 2021-01-08.
//

import Foundation

final public class HNDiskStorage: Storage {
    private let destination: URL

    
    public init(id: String?) {
        let documentFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.destination = URL(fileURLWithPath: documentFolder).appendingPathComponent(id ?? "HNStorageDestFolder", isDirectory: true)
        try? FileManager.default.createDirectory(at: self.destination, withIntermediateDirectories: true, attributes: nil)
    }
    
    public func insert(_ object: Storable) throws {
        let data = try object.encode()
        let d = self.destination.appendingPathComponent(object.primaryKey, isDirectory: false)
        try? delete(object) //it will fail in case file doesn't exist
        try data.write(to: d, options: [.atomic])
    }
    
    public func update(_ object: Storable) throws {
        try insert(object)
    }
    
    public func delete(_ object: Storable) throws {
        let d = destination.appendingPathComponent(object.primaryKey, isDirectory: false)
        try FileManager.default.removeItem(at: d)
    }
    
    public func exists(_ object: Storable) throws -> Bool {
        return FileManager.default.fileExists(atPath: destination.appendingPathComponent(object.primaryKey, isDirectory: false).absoluteString)
    }
    
    public func get<T>(_ key: String) throws -> T? where T : Storable {
        guard let data = try? Data(contentsOf: destination.appendingPathComponent(key, isDirectory: false)) else { return nil }
        return try getDecoded(data: data)
    }
}

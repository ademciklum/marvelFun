//
//  DataStorage.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation

public protocol DataStorageProtocol {
    func load<T: Decodable & Storable>() -> T?
    func save<T: Encodable & Storable>(_ value: T)
}

public protocol Storable {
    var storageKey: String { get }
    static var storageKey: String { get }
}

public extension Storable {
    var storageKey: String {
        return String(describing: type(of: self))
    }
    
    static var storageKey: String {
        return String(describing: self)
    }
}

public class DataStorage: DataStorageProtocol {
    
    public enum StorageError: Error {
        case notFound
        case cantWrite(Error)
    }
    
    private let queue  = DispatchQueue(label: "DiskCache.Queue")
    private lazy var fileManager = FileManager.default
    private lazy var path: URL = {
        let appSupportURLs = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return appSupportURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
    }()
    
    private func createFolders(in url: URL) throws {
        let folderUrl = url.deletingLastPathComponent()
        if fileManager.fileExists(atPath: folderUrl.path) == false {
            try fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private func saveData(_ value: Data, for key: String) throws {
        var url = path.appendingPathComponent(key)
        
        do {
            // exclude form iCloud
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try? url.setResourceValues(resourceValues)
            // save
            try self.createFolders(in: url)
            try value.write(to: url, options: .atomic)
        } catch {
            throw StorageError.cantWrite(error)
        }
    }
    
    private func loadData(for key: String) throws -> Data {
        let url = path.appendingPathComponent(key)
        guard let data = fileManager.contents(atPath: url.path) else {
            throw StorageError.notFound
        }
        return data
    }
    
    
    public func load<T: Decodable & Storable>() -> T? {
        do {
            let data = try loadData(for: T.storageKey)
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            return nil
        }
    }

    public func save<T: Encodable & Storable>(_ value: T) {
        let data = try! JSONEncoder().encode(value)
        try! saveData(data, for: value.storageKey)
    }
}


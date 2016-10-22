//
//  Diskcached.swift
//  ImageLoader
//
//  Created by Hirohisa Kawasaki on 12/21/14.
//  Copyright © 2014 Hirohisa Kawasaki. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func escape() -> String {

        let str = CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            self as CFString!,
            nil,
            "!*'\"();:@&=+$,/?%#[]% " as CFString!,
            CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue))

        return str as! String
    }
}

open class Diskcached {

    var storedData = [URL: Data]()

    class Directory {
        init() {
            createDirectory()
        }

        fileprivate func createDirectory() {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: path) {
                return
            }

            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }

        var path: String {
            let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            let directoryName = "swift.imageloader.diskcached"

            return cacheDirectory + "/" + directoryName
        }
    }
    let directory = Directory()

    fileprivate let _subscriptQueue = DispatchQueue(label: "swift.imageloader.queues.diskcached.subscript", attributes: DispatchQueue.Attributes.concurrent)
    fileprivate let _ioQueue = DispatchQueue(label: "swift.imageloader.queues.diskcached.set", attributes: [])
}

extension Diskcached {

    public class func removeAllObjects() {
        Diskcached().removeAllObjects()
    }

    func removeAllObjects() {
        let manager = FileManager.default
        for subpath in manager.subpaths(atPath: directory.path) ?? [] {
            let path = directory.path + "/" + subpath
            do {
                try manager.removeItem(atPath: path)
            } catch _ {
            }
        }
    }

    fileprivate func objectForKey(_ aKey: URL) -> Data? {
        if let data = storedData[aKey] {
            return data
        }

        return (try? Data(contentsOf: URL(fileURLWithPath: _path(aKey.absoluteString))))
    }

    fileprivate func _path(_ name: String) -> String {
        return directory.path + "/" + name.escape()
    }

    fileprivate func setObject(_ anObject: Data, forKey aKey: URL) {

        storedData[aKey] = anObject

        let block: () -> Void = {
            try? anObject.write(to: URL(fileURLWithPath: self._path(aKey.absoluteString)), options: [])
            self.storedData[aKey] = nil
        }

        _ioQueue.async(execute: block)
    }
}

// MARK: ImageLoaderCacheProtocol

extension Diskcached: ImageLoaderCache {

    public subscript (aKey: URL) -> Data? {
        get {
            var data : Data?
            _subscriptQueue.sync {
                data = self.objectForKey(aKey)
            }
            return data
        }

        set {
            _subscriptQueue.async(flags: .barrier, execute: {
                self.setObject(newValue!, forKey: aKey)
            }) 
        }
    }
}

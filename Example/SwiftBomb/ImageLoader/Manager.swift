//
//  Manager.swift
//  ImageLoader
//
//  Created by Hirohisa Kawasaki on 12/7/15.
//  Copyright © 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation
import UIKit

/**
 Responsible for creating and managing `Loader` objects and controlling of `NSURLSession` and `ImageCache`
 */
open class Manager {

    let session: URLSession
    let cache: ImageLoaderCache
    let delegate: SessionDataDelegate = SessionDataDelegate()
    open var automaticallyAdjustsSize = true
    open var automaticallyAddTransition = true
    open var automaticallySetImage = true

    /**
     Use to kill or keep a fetching image loader when it's blocks is to empty by imageview or anyone.
     */
    open var shouldKeepLoader = false

    fileprivate let decompressingQueue = DispatchQueue(label: "decompressingQueue", attributes: [])

    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        cache: ImageLoaderCache = Diskcached()
        ) {
            session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
            self.cache = cache
    }

    // MARK: state

    var state: State {
        return delegate.isEmpty ? .ready : .running
    }

    // MARK: loading

    func load(_ URL: URLLiteralConvertible) -> Loader {
        if let loader = delegate[URL.imageLoaderURL as URL] {
            loader.resume()
            return loader
        }

        var request = URLRequest(url: URL.imageLoaderURL as URL)
        request.setValue("image/*", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request)

        let loader = Loader(task: task, delegate: self)
        delegate[URL.imageLoaderURL] = loader
        return loader
    }

    func suspend(_ URL: URLLiteralConvertible) -> Loader? {
        if let loader = delegate[URL.imageLoaderURL as URL] {
            loader.suspend()
            return loader
        }

        return nil
    }

    func cancel(_ URL: URLLiteralConvertible, block: Block? = nil) -> Loader? {
        return cancel(URL, identifier: block?.identifier)
    }

    func cancel(_ URL: URLLiteralConvertible, identifier: Int?) -> Loader? {
        if let loader = delegate[URL.imageLoaderURL as URL] {
            if let identifier = identifier {
                loader.remove(identifier)
            }

            if !shouldKeepLoader && loader.blocks.isEmpty {
                loader.cancel()
                _ = delegate.remove(URL.imageLoaderURL as URL)
            }
            return loader
        }

        return nil
    }

    class SessionDataDelegate: NSObject, URLSessionDataDelegate {

        fileprivate let _ioQueue = DispatchQueue(label: "_ioQueue", attributes: DispatchQueue.Attributes.concurrent)
        var loaders: [URL: Loader] = [:]

        subscript (URL: URL) -> Loader? {
            get {
                var loader : Loader?
                _ioQueue.sync {
                    loader = self.loaders[URL]
                }
                return loader
            }
            set {
                if let newValue = newValue {
                    _ioQueue.async(flags: .barrier, execute: {
                        self.loaders[URL] = newValue
                    }) 
                }
            }
        }

        var isEmpty: Bool {
            var isEmpty = false
            _ioQueue.sync {
                isEmpty = self.loaders.isEmpty
            }

            return isEmpty
        }

        fileprivate func remove(_ URL: Foundation.URL) -> Loader? {
            if let loader = loaders[URL] {
                loaders[URL] = nil
                return loader
            }
            return nil
        }

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            if let URL = dataTask.originalRequest?.url, let loader = self[URL] {
                loader.receive(data)
            }
        }

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
            completionHandler(.allow)
        }

        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let URL = task.originalRequest?.url, let loader = loaders[URL] {
                loader.complete(error as NSError?) { [unowned self] in
                    _ = self.remove(URL)
                }
            }
        }

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
            completionHandler(nil)
        }
    }

    deinit {
        session.invalidateAndCancel()
    }
}

/**
 Responsible for sending a request and receiving the response and calling blocks for the request.
 */
open class Loader {

    unowned let delegate: Manager
    let task: URLSessionDataTask
    var receivedData = NSMutableData()
    var blocks: [Block] = []

    init (task: URLSessionDataTask, delegate: Manager) {
        self.task = task
        self.delegate = delegate
        resume()
    }

    var state: URLSessionTask.State {
        return task.state
    }

    open func completionHandler(_ completionHandler: @escaping CompletionHandler) -> Self {
        let identifier = (blocks.last?.identifier ?? 0) + 1
        return self.completionHandler(identifier, completionHandler: completionHandler)
    }

    open func completionHandler(_ identifier: Int, completionHandler: @escaping CompletionHandler) -> Self {
        let block = Block(identifier: identifier, completionHandler: completionHandler)
        return appendBlock(block)
    }

    func appendBlock(_ block: Block) -> Self {
        blocks.append(block)
        return self
    }

    // MARK: task

    open func suspend() {
        task.suspend()
    }

    open func resume() {
        task.resume()
    }

    open func cancel() {
        task.cancel()
    }

    fileprivate func remove(_ identifier: Int) {
        // needs to queue with sync
        blocks = blocks.filter{ $0.identifier != identifier }
    }

    fileprivate func receive(_ data: Data) {
        receivedData.append(data)
    }

    fileprivate func complete(_ error: NSError?, completionHandler: @escaping () -> Void) {

        if let URL = task.originalRequest?.url {
            if let error = error {
                failure(URL, error: error, completionHandler: completionHandler)
                return
            }

            delegate.decompressingQueue.async { [weak self] in
                guard let wSelf = self else {
                    return
                }

                wSelf.success(URL, data: wSelf.receivedData as Data, completionHandler: completionHandler)
            }
        }
    }

    fileprivate func success(_ URL: Foundation.URL, data: Data, completionHandler: () -> Void) {
        let image = UIImage.decode(data)
        _toCache(URL, data: data)

        for block in blocks {
            block.completionHandler(URL, image, nil, .none)
        }
        blocks = []
        completionHandler()
    }

    fileprivate func failure(_ URL: Foundation.URL, error: NSError, completionHandler: () -> Void) {
        for block in blocks {
            block.completionHandler(URL, nil, error, .none)
        }
        blocks = []
        completionHandler()
    }
    
    fileprivate func _toCache(_ URL: Foundation.URL, data: Data?) {
        if let data = data {
            delegate.cache[URL] = data
        }
    }
}

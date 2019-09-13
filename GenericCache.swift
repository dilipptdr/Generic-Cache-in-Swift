//
//  GenericCache.swift
//  
//
//  Created by Dilip Patidar on 14/09/19.
//

import Foundation

// Implementing caching in swift using Generics
// Based on NSCache Foundation class which can evict objects in case of low memory warning in Least Recently Used manner
// Also, NSCahe is thread safe


// TODO: add additional features like expiry
//
protocol DPCacheProtocol {

    associatedtype Item

    init()

    ///maxItems is maximum number of items in the cache
    init(withMaxItems maxItems: Int)

    ///capacityInMB is Maximum capacity in MB
    init(withMaxSize capacityInMB: Int)

    ///Add items to the cache for a key, returns true if succeeds else false
    func addItem(_ item: Item, forKey key:AnyObject) -> Bool

    ///Remove item from the cache for a key, returns the removed Item if present else nil
    func removeItemForKey(_ key: AnyObject) -> Item?

    ///Clear the cache, return true if succeeds else false
    func clear()

}


class DPCache<T: AnyObject>: DPCacheProtocol {

    private var container = NSCache<AnyObject, T>()

    required init() {
        container.totalCostLimit = 25 * 1024 * 1024 //25MB by default
        container.countLimit = 125 // cache limit is 125 items by default
    }

    required init(withMaxSize capacityInMB: Int) {
        container.totalCostLimit = capacityInMB * 1024 * 1024
        container.countLimit = 125 // coult limit is 125 items by default
    }

    required init(withMaxItems maxItems: Int) {
        container.totalCostLimit = 25 * 1024 * 1024 //25MB by default
        container.countLimit = maxItems
    }

    func addItem(_ item: T, forKey key: AnyObject) -> Bool {
        if let item = container.object(forKey: key) {
            container.setObject(item, forKey: key)
            return false
        }
        container.setObject(item, forKey: key)
        return true
    }

    func removeItemForKey(_ key: AnyObject) -> T? {
        let item = container.object(forKey: key)
        container.removeObject(forKey: key)
        return item
    }

    func clear() {
        container.removeAllObjects()
    }
}


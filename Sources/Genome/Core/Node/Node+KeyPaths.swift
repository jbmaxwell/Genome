//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

extension Node {
    public mutating func set(val: Node, forKeyPath keyPath: String) {
        guard let object = self.objectValue else { return }
        var mutableObject = object
        
        var keys = keyPath.gnm_keypathComponents()
        guard let first = keys.first else { return }
        #if swift(>=3.0)
            keys.remove(at: 0)
        #else
            keys.removeAtIndex(0)
        #endif
        
        if keys.isEmpty {
            mutableObject[first] = val
        } else {
            #if swift(>=3.0)
                let rejoined = keys.joined(separator: ".")
            #else
                let rejoined = keys.joinWithSeparator(".")
            #endif
            var subdict: Node = mutableObject[first] ?? .object([:])
            subdict.set(val, forKeyPath: rejoined)
            mutableObject[first] = subdict
        }
        
        self = Node(mutableObject)
    }
    
    public func get(forKeyPath keyPath: String) -> Node? {
        var keys = keyPath.gnm_keypathComponents()
        guard let first = keys.first else { return nil }
        guard let value = self[first] else { return nil }
        #if swift(>=3.0)
            keys.remove(at: 0)
        #else
            keys.removeAtIndex(0)
        #endif
        
        guard !keys.isEmpty else { return value }
        #if swift(>=3.0)
            let rejoined = keys.joined(separator: ".")
        #else
            let rejoined = keys.joinWithSeparator(".")
        #endif
        return value.get(forKeyPath: rejoined)
    }
}

private extension String {
    func gnm_keypathComponents() -> [String] {
        return characters
            .split { $0 == "." }
            .map { String($0) }
    }
}
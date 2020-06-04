//
//  Reader+Collection.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Reader where Value: Collection {
    public func mapCollection<NewElement>(_ transform: @escaping (Value.Element) -> NewElement) -> Reader<Environment, [NewElement]> {
        mapValue { $0.map(transform) }
    }

    public func flatMapCollection<NewCollection: Collection>(
        _ transform: @escaping (Value.Element) -> NewCollection
    ) -> Reader<Environment, [NewCollection.Element]> {
        mapValue { $0.flatMap { transform($0) } }
    }
}

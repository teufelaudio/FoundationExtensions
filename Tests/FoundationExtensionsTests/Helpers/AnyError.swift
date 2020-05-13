//
//  AnyError.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Barbosa on 13.07.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

class AnyError: Error, Equatable, Codable {
}

func == (lhs: AnyError, rhs: AnyError) -> Bool {
    return lhs === rhs
}

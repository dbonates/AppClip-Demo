//
//  Range.swift
//  AppDemo
//
//  Created by Daniel Bonates on 14/12/21.
//

import Foundation

public extension Range where Bound: Strideable, Bound.Stride: SignedInteger {

  /// Convert to an array.
  func asArray() -> [Bound] {
    Array(self)
  }
}

public extension ClosedRange where Bound: Strideable, Bound.Stride: SignedInteger {

  /// Convert to an array.
  func asArray() -> [Bound] {
    Array(self)
  }
}

public extension Sequence {

  /// Convert to an array.
  func asArray() -> [Iterator.Element] {
    Array(self)
  }
}

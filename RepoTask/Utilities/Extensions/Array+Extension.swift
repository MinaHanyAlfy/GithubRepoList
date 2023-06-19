//
//  Array+Extension.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-19.
//

import UIKit

extension Array where Element: Equatable {
  func subtracting(_ array: [Element]) -> [Element] {
      self.filter { !array.contains($0) }
  }

  mutating func remove(_ array: [Element]) {
      self = self.subtracting(array)
  }
}

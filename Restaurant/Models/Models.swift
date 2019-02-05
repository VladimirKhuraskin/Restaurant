//
//  Models.swift
//  Restaurant
//
//  Created by Vladimir Khuraskin on 05/02/2019.
//  Copyright © 2019 Vladimir Khuraskin. All rights reserved.
//

import Foundation

struct MenuItem: Codable {
  var id: Int
  var name: String
  var detailText: String
  var price: Double
  var category: String
  var imageURL: URL

  enum CodingKeys: String, CodingKey {
    case id, name, price, category
    case detailText = "description"
    case imageURL = "image_url"
  }
}

struct MenuItems: Codable {
  let items: [MenuItem]
}

struct Categories: Codable {
  let category: [String]
}

struct PreparationTime: Codable {
  let prepTime: Int

  enum CodingKeys: String, CodingKey {
    case prepTime = "preparation_time"
  }
}

struct Order: Codable {
  var menuItems: [MenuItem]

  init(menuItems: [MenuItem] = []) {
    self.menuItems = menuItems
  }
}

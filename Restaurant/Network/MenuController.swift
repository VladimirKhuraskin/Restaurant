//
//  MenuController.swift
//  Restaurant
//
//  Created by Vladimir Khuraskin on 05/02/2019.
//  Copyright © 2019 Vladimir Khuraskin. All rights reserved.
//

import Foundation

class MenuController {
  let baseURL = URL(string: "http://api.armenu.net:8090/")!

  func fetchCategories(completion: @escaping ([String]?) -> Void) {
    let categoryURL = baseURL.appendingPathComponent("categories")

    let task = URLSession.shared.dataTask(with: categoryURL) { data, response, error in
      guard let data = data else {
        completion(nil)
        return
      }

      guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        completion(nil)
        return
      }

      guard let categories = jsonDictionary?["categories"] as? [String] else {
        completion(nil)
        return
      }

      completion(categories)
    }
    task.resume()
  }

  func fetchMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
    let initialMenuURL = baseURL.appendingPathComponent("menu")
    guard var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true) else { return }

    components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
    guard let menuURL = components.url else { return }

    let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
      guard let data = data else {
        completion(nil)
        return
      }

      guard let menuItems = try? JSONDecoder().decode(MenuItems.self, from: data) else {
        completion(nil)
        return
      }

      completion(menuItems.items)
    }
    task.resume()
  }

  func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Int?) -> Void) {
    let orderURL = baseURL.appendingPathComponent("order")

    var request = URLRequest(url: orderURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let data: [String: [Int]] = ["menuIds": menuIDs]
    let jsonData = try? JSONEncoder().encode(data)
    request.httpBody = jsonData
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        completion(nil)
        return
      }

      guard let preparationTime = try? JSONDecoder().decode(PreparationTime.self, from: data) else {
        completion(nil)
        return
      }

      completion(preparationTime.prepTime)
    }
    task.resume()
  }

}

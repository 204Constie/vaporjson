import Vapor
import VaporSQLite

let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)

drop.get { req in
  return try drop.view.make("welcome", [
  	"message": drop.localization[req.lang, "welcome", "title"]
  ])
}

drop.get("sqliteversion") { req in
  let result = try drop.database?.driver.raw("SELECT sqlite_version()")
  return try JSON(node: result)
}

drop.get("products") { req in

  // let result = try drop.database?.driver.raw("SELECT * FROM Products")
  // return try JSON(node: result)

  let result1 = try drop.database?.driver.raw("SELECT * FROM Products")
  let one = try JSON(node: ["name": "Featured", "str": result1])


  let result2 = try drop.database?.driver.raw("SELECT * FROM ExtraProducts")
  let two = try JSON(node: ["name": "Best Buy", "str": result2])

  let h = try JSON(node: [JSON(node: ["name": "Featured", "str": result1]), JSON(node:["name": "Best Buy", "str": result2])])
  return try JSON(node: ["cateories": h])

}
drop.get("productsdict") { req in

  let result = try drop.database?.driver.raw("SELECT * FROM Products")
  return try JSON(node: ["name": "Featured", "str": result])

}

drop.get("productsdictextra") { req in

  let result = try drop.database?.driver.raw("SELECT * FROM ExtraProducts")
  return try JSON(node: ["name": "Best Buy", "str": result])

}

drop.get("product", ":product_id") { req in
  if let product_id  = req.parameters["product_id"]?.string {
    let result = try drop.database?.driver.raw("SELECT * FROM Products WHERE product_id = ?", [product_id])
    return try JSON(node: result)
  }
  return "error retrieving parameters"
}

// drop.get("categorieswithbooks") { req in
//   // let ids = try drop.database?.driver.raw("SELECT category_id FROM Categories")
//   // var wrap = [String: Node]()
//   // for id in ids["category_id"] {
//   //   let books = try drop.database?.driver.raw("SELECT * FROM Products WHERE category_id=?", [id])
//   //   wrap.append("category_id": id, "books": books)
//   //select
//
//
//   // }
//   let category_id = 1
//   let wrap = try drop.database?.driver.raw("SELECT * FROM Products WHERE * IN(SELECT * FROM Categories WERE category_id=?)", [category_id, category_id])
//
//   return try JSON(node: wrap)
//
// }

drop.get("categories") { req in
  let result = try drop.database?.driver.raw("SELECT * FROM Categories")
  return try JSON(node: result)
}

drop.get("categories", ":category_id") { req in
  if let category_id  = req.parameters["category_id"]?.string {
    let result = try drop.database?.driver.raw("SELECT * FROM Categories WHERE category_id = ?", [category_id])
    return try JSON(node: result)
  }
  return "error retrieving parameters"
}

drop.post("category") { req in

  guard let category_id = req.json?["category_id"]?.string else {
    fatalError("brakuje category_id")
  }
  guard let name = req.json?["name"]?.string else {
    fatalError("brakuje name")
  }

  let result = try drop.database?.driver.raw("INSERT INTO Categories(category_id, name) VALUES(?, ?)", [category_id, name])
  return try JSON(node: result)

}

drop.post("product") { req in

  guard let product_id = req.json?["product_id"]?.string else {
    fatalError("Brakuje product_id")
  }
  guard let title = req.json?["title"]?.string else {
    fatalError("Brakuje title")
  }
  guard let author = req.json?["author"]?.string else {
    fatalError("Brakuje author")
  }
  guard let category_id = req.json?["category_id"]?.string else {
    fatalError("Brakuje category")
  }
  guard let description_text = req.json?["description_text"]?.string else {
    fatalError("Brakuje description_text")
  }
  guard let price = req.json?["price"]?.string else {
    fatalError("Brakuje price")
  }
  guard let image_name = req.json?["image_name"]?.string else {
    fatalError("Brakuje image_name")
  }

  let result = try drop.database?.driver.raw("INSERT INTO Products(product_id, title, author, description_text, category_id, price, image_name) VALUES(?, ?, ?, ?, ?, ?, ?)", [product_id, title, author, description_text, category_id, price, image_name])
  return try JSON(node: result)

}
drop.delete("product", ":product_id") { req in
  if let product_id  = req.parameters["product_id"]?.string {
    let result = try drop.database?.driver.raw("DELETE FROM Products WHERE product_id = ?", [product_id])
    return try JSON(node: result)
  }
  return "error retrieving parameters"
}
drop.post("productextra") { req in

  guard let product_id = req.json?["product_id"]?.string else {
    fatalError("Brakuje product_id")
  }
  guard let title = req.json?["title"]?.string else {
    fatalError("Brakuje title")
  }
  guard let author = req.json?["author"]?.string else {
    fatalError("Brakuje author")
  }
  guard let category_id = req.json?["category_id"]?.string else {
    fatalError("Brakuje category")
  }
  guard let description_text = req.json?["description_text"]?.string else {
    fatalError("Brakuje description_text")
  }
  guard let price = req.json?["price"]?.string else {
    fatalError("Brakuje price")
  }
  guard let image_name = req.json?["image_name"]?.string else {
    fatalError("Brakuje image_name")
  }

  let result = try drop.database?.driver.raw("INSERT INTO ExtraProducts(product_id, title, author, description_text, category_id, price, image_name) VALUES(?, ?, ?, ?, ?, ?, ?)", [product_id, title, author, description_text, category_id, price, image_name])
  return try JSON(node: result)

}
drop.get("cartitems") { req in
  let result = try drop.database?.driver.raw("SELECT * FROM cartitems")
  return try JSON(node: result)
}
drop.post("cartitems") { req in
  guard let cart_id = req.json?["cart_id"]?.string else {
    fatalError("Brakuje cart_id")
  }
  guard let amount = req.json?["amount"]?.string else {
    fatalError("Brakuje amount")
  }
  guard let product_id = req.json?["product_id"]?.string else {
    fatalError("Brakuje product_id")
  }
  guard let order_id = req.json?["order_id"]?.string else {
    fatalError("Brakuje order_id")
  }
  let result = try drop.database?.driver.raw("INSERT INTO CartItems(cart_id, amount, product_id, order_id) VALUES(?, ?, ?, ?)", [cart_id, amount, product_id, order_id])
  return try JSON(node: result)
}
drop.post("cartitems", ":product_id") { req in
  if let product_id = req.parameters["product_id"]?.string {
    let result = try drop.database?.driver.raw("DELETE FROM CartItems WHERE product_id = ?", [product_id])
    return try JSON(node: result)
  }
  return "error retrieving parameters"
}




drop.get("orders") { req in
  let result = try drop.database?.driver.raw("SELECT * FROM Orders")
  return try JSON(node: result)
}



drop.post("order") { req in
  // guard let order_id = req.json?["order_id"]?.string else {
  //   fatalError("Brakuje order_id")
  // }
  // guard let total_amount = req.json?["total_amount"]?.string else {
  //   fatalError("Brakuje total_amount")
  // }
  guard let product_id = req.json?["product_id"]?.string else {
    fatalError("Brakuje product_id")
  }

  let result = try drop.database?.driver.raw("INSERT INTO Orders(product_id) VALUES(?)", [product_id])
  return try JSON(node: result)
}
//
// drop.post("order") { req in
//   guard let order_id = req.json?["order_id"]?.string else {
//     fatalError("Brakuje order_id")
//   }
//   guard let total_amount = req.json?["total_amount"]?.string else {
//     fatalError("Brakuje total_amount")
//   }
//   guard let cart_id = req.json?["cart_id"]?.string else {
//     fatalError("Brakuje cart_id")
//   }
//
//   let result = try drop.database?.driver.raw("INSERT INTO Orders(order_id, total_amount, cart_id) VALUES(?, ?, ?)", [order_id, total_amount, cart_id])
//   return try JSON(node: result)
// }

drop.run()

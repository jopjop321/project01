class Product {
   int id;
   String code;
   int costPrice;
   String name;
   int price;
   int amount;
   String image;
  // final int sell;
  int quantity;

  Product({
    required this.quantity,
    required this.id,
    required this.name,
    required this.price,
    required this.code,
    required this.costPrice,
    required this.amount,
    required this.image
    // required this.sell,
  });
}

class SellProduct {
   int idproduct;
   int amount;
   int price_cost;
   int price;


  SellProduct({
    required this.idproduct,
    required this.amount,
    required this.price_cost,
    required this.price,
    // required this.sell,
  });

  Map<String, dynamic> toJson() {
    return {
      'idproduct': idproduct,
      'amount': amount,
      'cost_price': price_cost,
      'price': price,
    };
  }
}
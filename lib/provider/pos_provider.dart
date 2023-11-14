import 'package:flutter/foundation.dart';
import 'package:jstock/model/total.dart';
import 'package:jstock/constants/imports.dart';

class PosProvider with ChangeNotifier {
  List<Product> _products = [];
  //  List<Product> _productsindex = [];
  bool check(Product data) {
    for (var _product in _products) {
      if (_product.id == data.id) {
        return false;
      }
    }
    return true;
  }

  void setData(Product data) {
    // data.quantity = 0;
    _products.add(data);
  }

  void SetData2(int index, int selected) {
    _products[index].quantity = selected;
  }

  List<Product> getalldata() {
    return _products;
  }

  void Setamount(){
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].quantity > 0){
        _products[i].amount - _products[i].quantity;
        _products[i].quantity = 0;
      }
    }
  }

  Product getData(int index) {
    return _products[index];
  }

  void resetQuantity() {
    for (int i = 0; i < _products.length; i++) {
      _products[i].quantity = 0;
    }
  }

  void decrease(int index) {
    if (_products[index].quantity > 0) {
      _products[index].quantity--;
    }
    else{
      _products[index].quantity = 0;
    }
  }

  void increase(int index) {
    if (_products[index].quantity < _products[index].amount) {
      _products[index].quantity++;
    }
    else {
      _products[index].quantity = _products[index].amount;
    }
  }

  SellProduct? getsell(int index) {
    SellProduct? _data;
    if (_products[index].quantity > 0) {
      _data = SellProduct(
          idproduct: _products[index].id,
          amount: _products[index].quantity,
          price: _products[index].price,
          price_cost: _products[index].costPrice);
    } else {
      _data = SellProduct(
          idproduct: 0,
          amount: 0,
          price: _products[index].price,
          price_cost: _products[index].costPrice);
    }
    return _data;
  }

  List<SellProduct>? getsellall() {
    List<SellProduct>? _selllist;
    for (var _product in _products) {
      if (_product.quantity > 0) {
        _selllist!.add(SellProduct(
            idproduct: _product.id,
            amount: _product.quantity,
            price: _product.price,
            price_cost: _product.costPrice));
      }
    }
    for (var _sell in _selllist!) {
      print(_sell.idproduct);
    }
    return _selllist;
  }
}

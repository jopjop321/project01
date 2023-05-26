import 'package:flutter/foundation.dart';
import 'package:jstock/model/total.dart';

class TotlaProvider with ChangeNotifier {

  Total total = Total(monthlyIncome: 100,totalIncome: 199,totalprofit: 90,totalSelling: 11);

  Total getTotal(){
    return total;
  }

  void addTotal(Total state){
    total = state;
  }

  void addmonthlyIncome(double state){
    total.monthlyIncome = state;
  }

  void addtotalIncome(double state){
    total.totalIncome = state;
  }

  void addtotalprofit(double state){
    total.totalprofit = state;
  }
  void addtotalSelling(int state){
    total.totalSelling = state;
  }
}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';
import 'package:jstock/widgets/dialogs/viewProduct.dart';
import 'package:jstock/utils/parser.dart';
import 'package:jstock/constants/imports.dart';

class CardContainerPos extends StatefulWidget {
  final Map<String, dynamic> data;
  final Product data3;
  final int index;
  const CardContainerPos({required this.data , required this.index,required this.data3});

  @override
  State<CardContainerPos> createState() => _CardContainerPosState();
}

class _CardContainerPosState extends State<CardContainerPos> {
  @override
  TextEditingController _stockController = TextEditingController();
  int _currentStock = 0;
  int _addcurrentStock = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stockController.text = widget.data3.quantity.toString();
      _currentStock = widget.data["amount"];
      
    });
  }

  Widget build(BuildContext context) {
    final pos = Provider.of<PosProvider>(context, listen: false);
    

    void _decreaseStock() {
      FocusScope.of(context).unfocus();
      if (_addcurrentStock > 0 ) {
        _addcurrentStock--;
        // pos.SetData2(widget.index, _addcurrentStock);
        _stockController.text = _addcurrentStock.toString();
      }
      pos.decrease(widget.index);
    }

    void _increaseStock() {
      FocusScope.of(context).unfocus();
      // print(_addcurrentStock);
      if (_addcurrentStock < widget.data["amount"]) {
        _addcurrentStock++;
        // pos.SetData2(widget.index, _addcurrentStock);
      _stockController.text = _addcurrentStock.toString();
      }
      pos.increase(widget.index);
      // print(pos.getData(widget.index).quantity);
    }

    return InkWell(
      // onTap: () {
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return ViewProductDialog(
      //         data: data,
      //       );
      //     },
      //   );
      // },
      child: Container(
        height: 230,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colorconstants.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, // สีของเงา
              offset: Offset(2, 2), // ตำแหน่งเงา (x, y)
              blurRadius: 5, // รัศมีของเงา
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: 110, // กำหนดความกว้างของ Container
                height: 110, // กำหนดความสูงของ Container
                child: widget.data["image"] != null
                    ? Image.network(
                        widget.data["image"], // ตำแหน่งไฟล์รูปภาพ
                        fit: BoxFit
                            .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
                      )
                    : Image.asset(
                        'assets/images/logoblue.png', // ตำแหน่งไฟล์รูปภาพ
                        fit: BoxFit
                            .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.data["name"],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.blacktext37465A,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // const Icon(
                  //   Icons.edit,
                  //   color: Colorconstants.blacktext37465A,
                  // ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colorconstants.green009F3A,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Row(
                    children: [
                      const Text(
                        "cardcontainerd.remaining",
                        style: TextStyle(
                          color: Colorconstants.white,
                          fontSize: 10,
                        ),
                      ).tr(),
                      const Spacer(),
                      Text(
                        "${widget.data["amount"]}",
                        style: const TextStyle(
                          color: Colorconstants.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 5),
              // Row(
              //   children: [
              //     const Text("cardcontainerd.price").tr(),
              //     const Spacer(),
              //     Text("${widget.data['price'] ?? 0}฿")
              //   ],
              // ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      // width: 80,
                      height: 35,
                      // padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _decreaseStock,
                            child: const Icon(
                              Icons.remove_circle_outline,
                              // size: 20,
                              color: Colors.grey,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: '',
                              ),
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              controller: _stockController,
                              onChanged: (String value) {
                                _addcurrentStock = Parser.toInt(value);
                                if (_addcurrentStock > widget.data["amount"]) {
                                  _addcurrentStock = widget.data["amount"];
                                  _stockController.text =
                                      _addcurrentStock.toString();
                                    pos.SetData2(widget.index, _addcurrentStock);
                                  // print(_addcurrentStock);
                                }else{
                                  // print(_addcurrentStock);
                                  pos.SetData2(widget.index, _addcurrentStock);
                                }
                              },
                            ),
                          ),

                          // const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _increaseStock,
                            child: const Icon(
                              Icons.add_circle_outline,
                              // size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

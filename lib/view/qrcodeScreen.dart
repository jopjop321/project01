// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRScanner extends StatefulWidget {
//   @override
//   _QRScannerState createState() => _QRScannerState();
// }

// class _QRScannerState extends State<QRScanner> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   late QRViewController controller;
//   late bool scanEnabled;

//   @override
//   void initState() {
//     super.initState();
//     scanEnabled = true;
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   void onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       if (scanEnabled) {
//         setState(() {
//           scanEnabled = false;
//           // ทำอะไรกับข้อมูลที่สแกนได้ตรงนี้
//           print(scanData.code);
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Scanner'),
//       ),
//       body: Stack(
//         children: [
//           QRView(
//             key: qrKey,
//             onQRViewCreated: onQRViewCreated,
//           ),
//           Positioned.fill(
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       scanEnabled = true;
//                     });
//                   },
//                   child: Text('Scan Again'),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

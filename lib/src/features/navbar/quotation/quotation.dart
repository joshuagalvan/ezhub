// import 'package:flutter/material.dart';
// import 'package:simone/src/constants/text_strings.dart';
// import 'package:simone/src/features/authentication/screens/signup/signup_screen.dart';

// class Quotation extends StatefulWidget {
//   const Quotation({super.key});

//   @override
//   State<Quotation> createState() => _QuotationState();
// }

// class _QuotationState extends State<Quotation> {
//   bool? isChecked = false;
//   String dropdownValue = "One";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create Quote"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Form(
//                 child: Column(
//               children: [
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     const Text(branch),
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       items: const [
//                         DropdownMenuItem<String>(
//                             value: "One", child: Text("One")),
//                         DropdownMenuItem<String>(
//                             value: "Two", child: Text("Two")),
//                         DropdownMenuItem<String>(
//                             value: "Three", child: Text("Three")),
//                       ],
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 )),
//                 const SizedBox(height: 10.0),
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     const Text(typeofCover),
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       items: const [
//                         DropdownMenuItem<String>(
//                             value: "One", child: Text("One")),
//                         DropdownMenuItem<String>(
//                             value: "Two", child: Text("Two")),
//                         DropdownMenuItem<String>(
//                             value: "Three", child: Text("Three")),
//                       ],
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 )),
//                 const SizedBox(height: 10.0),
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     const Text(year),
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       items: const [
//                         DropdownMenuItem<String>(
//                             value: "One", child: Text("One")),
//                         DropdownMenuItem<String>(
//                             value: "Two", child: Text("Two")),
//                         DropdownMenuItem<String>(
//                             value: "Three", child: Text("Three")),
//                       ],
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 )),
//                 const SizedBox(height: 10.0),
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     const Text(carCompany),
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       items: const [
//                         DropdownMenuItem<String>(
//                             value: "One", child: Text("One")),
//                         DropdownMenuItem<String>(
//                             value: "Two", child: Text("Two")),
//                         DropdownMenuItem<String>(
//                             value: "Three", child: Text("Three")),
//                       ],
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 )),
//                 const SizedBox(height: 10.0),
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     const Text(carMake),
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       items: const [
//                         DropdownMenuItem<String>(
//                             value: "One", child: Text("One")),
//                         DropdownMenuItem<String>(
//                             value: "Two", child: Text("Two")),
//                         DropdownMenuItem<String>(
//                             value: "Three", child: Text("Three")),
//                       ],
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 )),
//                 const SizedBox(height: 10.0),
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     const Text(carType),
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       items: const [
//                         DropdownMenuItem<String>(
//                             value: "One", child: Text("One")),
//                         DropdownMenuItem<String>(
//                             value: "Two", child: Text("Two")),
//                         DropdownMenuItem<String>(
//                             value: "Three", child: Text("Three")),
//                       ],
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 )),
//                 const SizedBox(height: 10.0),
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     const Text(variant),
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       items: const [
//                         DropdownMenuItem<String>(
//                             value: "One", child: Text("One")),
//                         DropdownMenuItem<String>(
//                             value: "Two", child: Text("Two")),
//                         DropdownMenuItem<String>(
//                             value: "Three", child: Text("Three")),
//                       ],
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 )),
//                 const SizedBox(height: 10.0),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       prefixIcon: Icon(Icons.person_outline_outlined),
//                       labelText: (fairMarket),
//                       hintText: (fairMarket),
//                       border: OutlineInputBorder()),
//                 ),
//                 const SizedBox(height: 10.0),
//                 CheckboxListTile(
//                     title: Text(addVolun),
//                     value: isChecked,
//                     activeColor: Colors.orangeAccent,
//                     onChanged: (bool? newBool) {
//                       setState(() {
//                         isChecked = newBool;
//                       });
//                     }),
//                 const SizedBox(height: 10.0),
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     const Text(deduc),
//                     DropdownButton<String>(
//                       value: dropdownValue,
//                       items: const [
//                         DropdownMenuItem<String>(
//                             value: "One", child: Text("One")),
//                         DropdownMenuItem<String>(
//                             value: "Two", child: Text("Two")),
//                         DropdownMenuItem<String>(
//                             value: "Three", child: Text("Three")),
//                       ],
//                       icon: const Icon(Icons.arrow_drop_down),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           dropdownValue = newValue!;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 10.0),
//                   ],
//                 )),
//               ],
//             )),
//             const Column(
//               children: [
//                 Text(totalPremium),
//                 Text("₱0.0"),
//                 SizedBox(height: 10.0),
//                 Text(premBreak),
//                 Row(
//                   children: [Text(basicPrem), Text("₱0.00")],
//                 ),
//                 Row(
//                   children: [Text(docStamps), Text("₱0.00")],
//                 ),
//                 Row(
//                   children: [Text(vat), Text("₱0.00")],
//                 ),
//                 Row(
//                   children: [Text(localTax), Text("₱0.00")],
//                 ),
//                 Text(benefits),
//                 Row(
//                   children: [Text(ownDama), Text("₱0.00")],
//                 ),
//                 Row(
//                   children: [Text(actsofNature), Text("₱0.00")],
//                 ),
//                 Row(
//                   children: [Text(rscc), Text("₱0.00")],
//                 ),
//                 Row(
//                   children: [Text(autoPA), Text("₱0.00")],
//                 ),
//               ],
//             ),
//             TextButton(onPressed: () {}, child: const Text(save)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextButton(onPressed: () {}, child: Text(emailQuote)),
//                 TextButton(onPressed: () {}, child: Text(issuePolicy)),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// // For Issue Policy
//     // return Scaffold(
//     //   body: Center(
//     //     child: Container(
//     //       height: 408.0,
//     //       child: AlertDialog(
//     //         title: Text("Policy Vehicle Validation"),
//     //         content: Column(children: [
//     //           TextFormField(
//     //             decoration: const InputDecoration(
//     //                 prefixIcon: Icon(Icons.person_outline_outlined),
//     //                 labelText: (plateNo),
//     //                 hintText: (plateNo),
//     //                 border: OutlineInputBorder()),
//     //           ),
//     //           TextFormField(
//     //             decoration: const InputDecoration(
//     //                 prefixIcon: Icon(Icons.person_outline_outlined),
//     //                 labelText: (engineNo),
//     //                 hintText: (engineNo),
//     //                 border: OutlineInputBorder()),
//     //           ),
//     //           TextFormField(
//     //             decoration: const InputDecoration(
//     //                 prefixIcon: Icon(Icons.person_outline_outlined),
//     //                 labelText: (chasisNo),
//     //                 hintText: (chasisNo),
//     //                 border: OutlineInputBorder()),
//     //           ),
//     //         ]),
//     //         actions: [
//     //           TextButton(onPressed: () {}, child: const Text("Verify"))
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // );
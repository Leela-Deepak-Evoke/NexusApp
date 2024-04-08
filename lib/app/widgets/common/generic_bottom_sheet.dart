import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenericBottomSheet extends StatefulWidget {
  final Widget content;
  final String title;
  int? index;
  final Function(int?)? onCategoriesSelected;

  GenericBottomSheet(
      {super.key,
      required this.content,
      required this.title,
      this.index,
      this.onCategoriesSelected});

  @override
  _GenericBottomSheetState createState() => _GenericBottomSheetState();
}

class _GenericBottomSheetState extends State<GenericBottomSheet> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    // checkListItems.addAll(widget.categories ?? []);
    selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          const Divider(), // Optional divider
          Expanded(
          child: widget.content, // Wrap ListView with Expanded
        ),
          // SizedBox(
          //   height: 24,
          // ),
          btnPost(),
          // const SizedBox(height: 34.0), // Content of the bottom sheet
        ],
      ),
    );
  }

  Widget btnPost() {
    return SizedBox(
      height: 48,
      width: 358,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: const Color(0xffF2722B),
          side: const BorderSide(width: 1, color: Color(0xffF2722B)),
        ),
        // <-- OutlinedButton
        onPressed: () {
          if (selectedIndex == null) {
            showMessage('please select category');
          } else {
            Navigator.of(context).pop();
            widget.onCategoriesSelected!(selectedIndex);
          }
        },
        child: Text('Select',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.normal,
            )),
      ),
    );
  }

  //VALIDATION MESSAGE
  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}





/////
///import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class GlobalBottomSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView(
//         children: <Widget>[
//           ListTile(
//             title: Text('Item 1'),
//             onTap: () {
//               // Handle item 1 click
//             },
//           ),
//           ListTile(
//             title: Text('Item 2'),
//             onTap: () {
//               // Handle item 2 click
//             },
//           ),
//           // Add more list items as needed
//         ],
//       ),
//     );
//   }
// }




// class GenericBottomSheet extends StatefulWidget {

// // final Widget content;
//   final String sheetTitle;
//     final Function(int?)? onCategoriesSelected;
//    const GenericBottomSheet({super.key, required this.sheetTitle, this.onCategoriesSelected});

//   @override
//     State<GenericBottomSheet> createState() => _GenericBottomSheetState();

// }

// class _GenericBottomSheetState extends State<GenericBottomSheet> {
//     int? selectedIndex;

//   final List<String> checkListItems = [
//     'Java Practice',
//     'Microsoft Practice',
//     'CSC Practice',
//     'Pega Practice',
//     'Personal Assistant',
//     'UI Practice',
//     'Flutter Practice',
//     'iOS Practice',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // checkListItems.addAll(widget.categories ?? []);
//     // selectedIndex = widget.index;
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//            const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             "Bottom sheet",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18.0,
//             ),
//           ),
//         ),
//         const Divider(),
//          Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
//         child: categoryListView(),
//       ),

//       // Optional divider
//         // widget.content, // Content of the bottom sheet
//       ],
//     );
//   }

//   // LIST VIEW
// Widget categoryListView() {
//   return ListView(
//     children: [
//       Column(
//         children: List.generate(
//           checkListItems.length,
//           // categories.length,
//           (index) => CheckboxListTile(
//             controlAffinity: ListTileControlAffinity.trailing,
//             contentPadding: EdgeInsets.zero,
//             dense: true,
//             title: Text(
//               checkListItems[index],
//               // categories[index].name ?? "",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontFamily: GoogleFonts.roboto().fontFamily,
//                 fontWeight: FontWeight.normal,
//                 fontSize: 14,
//               ),
//             ),
//             value: selectedIndex == index ? true : false,
//             onChanged: (value) {
//               setState(() {
//                 selectedIndex = index;
//               });
//             },
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 24,
//       ),

//       //POST BUTTON
//       btnPost(),
//       const SizedBox(height: 34.0),
//     ],
//   );
// }

// }

// class GlobalBottomSheet extends StatelessWidget {
//   final Function(int?)? onCategoriesSelected;
//   int? selectedIndex;
//   final String title;
//   final List<String> checkListItems = [
//     'Java Practice',
//     'Microsoft Practice',
//     'CSC Practice',
//     'Pega Practice',
//     'Personal Assistant',
//     'UI Practice',
//     'Flutter Practice',
//     'iOS Practice',
//   ];
//   GlobalBottomSheet({required this.title, this.onCategoriesSelected});

//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//      backgroundColor: Colors.white,
//     appBar: AppBar(
//         shadowColor: Color(0xffEAEAEA),
//         elevation: 2,
//         backgroundColor: Colors.white,
//         toolbarHeight: 65,
//         centerTitle: false,
//         titleSpacing: 0.0,
//         title: Text(title,
//             style: TextStyle(
//               color: Color(0xff292929),
//               fontSize: 16.0,
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               fontWeight: FontWeight.w600,
//               //height: 24,
//             )),
//         actions: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Image.asset(
//                   'assets/images/close.png',
//                   width: 24,
//                   height: 24,
//                 ),
//               )),
//         ],
//       ),
//    body: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
//       child: Container(
//         child: ListView(
//           children: <Widget>[
//             Column(
//               children: List.generate(
//                 checkListItems.length,
//                 (index) => CheckboxListTile(
//                   controlAffinity: ListTileControlAffinity.trailing,
//                   contentPadding: EdgeInsets.zero,
//                   dense: true,
//                   title: Text(
//                     checkListItems[index],
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontFamily: GoogleFonts.roboto().fontFamily,
//                       fontWeight: FontWeight.normal,
//                       fontSize: 14,
//                     ),
//                   ),
//                   value: selectedIndex == index ? true : false,
//                   onChanged: (value) {
//                     // setState(() {
//                     //   selectedIndex = index;
//                     // });

//                     if (onCategoriesSelected != null) {
//                       // selectedIndex = index;
//                       onCategoriesSelected!(
//                           1); // Notify that category 1 is selected
//                     }
//                     // Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 24,
//             ),
//             //POST BUTTON
//             btnPost(context),
//             const SizedBox(height: 34.0),
//             // Add more list items as needed
//           ],
//         ),
//       ),
//     )
//   );

//   }

//   //POST BUTTON
//   Widget btnPost(BuildContext context) {
//     return Container(
//       height: 48,
//       width: 358,
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//           backgroundColor: Color(0xffF2722B),
//           side: BorderSide(width: 1, color: Color(0xffF2722B)),
//         ),
//         // <-- OutlinedButton
//         onPressed: () {
//           if (selectedIndex == null) {
//             showMessage('please select category', context);
//           } else {
//             Navigator.of(context).pop();
//             onCategoriesSelected!(selectedIndex);
//           }
//         },
//         child: Text('Select',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16.0,
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               fontWeight: FontWeight.normal,
//             )),
//       ),
//     );
//   }

//   //VALIDATION MESSAGE
//   void showMessage(String text, BuildContext context) {
//     var alert = AlertDialog(content: Text(text), actions: <Widget>[
//       TextButton(
//           child: const Text('OK'),
//           onPressed: () {
//             Navigator.pop(context);
//           })
//     ]);
//     showDialog(context: context, builder: (BuildContext context) => alert);
//   }
// }

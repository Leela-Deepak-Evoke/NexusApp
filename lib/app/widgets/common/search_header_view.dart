import 'package:flutter/material.dart';

class SearchHeaderView extends StatelessWidget {
  final Function() onIconClicked;

  const SearchHeaderView({super.key, required this.onIconClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onIconClicked,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color.fromRGBO(255, 255, 255, 0.2),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onIconClicked, // You can have a separate function for filter if needed
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color.fromRGBO(255, 255, 255, 0.2),
              ),
              child: const Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// class SearchHeaderView extends StatefulWidget {
//   final String name;
//   final TextEditingController searchController;
//   final Size size;
//   Function() onSearchClicked;

//    SearchHeaderView({
//     super.key,
//     required this.name,
//     required this.searchController,
//     required this.size,
//     required this.onSearchClicked,
//   });

//   @override
//   State<SearchHeaderView> createState() => _SearchHeaderViewState();
// }

// class _SearchHeaderViewState extends State<SearchHeaderView> {
//   @override
//   Widget build(BuildContext context) {
    

//     return 
//      Padding(
//       padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
//       child: 
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SearchBarSmall(
//               searchController: widget.searchController,
//               text: widget.name,
//               width: widget.size.width - 90,
//               onPostSucess: widget.onSearchClicked),
//           const Spacer(),
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5.0),
//               color: const Color.fromRGBO(255, 255, 255, 0.2),
//             ),
//             child: IconButton(
//               icon: Image.asset(
//                 'assets/images/verticalLines.png',
//                 width: 44,
//                 height: 44,
//               ),
//               onPressed: () {
//                // openBottomSheetForCategories();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
// //     Container(
// //           height: 70,
// //           color: const Color(ColorConstants.topbarbg),
// //           child:      Padding(
// //       padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
// //       child: 
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //             SearchBarSmall(
// //               searchController: widget.searchController,
// //               text: "Q&A",
// //               width: widget.size.width - 80,
// //               onPostSucess:() {
                
// //               },),
// //           const Spacer(),
// //           Container(
// //             width: 44,
// //             height: 44,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(5.0),
// //               color: const Color.fromRGBO(255, 255, 255, 0.2),
// //             ),
// //             child: IconButton(
// //               icon: Image.asset(
// //                 'assets/images/verticalLines.png',
// //                 width: 44,
// //                 height: 44,
// //               ),
// //               onPressed: () {
               
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     ),

// //  );
// }


//   void onSearchClicked() 
//   {
//   }
// }

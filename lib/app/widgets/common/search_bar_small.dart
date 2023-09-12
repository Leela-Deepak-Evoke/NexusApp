import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/drop_down_menu.dart';

// import 'package:flutter_layout_grid/flutter_layout_grid.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:social_network/app/screens/feeds/feeds_screen.dart';
// import 'package:social_network/app/screens/forum/forum_screen.dart';
// import 'package:social_network/app/screens/notifications/notifications_screen.dart';
// import 'package:social_network/app/screens/settings/settings_screen.dart';
// import 'package:social_network/app/widgets/layout/app_bottom_navigation_bar.dart';
// import 'package:social_network/app/screens/post_question/post_question_screen.dart';
// import 'package:social_network/app/providers/drop_down_menu.dart';


class SearchBarSmall extends StatefulWidget {

 final TextEditingController searchController;
  final String text;
 final double width;
  final VoidCallback onPostSucess;

  //  SearchBarSmall(this._searchController, this.text,this.width, this.onPostSucess );//add also..example this.abc,this...
   const SearchBarSmall({super.key,  required this.searchController, required this.text, required this.width, required this.onPostSucess});

  @override
    State<SearchBarSmall> createState() => _SearchBarSmallState();

}
class _SearchBarSmallState extends State<SearchBarSmall> {


  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // final TextEditingController _searchController = TextEditingController();

    final Size size = MediaQuery.of(context).size;


    return 
    // Padding(
    //     padding: const EdgeInsets.only(left:5,right:5),
    //     child:Row(
    //       mainAxisAlignment:MainAxisAlignment.spaceBetween,
    // children:[
      Container(
            width:widget.width,
            height:44,
            decoration:   BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: const Color.fromRGBO(255,255,255,0.2),
            ),
            child:
            TextField(
                style: const TextStyle(color:Colors.white),
                controller: widget.searchController,
                textAlign:TextAlign.left,
                cursorColor:Colors.white,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '${AppConstants.search} ${widget.text}',
                  focusedBorder:InputBorder.none,
                  focusColor:Colors.white,
                  hintStyle:const TextStyle(color:Colors.white,fontSize:12),
                  contentPadding:const EdgeInsets.only(bottom:5),
                   suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.white),
                //onPressed: () => widget.searchController.clear(),
                      onPressed: () {
                      widget.searchController.clear();
                      setState(() {
                            widget.onPostSucess();

                      });
                    },
              ),
                  // Add a clear button to the search bar
                  // Add a search icon or button to the search bar
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search,size:18,color:Colors.white),
                    onPressed: () {
                      // Perform the search here
                      setState(() {
                            widget.onPostSucess();

                      });
                    },
                  ),
                ))
                );
    //   const Spacer(),
    //      Container(
    //       width:44,
    //       height:44,
    //       decoration:BoxDecoration(
    //         borderRadius: BorderRadius.circular(5.0),
    //         color: const Color.fromRGBO(255,255,255,0.2),
    //       ),
    //         child:DropDownMenuPage(items:const []),
    //       ),
    // ]
    // )
    // );
  }



}

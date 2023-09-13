import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';


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

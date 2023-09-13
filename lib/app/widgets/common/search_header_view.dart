import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:evoke_nexus_app/app/widgets/common/search_bar_small.dart';
import 'package:flutter/material.dart';

class SearchHeaderView extends StatefulWidget {
  final String name;
  final TextEditingController searchController;
  final Size size;

  const SearchHeaderView({
    super.key,
    required this.name,
    required this.searchController,
    required this.size,

  });

  @override
  State<SearchHeaderView> createState() => _SearchHeaderViewState();
}

class _SearchHeaderViewState extends State<SearchHeaderView> {
  @override
  Widget build(BuildContext context) {
    

    return Container(
          height: 70,
          color: const Color(ColorConstants.topbarbg),
          child:      Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            SearchBarSmall(
              searchController: widget.searchController,
              text: "Q&A",
              width: widget.size.width - 80,
              onPostSucess:() {
                
              },),
          const Spacer(),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: const Color.fromRGBO(255, 255, 255, 0.2),
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/images/verticalLines.png',
                width: 44,
                height: 44,
              ),
              onPressed: () {
               
              },
            ),
          ),
        ],
      ),
    ),

 );
}

}

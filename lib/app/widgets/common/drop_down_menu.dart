import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:evoke_nexus_app/app/utils/constants.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:social_network/app/utils/constants.dart';
// import 'package:social_network/app/services/StringConstants.dart';

class DropDownMenuPage extends StatefulWidget {
  // const DropDownMenuPage({Key? key}) : super(key: key);
  final List<String> items;

  const DropDownMenuPage({super.key, required this.items});

  @override
  State<DropDownMenuPage> createState() => _DropDownMenuPageState();
}



class _DropDownMenuPageState extends State<DropDownMenuPage> {
  final List<String> items = [
    'Java Practice',
    'Microsoft Practice',
    'CSC Practice',
    'Pega Practice',
    'Personal Assistant',
    'UI Practice',
    'Flutter Practice',
    'iOS Practice',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return  DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blueTextColour, //Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value as String;
              });
            },
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.filter,
                ),
                iconSize: 10,
                iconEnabledColor: Colors.yellow,
                iconDisabledColor: Colors.grey,
              ),
              buttonStyleData: const ButtonStyleData(
                height: 50,
                width: 50,
                padding: EdgeInsets.only(left: 14, right: 14),
                elevation: 2,
              ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: MediaQuery.of(context).size.width - 100,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade100,
              ),
              elevation: 2,
              offset: const Offset(-20, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),
        )
    );
  }
}
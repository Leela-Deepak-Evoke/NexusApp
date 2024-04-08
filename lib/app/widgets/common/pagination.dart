import 'package:flutter/material.dart';

class Pagination<T> extends StatefulWidget {
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;
  final Future<List<T>> Function(int page) fetchData;
  final Widget Function(List<T>) itemBuilder;

  const Pagination({super.key, 
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
    required this.fetchData,
    required this.itemBuilder,
  });

  @override
  _PaginationState<T> createState() => _PaginationState<T>();
}

class _PaginationState<T> extends State<Pagination<T>> {
  late int _currentPage;
  late bool _isLoading;
  final List<T> _items = [];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
    _isLoading = false;
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_currentPage * widget.itemsPerPage > _items.length && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      final newItems = await widget.fetchData(_currentPage);
      setState(() {
        _isLoading = false;
        _items.addAll(newItems);
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            if (index == _items.length - 1) {
              _fetchData();
            }
            return widget.itemBuilder(_items);
          },
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}




// Pagination is a generic stateful widget that takes in various parameters like the current page, items per page, total items, a data fetching function (fetchData), and an item builder function (itemBuilder) to render the fetched data.

// Inside _PaginationState, the initState method is used to initialize the widget, including setting the initial _currentPage and _isLoading state.

// The _fetchData method is called to fetch data when the user scrolls to the end of the list. It checks if more data needs to be fetched based on the current page and total items. If so, it triggers a fetch and updates the state.

// In the build method, a ListView.builder is used to render the paginated data. When the last item in the list is reached, it triggers a data fetch.

// You can use this Pagination widget in your application like this:
//Usage
// Pagination<MyData>(
//   currentPage: 1,
//   itemsPerPage: 10,
//   totalItems: 100,
//   fetchData: (page) async {
//     // Fetch data from your API or data source
//     // Example: return await fetchDataFromApi(page);
//     return List.generate(10, (index) => MyData(id: index, name: 'Item $index'));
//   },
//   itemBuilder: (dataList) {
//     // Build your item widgets here
//     return ListTile(
//       title: Text(dataList.name),
//     );
//   },
// )

import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class CustomTable<T> extends StatefulWidget {
  final List<DataColumn> columns;
  final List<T> rows;
  final bool hasSearch;
  final List<CustomAction<T>>? actions;
  final bool Function(T, String)? filterFunction;
  final List<DataCell> Function(T) dataCellBuilder;
  final bool
      searchOnRight; // Add this parameter to choose search field position
  final bool showAddButton; // Add this parameter to control button visibility
  final void Function()? onAddButtonPressed; // Add callback for button tap

  const CustomTable({
    Key? key,
    required this.columns,
    required this.rows,
    required this.dataCellBuilder,
    this.filterFunction,
    this.hasSearch = false,
    this.actions,
    this.searchOnRight = false,
    this.showAddButton = true, // Default to showing the button
    this.onAddButtonPressed, // Callback for button tap// Default to left side
  }) : super(key: key);

  @override
  _CustomTableState<T> createState() => _CustomTableState<T>();
}

class _CustomTableState<T> extends State<CustomTable<T>> {
  List<T> displayedRows = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedRows = widget.rows;
    // searchController.addListener(_filterRows);
  }

  void _filterRows(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedRows = widget.rows;
      });
    } else {
      setState(() {
        displayedRows = widget.rows.where((row) {
          return widget.filterFunction != null
              ? widget.filterFunction!(row, query)
              : true;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = [
      ...widget.columns.map((column) => DataColumn(
            label: Text(
              (column.label as Text).data ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12, // Adjust font size as needed
              ),
            ),
          )),
      if (widget.actions != null)
        const DataColumn(
          label: Text(
            'Actions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.hasSearch)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width:
                    widget.searchOnRight ? null : 300, // Adjust width as needed
                child: CustomTextField(
                  label: 'Search',
                  controller: searchController,
                  icon: Icons.search,
                  isRequired: false,
                  onChanged: (query) {
                    _filterRows(query);
                  },
                ),
              ),
              widget.showAddButton
                  ? ElevatedButton(
                      onPressed: widget.onAddButtonPressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Square shape
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0), // Equal padding for square look
                        minimumSize: const Size(
                            50, 50), // Set minimum size to ensure it's square
                        elevation:
                            5, // Optional: Add elevation for shadow effect
                        backgroundColor: Colors.blueAccent, // Background color
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 16, // Adjust font size as needed
                          color: Colors.white, // Text color
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        Flexible(
          flex: 4,
          // Use Flexible instead of Expanded
          fit: FlexFit.loose, // Allow the child to be flexible with loose fit
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(
                  color: Colors.grey,
                  width: 1,
                  borderRadius: BorderRadius.zero, // No rounded corners
                ),
                columnWidths: {
                  for (var i = 0; i < columns.length; i++)
                    i: FixedColumnWidth(MediaQuery.of(context).size.width /
                        10), // Adjust width as needed
                },
                children: [
                  TableRow(
                    children: columns.map((column) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Colors.grey,
                                width: 1), // Vertical border
                          ),
                        ),
                        child: column.label,
                      );
                    }).toList(),
                  ),
                  ...displayedRows.map((row) {
                    final dataCells = widget.dataCellBuilder(row);
                    return TableRow(
                      children: [
                        ...dataCells.map((cell) => Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        100), // Adjust max width as needed
                                child: Text(
                                  (cell.child as Text).data ?? '',
                                  softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize:
                                          12), // Adjust font size as needed
                                ),
                              ),
                            )),
                        if (widget.actions != null)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: widget.actions!.map((action) {
                                return Flexible(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(action.icon,
                                        size: 12), // Adjust icon size as needed
                                    onPressed: () =>
                                        action.onPressed(context, row),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomAction<T> {
  final IconData icon;
  final void Function(BuildContext context, T row) onPressed;

  CustomAction({
    required this.icon,
    required this.onPressed,
  });
}

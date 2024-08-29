import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_table.dart';
import '../widgets/key_value_row_aligment.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String? selectedButton;
  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Scaffold(
        drawer: kIsWeb ? const CustomDrawer() : null,
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          // automaticallyImplyLeading: kIsWeb ? false : true,
          title: const Text(
            'Orders',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        body: ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, _buildContent()),
          maxWidth: MediaQuery.of(context).size.width,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ResponsiveRowColumn(
        rowMainAxisAlignment: MainAxisAlignment.center,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        columnMainAxisAlignment: MainAxisAlignment.start,
        columnCrossAxisAlignment: CrossAxisAlignment.center,
        layout: ResponsiveRowColumnType.COLUMN,
        children: [
          ResponsiveRowColumnItem(
            columnFlex: 1,
            rowColumn: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = 'Inward';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    backgroundColor: selectedButton == 'Inward'
                        ? Colors.blueAccent
                        : Colors.grey,
                  ),
                  child: const Text(
                    'Inward',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = 'New Orders';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    backgroundColor: selectedButton == 'New Orders'
                        ? Colors.blueAccent
                        : Colors.grey,
                  ),
                  child: const Text('New Orders',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          if (selectedButton != null)
            ResponsiveRowColumnItem(
              columnFlex: 12,
              child: selectedButton == 'Inward'
                  ? const InwardPage()
                  : const NewOrdersPage(),
            ),
        ],
      ),
    );
  }
}

class InwardPage extends StatefulWidget {
  const InwardPage({super.key});

  @override
  State<InwardPage> createState() => _InwardPageState();
}

class _InwardPageState extends State<InwardPage> {
  String? selectedProduct;
  String? selectedBrand;
  TextEditingController productController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  final List<String> products = ['Steel', 'Cement'];
  final Map<String, List<String>> brands = {
    'Steel': ['Amba Shakti', 'Megha'],
    'Cement': ['Birla', 'Dalmia']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(),
            const Text('Inward',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropdown(
                        label: "Select Product",
                        controller: productController,
                        options: products,
                        onChange: (val) {
                          setState(() {
                            selectedProduct = val ?? "";
                            productController.text = val ?? "";
                          });
                        }),
                  ),
                ),
                Visibility(
                    visible: productController.text.isNotEmpty,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomDropdown(
                            label: "Select Brand",
                            controller: brandController,
                            options: brands[productController.text] ?? [],
                            onChange: (val) {
                              setState(() {
                                selectedBrand = val ?? "";
                                brandController.text = val ?? "";
                              });
                            }),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 16),
            KeyValueRow(keyText: 'Product', valueText: productController.text),
            const SizedBox(height: 16),
            KeyValueRow(keyText: 'Brand', valueText: brandController.text),

            /*_isLoading
                      ? const LoaderIndicatorWidget(
                    message: 'Fetching Users please wait...',
                  )
                      :*/
            Expanded(
              child: CustomTable<String>(
                columns: const [
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Invoice No')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Inward Date')),
                ],
                rows: [],
                hasSearch: true,
                dataCellBuilder: (user) => [
                  DataCell(Text('100')),
                  DataCell(Text('INV001')),
                  DataCell(Text('\$1000')),
                  DataCell(Text('01-01-2024')),
                ],
                // filterFunction: [],
              ),
            ),
            SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  _showAddInwardDialog();
                },
                child: const Text('ADD'),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _showAddInwardDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Inward Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Invoice No'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Inward Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle save operation
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class NewOrdersPage extends StatefulWidget {
  const NewOrdersPage({super.key});

  @override
  State<NewOrdersPage> createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends State<NewOrdersPage> {
  final List<Map<String, String>> pendingOrders = [
    {
      'name': 'Customer 1',
      'site': 'Site 1',
      'product': 'Steel',
      'brand': 'Amba Shakti',
      'quantity': '100'
    },
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(),
            const Text('New Order',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: pendingOrders.length,
                itemBuilder: (context, index) {
                  final order = pendingOrders[index];
                  return ListTile(
                    title: Text(order['name']!),
                    subtitle: Text(
                        'Site: ${order['site']}, Product: ${order['product']}, Brand: ${order['brand']}, Quantity: ${order['quantity']}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showAddOrderDialog();
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOrderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Customer Name'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Site'),
              ),
              DropdownButton<String>(
                hint: const Text('Select Product'),
                items: ['Steel', 'Cement'].map((product) {
                  return DropdownMenuItem<String>(
                    value: product,
                    child: Text(product),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              DropdownButton<String>(
                hint: const Text('Select Brand'),
                items: ['Amba Shakti', 'Megha', 'Birla', 'Dalmia'].map((brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle save operation
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

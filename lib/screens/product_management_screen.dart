import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/custom_drawer.dart';

class Brand {
  final int id;
  final String name;
  final double price;

  Brand({required this.id, required this.name, required this.price});
}

class Product {
  final int id;
  final String name;
  final List<Brand> brands;

  Product({required this.id, required this.name, required this.brands});
}

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // Initialize with some sample data
    products = [
      Product(
        id: 1,
        name: 'Steel',
        brands: [
          Brand(id: 1, name: 'Amba Shakti', price: 5000),
          Brand(id: 2, name: 'Meghna', price: 5200),
        ],
      ),
      Product(
        id: 2,
        name: 'Cement',
        brands: [
          Brand(id: 3, name: 'Birla', price: 300),
          Brand(id: 4, name: 'Dalmia', price: 320),
        ],
      ),
    ];
  }

  void _addOrUpdateProduct(Product? product) async {
    final result = await showDialog<Product>(
      context: context,
      builder: (context) => ProductFormDialog(
        product: product,
      ),
    );

    if (result != null) {
      setState(() {
        if (product != null) {
          // Update existing product
          final index = products.indexOf(product);
          products[index] = result;
        } else {
          // Add new product
          products.add(result);
        }
      });
    }
  }

  void _addOrUpdateBrand(Product product, Brand? brand) async {
    final result = await showDialog<Brand>(
      context: context,
      builder: (context) => BrandFormDialog(brand: brand),
    );

    if (result != null) {
      setState(() {
        if (brand != null) {
          // Update existing brand
          final index = product.brands.indexOf(brand);
          product.brands[index] = result;
        } else {
          // Add new brand
          product.brands.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Scaffold(
        appBar: AppBar(
          title: const Text('Product Management'),
        ),
        drawer:kIsWeb? CustomDrawer():null,
        body: ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, _buildContent()),
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addOrUpdateProduct(null),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildListView();
        } else {
          return _buildGridView();
        }
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ExpandableCard(
          product: product,
          onAddOrUpdateBrand: (product, brand) {
            _addOrUpdateBrand(product, brand);
          },
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true, // Ensures GridView takes only the necessary space
      physics: const ScrollPhysics(), // Prevent GridView from scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.0, // Adjust as needed
        crossAxisSpacing: 4.0, // Spacing between grid items
        mainAxisSpacing: 4.0, // Spacing between grid items
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ExpandableCard(
          product: product,
          onAddOrUpdateBrand: (product, brand) {
            _addOrUpdateBrand(product, brand);
          },
        );
      },
    );
  }
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;

  ProductFormDialog({this.product});

  @override
  _ProductFormDialogState createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newProduct = Product(
                id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch,
                name: _nameController.text,
                brands: widget.product?.brands ?? [],
              );
              Navigator.of(context).pop(newProduct);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class BrandFormDialog extends StatefulWidget {
  final Brand? brand;

  BrandFormDialog({this.brand});

  @override
  _BrandFormDialogState createState() => _BrandFormDialogState();
}

class _BrandFormDialogState extends State<BrandFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.brand?.name ?? '');
    _priceController =
        TextEditingController(text: widget.brand?.price.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.brand == null ? 'Add Brand' : 'Edit Brand'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Name cannot be empty' : null,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? 'Price cannot be empty' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newBrand = Brand(
                id: widget.brand?.id ?? DateTime.now().millisecondsSinceEpoch,
                name: _nameController.text,
                price: double.parse(_priceController.text),
              );
              Navigator.of(context).pop(newBrand);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class ExpandableCard extends StatelessWidget {
  final Product product;
  final Function(Product, Brand?) onAddOrUpdateBrand;

  const ExpandableCard({
    Key? key,
    required this.product,
    required this.onAddOrUpdateBrand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(product.name),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onAddOrUpdateBrand(product, null),
        ),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *
                  0.3, // Adjust height as needed
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: product.brands.isEmpty
                    ? [const ListTile(title: Text('No brands available'))]
                    : product.brands.asMap().entries.map((entry) {
                        final index = entry.key;
                        final brand = entry.value;
                        return ListTile(
                          leading: Text((index + 1)
                              .toString()), // Display index of the brand
                          title: Text(brand.name),
                          subtitle: Text('\$${brand.price}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => onAddOrUpdateBrand(product, brand),
                          ),
                        );
                      }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

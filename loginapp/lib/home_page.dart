import 'package:flutter/material.dart';

class FoodItem {
  String name;
  double price;

  FoodItem({required this.name, required this.price});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FoodItem> foodItems = [
    FoodItem(name: 'Beras', price: 10.0),
    FoodItem(name: 'Gula', price: 5.0),
    FoodItem(name: 'Minyak Goreng', price: 15.0),
    FoodItem(name: 'Telur', price: 2.0),
    FoodItem(name: 'Mie Instan', price: 1.5),
    FoodItem(name: 'Shampo', price: 8.0),
    FoodItem(name: 'Sabun', price: 3.0),
    FoodItem(name: 'Kecap Botol', price: 4.0),
    FoodItem(name: 'Saos Botol', price: 3.5),
    FoodItem(name: 'Sasa Sachet', price: 0.5),
  ];

  List<FoodItem> displayedFoodItems = [];

  @override
  void initState() {
    super.initState();
    // Salin isi foodItems ke displayedFoodItems agar tidak mengubah foodItems saat pencarian
    displayedFoodItems.addAll(foodItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Produk'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: displayedFoodItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                        '${index + 1}. ${displayedFoodItems[index].name}'),
                    subtitle: Text(
                        'Harga: \$${displayedFoodItems[index].price.toString()}'),
                    onTap: () {
                      print('Anda memilih: ${displayedFoodItems[index].name}');
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteItem(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addProduct();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _showSearchDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      displayedFoodItems.removeAt(index);
    });
  }

  void _addProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = '';
        double newPrice = 0.0;

        return AlertDialog(
          title: Text('Tambah Produk Baru'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nama Produk'),
                onChanged: (value) {
                  newName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Harga Produk'),
                onChanged: (value) {
                  newPrice = double.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (newName.isNotEmpty && newPrice > 0) {
                  setState(() {
                    FoodItem newItem = FoodItem(name: newName, price: newPrice);
                    foodItems.add(newItem);
                    displayedFoodItems.add(newItem);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cari Produk'),
          content: TextField(
            onChanged: (value) {
              _performSearch(value);
            },
            decoration: InputDecoration(
              labelText: 'Nama Produk',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _performSearch(String query) {
    List<FoodItem> searchResults = [];

    if (query.isNotEmpty) {
      searchResults = foodItems
          .where((foodItem) =>
              foodItem.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      // Jika kotak pencarian kosong, tampilkan semua item
      searchResults.addAll(foodItems);
    }

    setState(() {
      displayedFoodItems.clear();
      displayedFoodItems.addAll(searchResults);
    });
  }
}

import 'package:flutter/material.dart';

void main() => runApp(EventBookingApp());

class EventBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EventBookingPage(),
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}

class EventBookingPage extends StatefulWidget {
  @override
  _EventBookingPageState createState() => _EventBookingPageState();
}

class _EventBookingPageState extends State<EventBookingPage> {
  final List<Map<String, dynamic>> _bookings = [];
  final _formKey = GlobalKey<FormState>();

  String? _eventType;
  String? _venueSize = 'Small';
  String? _addOn = 'None';
  int? _quantity = 1;
  double _basePrice = 0.0;
  double _sizePrice = 0.0;
  double _addOnPrice = 0.0;
  double _totalPrice = 0.0;

  final Map<String, double> _eventMenu = {
    'Wedding': 1000.0,
    'Conference': 500.0,
    'Birthday': 300.0,
  };

  final Map<String, double> _venueSizes = {
    'Small': 200.0,
    'Medium': 400.0,
    'Large': 600.0,
  };

  final Map<String, double> _addOnPrices = {
    'None': 0.0,
    'Catering': 500.0,
    'Photography': 300.0,
    'Decorations': 200.0,
  };

  void _calculateTotalPrice() {
    setState(() {
      _totalPrice = (_basePrice + _sizePrice + _addOnPrice) * (_quantity ?? 1);
    });
  }

  void _addOrEditBooking({int? index}) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _calculateTotalPrice();
      setState(() {
        final booking = {
          'eventType': _eventType,
          'venueSize': _venueSize,
          'addOn': _addOn,
          'quantity': _quantity,
          'price': _totalPrice,
        };

        if (index == null) {
          _bookings.add(booking);
        } else {
          _bookings[index] = booking;
        }
      });
      Navigator.pop(context);
    }
  }

  void _deleteBooking(int index) {
    setState(() {
      _bookings.removeAt(index);
    });
  }

  void _openForm({int? index}) {
    if (index != null) {
      final booking = _bookings[index];
      _eventType = booking['eventType'];
      _venueSize = booking['venueSize'];
      _addOn = booking['addOn'];
      _quantity = booking['quantity'];
      _basePrice = _eventMenu[_eventType]!;
      _sizePrice = _venueSizes[_venueSize]!;
      _addOnPrice = _addOnPrices[_addOn]!;
    } else {
      _eventType = null;
      _venueSize = 'Small';
      _addOn = 'None';
      _quantity = 1;
      _basePrice = 0.0;
      _sizePrice = 0.0;
      _addOnPrice = 0.0;
    }

    _calculateTotalPrice();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(index == null ? 'Add Event Booking' : 'Edit Event Booking'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _eventType,
                      decoration: InputDecoration(
                        labelText: 'Event Type',
                        border: OutlineInputBorder(),
                      ),
                      items: _eventMenu.keys
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _eventType = value;
                          _basePrice = _eventMenu[value]!;
                          _calculateTotalPrice();
                        });
                      },
                      onSaved: (value) => _eventType = value,
                      validator: (value) =>
                          value == null ? 'Select an event type' : null,
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Venue Size",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ..._venueSizes.keys.map((size) {
                          return RadioListTile<String>(
                            title: Text(size),
                            value: size,
                            groupValue: _venueSize,
                            onChanged: (value) {
                              setState(() {
                                _venueSize = value;
                                _sizePrice = _venueSizes[value]!;
                                _calculateTotalPrice();
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add-On Services",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ..._addOnPrices.keys.map((addOn) {
                          return RadioListTile<String>(
                            title: Text(addOn),
                            value: addOn,
                            groupValue: _addOn,
                            onChanged: (value) {
                              setState(() {
                                _addOn = value;
                                _addOnPrice = _addOnPrices[value]!;
                                _calculateTotalPrice();
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: _quantity?.toString(),
                      decoration: InputDecoration(
                        labelText: 'Number of Bookings',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _quantity = int.tryParse(value) ?? 1;
                          _calculateTotalPrice();
                        });
                      },
                      onSaved: (value) => _quantity = int.tryParse(value!),
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => _addOrEditBooking(index: index),
                child: Text(index == null ? 'Add' : 'Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Booking System'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://tse1.mm.bing.net/th?id=OIP.RGG0cYHTj24hU2aBjxLccgHaEK&pid=Api'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: _bookings.isEmpty
                      ? Center(
                          child: Text(
                            'No Bookings Yet!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                                Colors.grey[300]),
                            dataRowColor:
                                MaterialStateProperty.all(Colors.grey[200]),
                            columns: [
                              DataColumn(label: Text('Event Type')),
                              DataColumn(label: Text('Venue Size')),
                              DataColumn(label: Text('Add-On')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Total Price')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: _bookings.map((booking) {
                              final index = _bookings.indexOf(booking);
                              return DataRow(cells: [
                                DataCell(Text(booking['eventType'])),
                                DataCell(Text(booking['venueSize'])),
                                DataCell(Text(booking['addOn'])),
                                DataCell(Text(booking['quantity'].toString())),
                                DataCell(Text(
                                    '\$${booking['price'].toStringAsFixed(2)}')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            _openForm(index: index),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _deleteBooking(index),
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}

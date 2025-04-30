import 'dart:io';
import 'package:intl/intl.dart';
import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable%20widget/background_screen.dart';
import 'package:expenses_tracker_app/reusable%20widget/crudbar.dart';
import 'package:expenses_tracker_app/services/crud_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditdeleteScreen extends StatefulWidget {
  const EditdeleteScreen({super.key, required this.expenseData});
  final Map<String, dynamic>? expenseData;

  @override
  State<StatefulWidget> createState() => _EditdeleteScreenState();
}

class _EditdeleteScreenState extends State<EditdeleteScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  DateTime? _selectedDate;
  File? _receiptImage;
  String? _uploadedImageUrl;

  final picker = ImagePicker();

  final CrudService crudService = CrudService();
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController dateController;
  late TextEditingController descController;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
      // await _uploadImage(File(pickedFile.path));
    }
  }

  Future<void> _uploadImage(File image) async {
    final downloadUrl = await crudService.uploadImageToFirebase(image);
    if (downloadUrl != null) {
      setState(() {
        _uploadedImageUrl = downloadUrl;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return null;
  }

  String? _selectedCategory;
  final List<String> _categories = [
    'Food',
    'Transport',
    'Rent',
    'Hobby',
    'Health',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.expenseData!['name'] ?? '',
    );
    priceController = TextEditingController(
      text: widget.expenseData!['price'].toString() ?? '',
    );
    quantityController = TextEditingController(
      text: widget.expenseData!['quantity'].toString() ?? '',
    );
    final dateFromFirebase = widget.expenseData?['date'];
    _selectedDate = DateTime.parse(dateFromFirebase);

    final formattedDate =
        "${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}";
    dateController = TextEditingController(text: formattedDate);
    descController = TextEditingController(
      text: widget.expenseData!['desc'] ?? '',
    );
    _selectedDate = DateTime.tryParse(widget.expenseData!['date'].toString());

    _selectedCategory = widget.expenseData!['category'];
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundScreen(
          appBar: Crudbar('Edit and Delete Expenses'),
          backgroundColor: mainBackGround,
          screen: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child:
                        _receiptImage != null
                            ? Image.file(_receiptImage!, height: 200)
                            : (widget.expenseData!['imageUrl'] != null
                                ? Image.network(
                                  widget.expenseData!['imageUrl'],
                                  height: 200,
                                )
                                : Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.camera_alt, size: 50),
                                )),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      children: [
                        // Name
                        TextFormField(
                          controller: nameController,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Please enter a name'
                                      : null,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 0, 0, 0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Category
                        DropdownButtonFormField(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                          items:
                              _categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? "Please select a category"
                                      : null,
                        ),
                        SizedBox(height: 30),

                        //description
                        TextFormField(
                          controller: descController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(100, 0, 0, 0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        Row(
                          children: [
                            // Price
                            Expanded(
                              child: TextFormField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Enter a price';
                                  final number = num.tryParse(value);
                                  if (number == null || number <= 0) {
                                    return 'Enter a valid price';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Price (RM)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(100, 0, 0, 0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),

                            // Quantity
                            Expanded(
                              child: TextFormField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Enter quantity';
                                  final number = int.tryParse(value);
                                  if (number == null || number <= 0) {
                                    return 'Enter a valid quantity';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Quantity',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(100, 0, 0, 0),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        //Date Picker
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: () => _pickDate(context),
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Submit button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton(
                              onPressed: () async {
                                try {
                                  await crudService.deleteExpense(
                                    widget.expenseData!['id'],
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Expense deleted successfully',
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to delete: $e'),
                                    ),
                                  );
                                }
                              },
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.red,
                              ),
                              child: Text('Delete'),
                            ),
                            SizedBox(width: 16),
                            FilledButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  String imageUrl =
                                      widget.expenseData!['imageUrl'] ?? '';

                                  if (_receiptImage != null) {
                                    final uploadedUrl = await crudService
                                        .uploadImageToFirebase(_receiptImage!);
                                    if (uploadedUrl != null) {
                                      imageUrl = uploadedUrl;
                                    }
                                  }

                                  try {
                                    await crudService.updateExpense(
                                      widget.expenseData!['id'],
                                      {
                                        'name': nameController.text,
                                        'category': _selectedCategory!,
                                        'price': double.parse(
                                          priceController.text,
                                        ),
                                        'quantity': int.parse(
                                          quantityController.text,
                                        ),
                                        'date':
                                            _selectedDate, // or your selected date
                                        'desc': descController.text,
                                        'imageUrl': imageUrl,
                                      },
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to update: $e'),
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },

                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: buttonBackground,
                              ),
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), // Loader overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

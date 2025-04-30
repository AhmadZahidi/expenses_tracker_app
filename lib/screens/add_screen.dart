import 'dart:io';

import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable%20widget/background_screen.dart';
import 'package:expenses_tracker_app/reusable%20widget/crudbar.dart';
import 'package:expenses_tracker_app/services/crud_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddScreenState();
  }
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  DateTime? _selectedDate;
  File? _receiptImage;
  String? _uploadedImageUrl;

  final picker = ImagePicker();

  final CrudService crudService = CrudService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
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
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundScreen(
          appBar: Crudbar('Add Expenses'),
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
                            : Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Icon(Icons.camera_alt, size: 50),
                            ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      children: [
                        // Name
                        TextFormField(
                          controller: _nameController,
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
                          controller: _descController,
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
                                controller: _priceController,
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
                                controller: _quantityController,
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
                          controller: _dateController,
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
                              onPressed: () {
                                setState(() {
                                  _receiptImage = null;
                                  _uploadedImageUrl = null;
                                });
                              },
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  190,
                                  178,
                                  0,
                                ),
                              ),
                              child: Text('Clear Image'),
                            ),
                            SizedBox(width: 16),
                            FilledButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    if (_receiptImage != null &&
                                        _uploadedImageUrl == null) {
                                      await _uploadImage(_receiptImage!);
                                    }

                                    await crudService.addExpense(
                                      _nameController.text,
                                      _selectedCategory!,
                                      _descController.text,
                                      double.parse(_priceController.text),
                                      int.parse(_quantityController.text),
                                      _selectedDate!,
                                      _uploadedImageUrl,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Item added successfully',
                                        ),
                                      ),
                                    );

                                    // Reset form
                                    _formKey.currentState!.reset();
                                    _nameController.clear();
                                    _priceController.clear();
                                    _quantityController.clear();
                                    _descController.clear();
                                    _dateController.clear();
                                    _selectedCategory = null;
                                    _selectedDate = null;
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Something went wrong'),
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
                              child: Text('Submit'),
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

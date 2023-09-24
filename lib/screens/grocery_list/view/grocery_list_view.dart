import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training_basic/domain/models/grocery.dart';
import 'package:flutter_training_basic/screens/grocery_detail/view/grocery_detail_view.dart';
import 'package:flutter_training_basic/screens/grocery_list/view_model/grocery_list_view_model.dart';
import 'package:flutter_training_basic/shared/widgets/center_app_bar.dart';

import '../../../shared/widgets/custom_dialog.dart';
import '../../../shared/widgets/custom_textfield.dart';

class GroceryListView extends StatelessWidget {
  GroceryListView({super.key});

  final viewModel = GroceryListViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CenterAppBar(
          'Grocery',
          context,
          shouldShowLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showAddGroceryDialog(context);
          },
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: viewModel.getGroceryStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          final data = snapshot.requireData;
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                final grocery = Grocery();
                                grocery.name = data.docs[index]['name'];
                                grocery.description =
                                    data.docs[index]['description'];
                                grocery.quantity = data.docs[index]['quantity'];
                                grocery.imageUrl = data.docs[index]['imageUrl'];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroceryDetailView(grocery)));
                                    },
                                    leading: Image.network(grocery.imageUrl),
                                    title: Text(grocery.name),
                                    trailing: Text(grocery.quantity),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void showAddGroceryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      builder: (context) => CustomDialog(
        padding: EdgeInsets.zero,
        onPressed: () async {
          if (viewModel.groceryFormkey.currentState!.validate()) {
            viewModel.addGrocery();
            Navigator.of(context).pop();
          }
        },
        height: MediaQuery.of(context).size.height / 1.3,
        description: Padding(
            padding: const EdgeInsets.fromLTRB(23, 0, 23, 16),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: const EdgeInsets.only(bottom: 24, top: 16),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.primary,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Form(
                  key: viewModel.groceryFormkey,
                  child: Column(
                    children: [
                      CustomTextField(
                        viewModel.nameController,
                        labelText: 'Name',
                        required: true,
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'Please enter name.';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        viewModel.descriptionController,
                        labelText: 'Description',
                        required: true,
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'Please enter description.';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        viewModel.quantityController,
                        labelText: 'Quantity',
                        required: true,
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'Please enter quantity.';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        viewModel.imageUrlController,
                        labelText: 'Image',
                        required: true,
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty) {
                            return 'Please enter image url.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ))),
        bottomPadding: const EdgeInsets.only(bottom: 24),
        buttonLabel: 'ADD',
      ),
      barrierColor: Colors.black.withOpacity(0.4),
    );
  }
}

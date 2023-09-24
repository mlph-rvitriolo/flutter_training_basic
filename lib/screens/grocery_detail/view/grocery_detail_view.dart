import 'package:flutter/material.dart';
import 'package:flutter_training_basic/shared/widgets/center_app_bar.dart';

import '../../../domain/models/grocery.dart';

class GroceryDetailView extends StatelessWidget {
  const GroceryDetailView(this.grocery, {super.key});

  final Grocery grocery;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(grocery.name, context),
      body: Center(
        child: Column(
          children: [
            Image.network(grocery.imageUrl),
            const SizedBox(height: 16),
            Text(grocery.description,
                style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

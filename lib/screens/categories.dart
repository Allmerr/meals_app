import 'package:flutter/material.dart';
import 'package:meals_app/data/datas.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
    required this.meals,
  });

  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  void _selectedScreen(BuildContext context, Category category) {
    List<Meal> fillteredMeals =
        meals.where((meal) => meal.categories.contains(category.id)).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext buildContext) {
          return MealsScreen(
            title: category.title,
            meals: fillteredMeals,
            onToggleFavorite: onToggleFavorite,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in categoryData)
            CategoryGridItem(
              category: category,
              onTapCategory: () {
                _selectedScreen(context, category);
              },
            )
        ],
      ),
    );
  }
}

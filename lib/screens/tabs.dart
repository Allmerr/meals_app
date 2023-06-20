import 'package:flutter/material.dart';
import 'package:meals_app/data/datas.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _selectedIndex = 0;
  List<Meal> meals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _onSelectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onToggleMealFavorite(Meal meal) {
    var isExisting = meals.contains(meal);
    if (isExisting) {
      setState(() {
        meals.remove(meal);
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Remove to your favorite'),
        ),
      );
    } else {
      setState(() {
        meals.add(meal);
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add to your favorite'),
        ),
      );
    }
  }

  void _onSelectScreenDrawer(String screen) async {
    Navigator.of(context).pop();
    if (screen == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (BuildContext buildContext) {
            return FiltersScreen(
              filters: _selectedFilters,
            );
          },
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availbeMeals = mealsData.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }

      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }

      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }

      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }

      return true;
    }).toList();

    Widget content = CategoriesScreen(
      onToggleFavorite: _onToggleMealFavorite,
      meals: availbeMeals,
    );
    var title = 'Categories';

    if (_selectedIndex == 1) {
      title = 'Favorites';
      content = MealsScreen(
        meals: meals,
        onToggleFavorite: _onToggleMealFavorite,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: MainDrawer(onSelectScreen: _onSelectScreenDrawer),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onSelectTab,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/repositories/repository.dart';

class CategoryService {
  Repository _repository;
  CategoryService() {
    _repository = Repository();
  }
  saveCategory(Category category) async {
    return await _repository.insertData('category', category.categoryMap());
  }

  getCategory() async {
    return _repository.readData('category');
  }

  deleteCategory(int itemId) async {
    return _repository.deleteCategoryData('category', itemId);
  }
}

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

  deleteCategory(itemId) async {
    return _repository.deleteData('category', itemId);
  }

  updateCategory(Category category) async {
    return _repository.updateData('category', category);
  }
}

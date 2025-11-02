import '../models/category_model.dart';

class CategoryService {
  /// Mengambil daftar kategori perawatan
  List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        title: 'Hair Care',
        image: 'lib/assets/images/haircare.jpg',
        route: 'hair',
      ),
      CategoryModel(
        title: 'Skin Care',
        image: 'lib/assets/images/skincare.jpg',
        route: 'skin',
      ),
      CategoryModel(
        title: 'Body Care',
        image: 'lib/assets/images/bodycare.jpg',
        route: 'body',
      ),
      CategoryModel(
        title: 'Nail Care',
        image: 'lib/assets/images/nailcare.jpg',
        route: 'nail',
      ),
    ];
  }
}

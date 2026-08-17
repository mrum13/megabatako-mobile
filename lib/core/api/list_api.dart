class ListAPI {
  /// Auth
  static const String signIn = "/api/login";
  static const String signOut = "/api/logout";

  ///current user
  static const String currentUser = "/api/user";

  ///product category
  static const String getProductCategory = "/api/product-category";
  static const String storeProductCategory = "/api/product-category/store";
  static String updateProductCategory(int id) => "/api/product-category/update/$id";
  static String deleteProductCategory(int id) => "/api/product-category/destroy/$id";

  ///product
  static String getProductByCategory(int id) => "/api/product/$id";
  static const String storeProduct = "/api/product/store";
  static String updateProduct(int id) => "/api/product/update/$id";
  static String deleteProduct(int id) => "/api/product/destroy/$id";

  ///report
  static const String getReport = "/api/report";
  static const String storeReport = "/api/report/store";
  static String updateReport(int id) => "/api/report/update/$id";
  static String deleteReport(int id) => "/api/report/destroy/$id";
}

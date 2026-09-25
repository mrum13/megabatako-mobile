class ListAPI {
  /// Auth
  static const String signIn = "/api/login";
  static const String signOut = "/api/logout";

  ///current user
  static const String currentUser = "/api/user/current-user";

  ///employee
  static const String employee = "/api/user/list-user";
  static const String storeEmployee = "/api/user/store";
  static String updateEmployee (int id) => "/api/user/update/$id";
  static String deleteEmployee (int id) => "/api/user/destroy/$id";

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
  static String getReportByIdAndDate(int idEmployee, String date) => "/api/report/$idEmployee/$date";
  static String getReportDateById(int idEmployee) => "/api/report/mark-date/$idEmployee";
  static String getSummary(int idEmployee) => "/api/report/list/$idEmployee";
  static const String storeReport = "/api/report/store";
  static String updateReport(int id) => "/api/report/update/$id";
  static String deleteReport(int id) => "/api/report/destroy/$id";

  ///home
  static const String stockSummary = "/api/home/stock-summary";

  ///panjar
  static const String storePanjar = "/api/panjar/store";
  static String panjarById(int id) => "/api/panjar/$id";

  ///withdraw
  static const String storeWithdraw = "/api/withdraw/store";
  static String withdrawById(int id) => "/api/withdraw/$id";
}

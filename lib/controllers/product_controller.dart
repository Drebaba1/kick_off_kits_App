import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kickoff_kits/model/product_model.dart';

String AppID = '1QYCHEMCD2A56XT';
String APIkey = '8db7bfc9e3d846ccab477c4862e4235920240705140121945052';
String OrgID = '116774db5a58484196a7561a92e47700';

String timbuUrl =
    'https://api.timbu.cloud/products?organization_id=$OrgID&Appid=$AppID&Apikey=$APIkey';

class ProductController {
  static Future<List<ProductModel>> getProducts() async {
    List<ProductModel> allProducts = [];
    try {
      http.Response response = await http.get(Uri.parse(timbuUrl));
      // print(jsonDecode(response.body)['items'][6]);
      // print(jsonDecode(response.body)['items'][5]);
      if (response.statusCode == 200) {
        final items = jsonDecode(response.body)['items'];
        for (int i = 0; i < items.length; i++) {
          allProducts.add(ProductModel.fromMap(items[i]));
        }
        return allProducts;
      } else {
        print('Failed to load products: ${response.statusCode}');
        return [];
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
      return [];
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

  static Future<List<ProductModel>> getProductByCategory(
      String categoryName) async {
    List<ProductModel> filteredProducts = [];
    try {
      http.Response response = await http.get(Uri.parse(timbuUrl));

      if (response.statusCode == 200) {
        final items = jsonDecode(response.body)['items'];
        for (int i = 0; i < items.length; i++) {
          ProductModel product = ProductModel.fromMap(items[i]);

          if (product.categories.isNotEmpty) {
            bool matchesCategory = product.categories
                .any((category) => category['name'] == categoryName);
            if (matchesCategory) {
              filteredProducts.add(product);
            }
          }
        }
        return filteredProducts;
      } else {
        print('Failed to load products: ${response.statusCode}');
        return [];
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
      return [];
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
}

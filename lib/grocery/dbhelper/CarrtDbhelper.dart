import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProductManager {
  Database? _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), "ss5.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE products(id INTEGER PRIMARY KEY autoincrement, pname TEXT, pid TEXT, pimage TEXT, pprice TEXT, pQuantity INTEGER, pcolor TEXT, psize TEXT, pdiscription TEXT, sgst TEXT, cgst TEXT, discount TEXT, discountValue TEXT, adminper TEXT, adminpricevalue TEXT, costPrice TEXT,shipping TEXT,totalQuantity TEXT,varient TEXT,mv INT,moq TEXT,time1 TEXT,date1 TEXT)",
        );
      });
    }
  }

  Future<int> insertStudent(ProductsCart products) async {
    await openDb();
    return await _database!.insert('products', products.toMap());
  }

  Future<List<ProductsCart>> getProductList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.query('products');
    debugPrint("get product maps ==>" + maps.length.toString());
    var productList = List.generate(maps.length, (i) {
      return ProductsCart(
          id: maps[i]['id'],
          pname: maps[i]['pname'],
          pid: maps[i]['pid'],
          pimage: maps[i]['pimage'],
          pprice: maps[i]['pprice'],
          pQuantity: maps[i]['pQuantity'],
          pcolor: maps[i]['pcolor'],
          psize: maps[i]['psize'],
          pdiscription: maps[i]['pdiscription'],
          sgst: maps[i]['sgst'],
          cgst: maps[i]['cgst'],
          discount: maps[i]['discount'],
          discountValue: maps[i]['discountValue'],
          adminper: maps[i]['adminper'],
          adminpricevalue: maps[i]['adminpricevalue'],
          costPrice: maps[i]['costPrice'],
          shipping: maps[i]['shipping'],
          totalQuantity: maps[i]['totalQuantity'],
          varient: maps[i]['varient'],
          mv: maps[i]['mv'],
          moq: maps[i]['moq'],
          time1: maps[i]['time1'],
          date1: maps[i]['date1']);
    });
    print("FUNCTION PRODUCT LIST ===> " + productList.toString());
    return productList;

    // return List.generate(maps.length, (i) {
    //   return ProductsCart(
    //       id: maps[i]['id'],
    //       pname: maps[i]['pname'],
    //       pid: maps[i]['pid'],
    //       pimage: maps[i]['pimage'],
    //       pprice: maps[i]['pprice'],
    //       pQuantity: maps[i]['pQuantity'],
    //       pcolor: maps[i]['pcolor'],
    //       psize: maps[i]['psize'],
    //       pdiscription: maps[i]['pdiscription'],
    //       sgst: maps[i]['sgst'],
    //       cgst: maps[i]['cgst'],
    //       discount: maps[i]['discount'],
    //       discountValue: maps[i]['discountValue'],
    //       adminper: maps[i]['adminper'],
    //       adminpricevalue: maps[i]['adminpricevalue'],
    //       costPrice: maps[i]['costPrice'],
    //       shipping: maps[i]['shipping'],
    //       totalQuantity: maps[i]['totalQuantity'],
    //       varient: maps[i]['varient'],
    //       mv: maps[i]['mv'],
    //       moq: maps[i]['moq'],
    //       time1: maps[i]['time1'],
    //       date1: maps[i]['date1']);
    // });
  }

  Future<List<ProductsCart>> getProductList1(String pid) async {
    debugPrint("product list funtion called");
    await openDb();

    final List<Map<String, dynamic>> maps = await _database!.query('products',
        where: "pid = ?", whereArgs: [pid], orderBy: "mv ASC");
    debugPrint("query executed");
    var producsCart = List.generate(maps.length, (i) {
      return ProductsCart(
        id: maps[i]['id'],
        pname: maps[i]['pname'],
        pid: maps[i]['pid'],
        pimage: maps[i]['pimage'],
        pprice: maps[i]['pprice'],
        pQuantity: maps[i]['pQuantity'],
        pcolor: maps[i]['pcolor'],
        psize: maps[i]['psize'],
        pdiscription: maps[i]['pdiscription'],
        sgst: maps[i]['sgst'],
        cgst: maps[i]['cgst'],
        discount: maps[i]['discount'],
        discountValue: maps[i]['discountValue'],
        adminper: maps[i]['adminper'],
        adminpricevalue: maps[i]['adminpricevalue'],
        costPrice: maps[i]['costPrice'],
        shipping: maps[i]['shipping'],
        totalQuantity: maps[i]['totalQuantity'],
        varient: maps[i]['varient'],
        mv: maps[i]['mv'],
      );
    });

    // debugPrint(producsCart[0].pname.toString());

    return producsCart;

    // return List.generate(maps.length, (i) {
    //   return ProductsCart(
    //     id: maps[i]['id'],
    //     pname: maps[i]['pname'],
    //     pid: maps[i]['pid'],
    //     pimage: maps[i]['pimage'],
    //     pprice: maps[i]['pprice'],
    //     pQuantity: maps[i]['pQuantity'],
    //     pcolor: maps[i]['pcolor'],
    //     psize: maps[i]['psize'],
    //     pdiscription: maps[i]['pdiscription'],
    //     sgst: maps[i]['sgst'],
    //     cgst: maps[i]['cgst'],
    //     discount: maps[i]['discount'],
    //     discountValue: maps[i]['discountValue'],
    //     adminper: maps[i]['adminper'],
    //     adminpricevalue: maps[i]['adminpricevalue'],
    //     costPrice: maps[i]['costPrice'],
    //     shipping: maps[i]['shipping'],
    //     totalQuantity: maps[i]['totalQuantity'],
    //     varient: maps[i]['varient'],
    //     mv: maps[i]['mv'],
    //   );
    // });
  }

  Future<int> updateStudent(ProductsCart products) async {
    await openDb();
    return await _database!.update('products', products.toMap(),
        where: "id = ?", whereArgs: [products.id]);
  }

  Future<int> updateStudent1(ProductsCart products) async {
    await openDb();
    return await _database!.update('products', products.toMap(),
        where: "pid = ?", whereArgs: [products.pid]);
  }

  Future<void> deleteProducts(int id) async {
    await openDb();
    await _database!.delete('products', where: "id = ?", whereArgs: [id]);
    debugPrint("delete  called cartdb");
  }

  Future<void> deleteallProducts() async {
    await openDb();
    await _database!.delete('products');
    debugPrint("delete all called grocery");
    log('delete all called grocery');
  }
}

class ProductsCart {
  int? id;
  String? pname;
  String? pid;
  String? pimage;
  String? pprice;
  int? pQuantity;
  String? pcolor;
  String? psize;
  String? pdiscription;
  String? sgst;
  String? cgst;
  String? discount;
  String? discountValue;
  String? adminper;
  String? adminpricevalue;
  String? costPrice;
  String? shipping;
  String? totalQuantity;
  String? varient;
  String? time1;
  String? date1;
  int? mv;
  String? moq;

  set price(String price) {
    this.pprice = price;
  }

  set quantity(int pQuantity) {
    this.pQuantity = pQuantity;
  }

  String get price => this.pprice??"";
  int get quantity => this.pQuantity!;
//
  ProductsCart({
    @required this.pname,
    @required this.pid,
    @required this.pimage,
    @required this.pprice,
    @required this.pQuantity,
    @required this.pcolor,
    @required this.psize,
    @required this.pdiscription,
    @required this.sgst,
    @required this.cgst,
    @required this.discount,
    @required this.discountValue,
    @required this.adminper,
    @required this.adminpricevalue,
    @required this.costPrice,
    @required this.shipping,
    @required this.totalQuantity,
    @required this.varient,
    @required this.mv,
    @required this.moq,
    @required this.time1,
    @required this.date1,
    @required this.id,
  });
  Map<String, dynamic> toMap() {
    return {
      'pname': pname,
      'pid': pid,
      'pimage': pimage,
      'pprice': pprice,
      'pQuantity': pQuantity,
      'pcolor': pcolor,
      'psize': psize,
      'pdiscription': pdiscription,
      'sgst': sgst,
      'cgst': cgst,
      'discount': discount,
      'discountValue': discountValue,
      'adminper': adminper,
      'adminpricevalue': adminpricevalue,
      'costPrice': costPrice,
      'shipping': shipping,
      'totalQuantity': totalQuantity,
      'varient': varient,
      'mv': mv,
      'moq': moq,
      'time1': time1,
      'date1': date1
    };
  }
}

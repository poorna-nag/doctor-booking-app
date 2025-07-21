import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProductManager1 {
  Database? _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), "ws3.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE wproducts(id INTEGER PRIMARY KEY autoincrement, pname TEXT, pid TEXT, pimage TEXT, pprice TEXT, pQuantity INTEGER, pcolor TEXT, psize TEXT, pdiscription TEXT, sgst TEXT, cgst TEXT, discount TEXT, discountValue TEXT, adminper TEXT, adminpricevalue TEXT, costPrice TEXT)",
        );
      });
    }
  }

  Future<int> insertStudent(WishlistsCart wproducts) async {
    await openDb();
    return await _database!.insert('wproducts', wproducts.toMap());
  }

  Future<List<WishlistsCart>> getProductList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.query('wproducts');
    return List.generate(maps.length, (i) {
      return WishlistsCart(
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
          costPrice: maps[i]['costPrice']);
    });
  }

  Future<int> updateStudent(WishlistsCart wproducts) async {
    await openDb();
    return await _database!.update('wproducts', wproducts.toMap(),
        where: "id = ?", whereArgs: [wproducts.id]);
  }

  Future<void> deleteProducts(int id) async {
    await openDb();
    await _database!.delete('wproducts', where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteallProducts() async {
    await openDb();
    await _database!.delete('wproducts');
  }
}

class WishlistsCart {
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

  WishlistsCart(
      {@required this.pname,
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
      this.costPrice,
      @required this.adminper,
      @required this.adminpricevalue,
      @required this.id});
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
    };
  }
}

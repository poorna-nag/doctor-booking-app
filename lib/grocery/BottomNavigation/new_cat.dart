import 'package:flutter/material.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/CategaryModal.dart';
import 'package:ecoshine24/grocery/screen/secondtabview.dart';

class My_Cat extends StatefulWidget {
  @override
  _My_CatState createState() => _My_CatState();
}

class _My_CatState extends State<My_Cat> {
  List<Categary> cat_list = [];
  List<Categary> sub_cat_list = [];

  getlistval(String id) {
    getData(id).then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            sub_cat_list = usersFromServe;
          });
        }
      }
    });
  }

  bool flag = false;
  @override
  void initState() {
    getData("0").then((usersFromServe) {
      if (this.mounted) {
        if (usersFromServe != null) {
          setState(() {
            cat_list = usersFromServe;
            // cat_list.length>0?getlistval(cat_list[0].pcatId):"";
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF1B5E20), // Dark green
                Color(0xFF2E7D32), // Medium dark green
                Color(0xFF388E3C), // Slightly lighter green
              ],
            ),
          ),
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Search functionality
              },
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            flag
                ? sub_cat_list != null
                    ? sub_cat_list.length > 0
                        ? Expanded(
                            flex: 3,
                            child: Container(
                              child: show_cat_subnam(),
                            ),
                          )
                        : SizedBox()
                    : SizedBox()
                : SizedBox(),
            cat_list != null
                ? cat_list.length > 0
                    ? Container(
                        width: flag ? 140 : double.infinity,
                        child: show_catnam(),
                      )
                    : SizedBox()
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  int val = -1;
  int grid = -1;
  ShowColor(int index) {
    setState(() {
      val = index;
    });
  }

  GridShowColor(int index) {
    setState(() {
      grid = index;
    });
  }

  Widget show_catnam() {
    return Container(
      margin: EdgeInsets.only(top: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: cat_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: val == index
                        ? Color(0xFF1B5E20).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: val == index
                        ? Border.all(color: Color(0xFF1B5E20), width: 1)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Screen2(
                                      cat_list[index].pcatId ?? "",
                                      cat_list[index].pCats ?? "")),
                            );
                            ShowColor(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Text(
                              cat_list[index].pCats ?? "",
                              style: TextStyle(
                                color: val == index
                                    ? Color(0xFF1B5E20)
                                    : Colors.black87,
                                fontWeight: val == index
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            getlistval(cat_list[index].pcatId ?? "");
                            flag = true;
                            ShowColor(index);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: val == index
                                ? Color(0xFF1B5E20)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color:
                                val == index ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (index < cat_list.length - 1)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
              ],
            );
          }),
    );
  }

  Widget show_cat_subnam() {
    return Container(
      margin: EdgeInsets.only(top: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: sub_cat_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: grid == index
                        ? Color(0xFF1B5E20).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: grid == index
                        ? Border.all(color: Color(0xFF1B5E20), width: 1)
                        : null,
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      sub_cat_list[index].pCats ?? "",
                      style: TextStyle(
                        color:
                            grid == index ? Color(0xFF1B5E20) : Colors.black87,
                        fontSize: 14,
                        fontWeight:
                            grid == index ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: grid == index
                            ? Color(0xFF1B5E20)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        grid != index
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: grid == index ? Colors.white : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      if (grid != index) {
                        GridShowColor(index);
                      } else {
                        setState(() {
                          grid = -1;
                        });
                      }
                    },
                  ),
                ),
                if (index < sub_cat_list.length - 1 && grid != index)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                grid == index
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF1B5E20).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF1B5E20).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: FutureBuilder(
                            future: getData(sub_cat_list[index].pcatId ?? ""),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data == null
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF1B5E20)),
                                        ),
                                      )
                                    : GridView.builder(
                                        physics: ClampingScrollPhysics(),
                                        controller: new ScrollController(
                                            keepScrollOffset: false),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(8),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          childAspectRatio: 0.8,
                                        ),
                                        itemBuilder: (context, gridIndex) {
                                          Categary item =
                                              snapshot.data![gridIndex];
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Screen2(
                                                            item.pcatId ?? "",
                                                            item.pCats ?? "")),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 5,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(8),
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor:
                                                          Color(0xFF1B5E20)
                                                              .withOpacity(0.1),
                                                      child: ClipOval(
                                                        child: new SizedBox(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          child: item.img!
                                                                      .length >
                                                                  0
                                                              ? Image.network(
                                                                  GroceryAppConstant
                                                                          .base_url +
                                                                      "manage/uploads/p_category/" +
                                                                      item.img
                                                                          .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Icon(
                                                                      Icons
                                                                          .category,
                                                                      color: Color(
                                                                          0xFF1B5E20),
                                                                      size: 24,
                                                                    );
                                                                  },
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .category,
                                                                  color: Color(
                                                                      0xFF1B5E20),
                                                                  size: 24,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    child: Text(
                                                      item.pCats ?? "",
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: snapshot.data?.length == null
                                            ? 0
                                            : snapshot.data?.length,
                                      );
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF1B5E20)),
                                ),
                              );
                            }),
                      )
                    : SizedBox.shrink(),
              ],
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../General/AppConstant.dart';
import '../model/CategaryModal.dart';
import '../dbhelper/database_helper.dart';

class CategorySelectionModal extends StatefulWidget {
  final Function(String categoryId) onCategorySelected;

  const CategorySelectionModal({
    Key? key,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _CategorySelectionModalState createState() => _CategorySelectionModalState();
}

class _CategorySelectionModalState extends State<CategorySelectionModal> {
  List<Categary> mainCategories = [];
  List<Categary> subCategories = [];
  List<Categary> subSubCategories = [];

  // Search functionality
  List<Categary> filteredSubCategories = [];
  List<Categary> filteredSubSubCategories = [];
  TextEditingController subSearchController = TextEditingController();
  TextEditingController subSubSearchController = TextEditingController();

  String selectedMainCategoryId = "";
  String selectedSubCategoryId = "";
  String selectedSubSubCategoryId = "";

  String currentLevel = "main"; // main, sub, subsub
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMainCategories();
  }

  @override
  void dispose() {
    subSearchController.dispose();
    subSubSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadMainCategories() async {
    setState(() {
      isLoading = true;
    });

    try {
      var categories = await getData("0");
      setState(() {
        mainCategories = (categories ?? []).reversed.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error loading main categories: $e");
    }
  }

  // Search methods
  void _searchSubCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSubCategories = subCategories;
      } else {
        filteredSubCategories = subCategories.where((category) {
          return category.pCats?.toLowerCase().contains(query.toLowerCase()) ??
              false;
        }).toList();
      }
    });
  }

  void _searchSubSubCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSubSubCategories = subSubCategories;
      } else {
        filteredSubSubCategories = subSubCategories.where((category) {
          return category.pCats?.toLowerCase().contains(query.toLowerCase()) ??
              false;
        }).toList();
      }
    });
  }

  Future<void> _loadSubCategories(String mainCategoryId) async {
    setState(() {
      isLoading = true;
      selectedMainCategoryId = mainCategoryId;
      currentLevel = "sub";
    });

    try {
      var categories = await getData(mainCategoryId);
      setState(() {
        subCategories = categories ?? [];
        filteredSubCategories = categories ?? []; // Initialize filtered list
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error loading sub categories: $e");
    }
  }

  Future<void> _loadSubSubCategories(String subCategoryId) async {
    setState(() {
      isLoading = true;
      selectedSubCategoryId = subCategoryId;
      currentLevel = "subsub";
    });

    try {
      var categories = await getData(subCategoryId);
      setState(() {
        subSubCategories = categories ?? [];
        filteredSubSubCategories = categories ?? []; // Initialize filtered list
        isLoading = false;
      });

      // If no sub-sub categories, finalize selection with sub category
      if (subSubCategories.isEmpty) {
        // Find the category name and image for the selected subcategory
        String categoryName = "Selected Category";
        String? categoryImage;
        try {
          var category =
              subCategories.firstWhere((cat) => cat.pcatId == subCategoryId);
          categoryName = category.pCats ?? "Selected Category";
          categoryImage = category.img;
        } catch (e) {
          // Category not found, use default
        }

        // Save category image to SharedPreferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        if (categoryImage != null && categoryImage.isNotEmpty) {
          await pref.setString("selectedCategoryImage", categoryImage);
        } else {
          await pref.remove("selectedCategoryImage");
        }

        _finalizeSelection(subCategoryId, categoryName);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error loading sub sub categories: $e");
    }
  }

  Future<void> _finalizeSelection(String categoryId,
      [String? categoryName]) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("selectedCategoryId", categoryId);

      // Save category name and image if provided
      if (categoryName != null && categoryName.isNotEmpty) {
        await pref.setString("selectedCategoryName", categoryName);
      }

      // Find and save category image
      String? categoryImage;
      if (currentLevel == "subsub" && subSubCategories.isNotEmpty) {
        try {
          var category =
              subSubCategories.firstWhere((cat) => cat.pcatId == categoryId);
          categoryImage = category.img;
        } catch (e) {
          print("Category not found in subSubCategories");
        }
      } else if (currentLevel == "sub" && subCategories.isNotEmpty) {
        try {
          var category =
              subCategories.firstWhere((cat) => cat.pcatId == categoryId);
          categoryImage = category.img;
        } catch (e) {
          print("Category not found in subCategories");
        }
      }

      if (categoryImage != null && categoryImage.isNotEmpty) {
        await pref.setString("selectedCategoryImage", categoryImage);
        print("Saved category image: $categoryImage");
      } else {
        await pref.remove("selectedCategoryImage");
        print("No category image found, removed from preferences");
      }

      print(
          "Finalizing selection - ID: $categoryId, Name: $categoryName, Image: $categoryImage");

      // Close modal first
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Then trigger callback after a short delay
      await Future.delayed(Duration(milliseconds: 150));

      if (mounted) {
        widget.onCategorySelected(categoryId);
      }
    } catch (e) {
      print("Error in _finalizeSelection: $e");
      // Still try to close the modal if there's an error
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _goBack() {
    setState(() {
      if (currentLevel == "subsub") {
        currentLevel = "sub";
        subSubCategories.clear();
      } else if (currentLevel == "sub") {
        currentLevel = "main";
        subCategories.clear();
        selectedMainCategoryId = "";
      }
    });
  }

  String _getTitle() {
    switch (currentLevel) {
      case "main":
        return "Select Subscription";
      case "sub":
        return "Select Category";
      case "subsub":
        return "Select Specific Item";
      default:
        return "Select Category";
    }
  }

  List<Categary> _getCurrentList() {
    switch (currentLevel) {
      case "main":
        return mainCategories;
      case "sub":
        return subCategories;
      case "subsub":
        return subSubCategories;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (currentLevel != "main")
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: GroceryAppColors.black),
                      onPressed: _goBack,
                      padding: EdgeInsets.zero,
                    ),
                  Expanded(
                    child: Text(
                      _getTitle(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: GroceryAppColors.black,
                      ),
                      textAlign: currentLevel == "main"
                          ? TextAlign.center
                          : TextAlign.left,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              GroceryAppColors.tela),
                        ),
                      )
                    : _getCurrentList().isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.category_outlined,
                                    size: 64, color: Colors.grey[400]),
                                SizedBox(height: 16),
                                Text(
                                  "No categories found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _buildCategoryContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContent() {
    if (currentLevel == "main") {
      return _buildMainCategorySelection();
    } else if (currentLevel == "sub") {
      return _buildSubCategoryGrid();
    } else {
      return _buildFinalCategoryGrid();
    }
  }

  Widget _buildMainCategorySelection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mainCategories.length > 1)
            Text(
              "You can change this from home screen",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          SizedBox(height: 20),

          // Main category cards
          ...mainCategories
              .take(2)
              .map((category) => _buildMainCategoryCard(category))
              .toList(),

          if (mainCategories.length > 2) SizedBox(height: 20),
          if (mainCategories.length > 2)
            Text(
              "OR",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          if (mainCategories.length > 2) SizedBox(height: 20),
          if (mainCategories.length > 2)
            ...mainCategories
                .skip(2)
                .map((category) => _buildMainCategoryCard(category))
                .toList(),
        ],
      ),
    );
  }

  Widget _buildMainCategoryCard(Categary category) {
    return Container(
      margin: EdgeInsets.only(bottom: 14), // Reduced by 30% from 20
      child: InkWell(
        onTap: () => _loadSubCategories(category.pcatId!),
        borderRadius: BorderRadius.circular(11), // Reduced by 30% from 15
        child: Container(
          padding: EdgeInsets.all(14), // Reduced by 30% from 20
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11), // Reduced by 30% from 15
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 7, // Reduced by 30% from 10
                offset: Offset(0, 1), // Reduced by 30% from 2
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.pCats?.toUpperCase() ?? "CATEGORY",
                      style: TextStyle(
                        fontSize: 13, // Reduced by 30% from 18
                        fontWeight: FontWeight.bold,
                        color: GroceryAppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 84, // Reduced by 30% from 120
                height: 56, // Reduced by 30% from 80
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12), // Border radius only for image
                  child: category.img != null && category.img!.isNotEmpty
                      ? Image.network(
                          GroceryAppConstant.logo_Image_Pcat + category.img!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/icon/app_logo.png",
                              fit: BoxFit.contain,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/icon/app_logo.png",
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryGrid() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[500], size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: subSearchController,
                    onChanged: _searchSubCategories,
                    decoration: InputDecoration(
                      hintText: "Search categories...",
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (subSearchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      subSearchController.clear();
                      _searchSubCategories("");
                    },
                    child: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                  ),
              ],
            ),
          ),
          SizedBox(height: 24),

          if (filteredSubCategories.length > 8 &&
              subSearchController.text.isEmpty) ...[
            Text(
              "Popular Categories",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: GroceryAppColors.black,
              ),
            ),
            SizedBox(height: 16),
            _buildCategoryGrid(filteredSubCategories.take(8).toList()),
            SizedBox(height: 24),
            Text(
              "All Categories",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: GroceryAppColors.black,
              ),
            ),
            SizedBox(height: 16),
            _buildCategoryGrid(filteredSubCategories.skip(8).toList()),
          ] else ...[
            _buildCategoryGrid(filteredSubCategories),
          ],
        ],
      ),
    );
  }

  Widget _buildFinalCategoryGrid() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[500], size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: subSubSearchController,
                    onChanged: _searchSubSubCategories,
                    decoration: InputDecoration(
                      hintText: "Search items...",
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (subSubSearchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      subSubSearchController.clear();
                      _searchSubSubCategories("");
                    },
                    child: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                  ),
              ],
            ),
          ),
          SizedBox(height: 24),

          _buildFinalCategoryList(filteredSubSubCategories),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(List<Categary> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Changed from 3 to 4
        childAspectRatio: 1.0,
        crossAxisSpacing: 12, // Reduced spacing for 4 columns
        mainAxisSpacing: 12, // Reduced spacing for 4 columns
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        Categary category = categories[index];
        return _buildBrandCard(category);
      },
    );
  }

  Widget _buildBrandCard(Categary category) {
    return InkWell(
      onTap: () {
        if (currentLevel == "sub") {
          _loadSubSubCategories(category.pcatId!);
        }
      },
      borderRadius: BorderRadius.circular(8), // Reduced by 30% from 12
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // Reduced by 30% from 12
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6, // Reduced by 30% from 8
              offset: Offset(0, 1), // Reduced by 30% from 2
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50, // Increased from 30
              height: 50, // Increased from 30
              child: category.img != null && category.img!.isNotEmpty
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), // Increased border radius
                      child: Image.network(
                        GroceryAppConstant.logo_Image_Pcat + category.img!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // Increased border radius
                            child: Image.asset(
                              "assets/icon/app_logo.png",
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    )
                  : ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), // Increased border radius
                      child: Image.asset(
                        "assets/icon/app_logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
            SizedBox(height: 6), // Reduced by 30% from 8
            Text(
              category.pCats ?? "Category",
              style: TextStyle(
                fontSize: 8, // Reduced by 30% from 12
                fontWeight: FontWeight.w500,
                color: GroceryAppColors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalCategoryList(List<Categary> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Changed from 3 to 4
        childAspectRatio: 0.8,
        crossAxisSpacing: 6, // Reduced spacing for 4 columns
        mainAxisSpacing: 8, // Reduced spacing for 4 columns
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        Categary category = categories[index];
        return _buildFinalCategoryCard(category);
      },
    );
  }

  Widget _buildFinalCategoryCard(Categary category) {
    return InkWell(
      onTap: () => _finalizeSelection(category.pcatId!, category.pCats),
      borderRadius: BorderRadius.circular(8), // Reduced by 30% from 12
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // Reduced by 30% from 12
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6, // Reduced by 30% from 8
              offset: Offset(0, 1), // Reduced by 30% from 2
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(6), // Reduced by 30% from 8
                child: category.img != null && category.img!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Increased border radius
                        child: Image.network(
                          GroceryAppConstant.logo_Image_Pcat + category.img!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  12), // Increased border radius
                              child: Image.asset(
                                "assets/icon/app_logo.png",
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Increased border radius
                        child: Image.asset(
                          "assets/icon/app_logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6), // Reduced by 30% from 8
              child: Text(
                category.pCats ?? "Item",
                style: TextStyle(
                  fontSize: 8, // Reduced by 30% from 12
                  fontWeight: FontWeight.w500,
                  color: GroceryAppColors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

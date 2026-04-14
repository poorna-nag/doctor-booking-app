import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoshine24/grocery/dbhelper/database_helper.dart';
import 'package:ecoshine24/grocery/model/TrackInvoiceModel.dart';
import 'package:ecoshine24/grocery/screen/Finaltracking.dart';
import 'package:ecoshine24/grocery/screen/trackorder.dart';
import 'package:ecoshine24/grocery/General/AppConstant.dart';
import 'package:ecoshine24/grocery/General/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackOrder extends StatefulWidget {
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  String? mobile;
  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? mob = pre.getString("mobile");
    this.setState(() {
      mobile = mob;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8FBFF), // Medical light background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1E88E5), // Medical blue
              Color(0xff42A5F5), // Lighter medical blue
              Color(0xff64B5F6), // Lightest medical blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: GroceryAppColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: GroceryAppColors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: GroceryAppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff1E88E5), // Medical blue
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "My Appointments",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(width: 36), // For symmetry
                    ],
                  ),
                ),
              ),
              // Body Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: FutureBuilder(
                    future: trackInvoice(mobile ?? ""),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      GroceryAppColors.white),
                                  strokeWidth: 3,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Loading your appointments...",
                                  style: TextStyle(
                                    color:
                                        GroceryAppColors.white.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return _buildEmptyState();
                        }

                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              TrackInvoice item = snapshot.data![index];
                              return _buildModernBookingCard(
                                  context, item, index);
                            },
                          ),
                        );
                      } else {
                        return _buildEmptyState();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: GroceryAppColors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: GroceryAppColors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 60,
                color: GroceryAppColors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "No Appointments Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GroceryAppColors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Your appointment history will appear here\nonce you book your first appointment",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: GroceryAppColors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GroceryAppColors.white,
                    GroceryAppColors.white.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to home page and clear the navigation stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GroceryApp()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Book Appointment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1E88E5), // Medical blue
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernBookingCard(
      BuildContext context, TrackInvoice item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shadowColor: Color(0xff1E88E5).withOpacity(0.2), // Medical blue shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FinalOrderTracker(
                  item.id,
                  item.deliveryDate,
                  item.states,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xff1E88E5).withOpacity(0.02), // Medical blue tint
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with invoice ID and status badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Appointment #${item.id ?? ""}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1E88E5), // Medical blue
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _formatDate(item.created ?? ""),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff1E88E5)
                                  .withOpacity(0.7), // Medical blue
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(item.states ?? ""),
                  ],
                ),

                SizedBox(height: 16),

                // Divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xff1E88E5).withOpacity(0.2), // Medical blue
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Amount and Details
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        icon: Icons.account_balance_wallet,
                        label: "Total Amount",
                        value:
                            "₹${(double.parse(item.invoiceTotal ?? "0") + double.parse(item.shipping ?? "0")).toStringAsFixed(2)}",
                        color: const Color.fromARGB(255, 42, 137, 200),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoTile(
                        icon: Icons.location_on,
                        label: "Delivery To",
                        value: "${item.city ?? "N/A"}",
                        color: const Color.fromARGB(255, 42, 137, 200),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Date, Time, and Notes Section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromARGB(255, 34, 137, 210)
                            .withOpacity(0.05),
                        const Color.fromARGB(255, 34, 137, 210)
                            .withOpacity(0.02), // Orange theme
                        // const Color.fromARGB(255, 34, 137, 210), // Orange theme
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color.fromARGB(255, 24, 123, 228)
                            .withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Booking Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 29, 162, 223),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoTile(
                              icon: Icons.calendar_today,
                              label: "Date",
                              value:
                                  item.adate != null && item.adate!.isNotEmpty
                                      ? item.adate!
                                      : _formatDate(item.created ?? ""),
                              color: const Color.fromARGB(
                                  255, 43, 140, 225), // Orange theme
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoTile(
                              icon: Icons.access_time,
                              label: "Time",
                              value:
                                  item.atime != null && item.atime!.isNotEmpty
                                      ? item.atime!
                                      : _formatTime(item.created ?? ""),
                              color: const Color.fromARGB(255, 38, 118, 197),
                            ),
                          ),
                        ],
                      ),
                      if (item.notes != null && item.notes!.isNotEmpty) ...[
                        SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.note,
                              size: 20,
                              color: const Color.fromARGB(
                                  255, 39, 112, 181), // Orange theme
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Notes",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(
                                          255, 40, 139, 206),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    item.notes ?? "",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color.fromARGB(
                                          255, 28, 125, 194), // Orange theme
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 40, 150, 234)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FinalOrderTracker(
                                  item.id,
                                  item.deliveryDate,
                                  item.states,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.visibility, size: 18),
                          label: Text("View Details"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 41, 154, 229),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    if (item.awbCode != null) ...[
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                GroceryAppColors.boxColor1, // Orange
                                GroceryAppColors.tela1, // Light orange
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyOrdertrack(item.awbCode ?? ""),
                                ),
                              );
                            },
                            icon: Icon(Icons.local_shipping, size: 18),
                            label: Text("Track Order"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        icon = Icons.schedule;
        break;
      case 'confirmed':
        backgroundColor = Color(0xff1E88E5).withOpacity(0.1); // Medical blue
        textColor = Color(0xff1E88E5); // Medical blue
        icon = Icons.check_circle_outline;
        break;
      case 'processing':
        backgroundColor = Color(0xff1E88E5).withOpacity(0.1); // Medical blue
        textColor = Color(0xff1E88E5); // Medical blue
        icon = Icons.sync;
        break;
      case 'shipped':
        backgroundColor = Color(0xff1E88E5).withOpacity(0.15); // Medical blue
        textColor = Color(0xff1E88E5); // Medical blue
        icon = Icons.local_shipping;
        break;
      case 'delivered':
        backgroundColor =
            Color(0xff64B5F6).withOpacity(0.15); // Light medical blue
        textColor = Color(0xff1E88E5); // Medical blue
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        icon = Icons.info;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return "${date.day} ${months[date.month - 1]} ${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      String minute = date.minute.toString().padLeft(2, '0');
      String period = date.hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      int hour12 =
          date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      String hour12Str = hour12.toString().padLeft(2, '0');

      return "$hour12Str:$minute $period";
    } catch (e) {
      return "N/A";
    }
  }
}

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class DateRangeResult {
  DateTime startDate;
  DateTime endDate;

  DateRangeResult({required this.startDate, required this.endDate});
}

class DateRangeFilter {
  DateRangeFilter(
      {required this.context,
      required this.color,
      String? closeButtonText,
      String? title,
      String? todayLabel,
      String? yesterdayLabel,
      String? last7DaysLabel,
      String? last30DaysLabel,
      String? thisMonthLabel,
      String? lastMonthLabel,
      String? customRangeLabel,
      Color? primaryColor});

  DateTime? startDate;
  DateTime? endDate;
  BuildContext? context;
  Color? color;
  String? closeButtonText;
  String? title;
  String? todayLabel;
  String? yesterdayLabel;
  String? last7DaysLabel;
  String? last30DaysLabel;
  String? thisMonthLabel;
  String? lastMonthLabel;
  String? customRangeLabel;

  Widget filterItemButton(String label, int btnID, BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () async {
          var now = DateTime.now();
          if (btnID == 1) {
            /// today
            startDate = now;
            endDate = now;
          } else if (btnID == 2) {
            /// yesterday
            startDate = now.subtract(Duration(days: 1));
            endDate = now.subtract(Duration(days: 1));
          } else if (btnID == 3) {
            /// last 7 days
            startDate = now.subtract(Duration(days: 6));
            endDate = now;
          } else if (btnID == 4) {
            /// last 30 days
            startDate = now.subtract(Duration(days: 29));
            endDate = now;
          } else if (btnID == 5) {
            /// this month
            startDate = DateTime.utc(now.year, now.month, 1);
            endDate = DateTime.utc(
                now.year, now.month, DateTime(now.year, now.month + 1, 0).day);
          } else if (btnID == 6) {
            /// last month
            startDate = DateTime.utc(now.month == 1 ? now.year - 1 : now.year,
                now.month > 1 ? now.month - 1 : 12, 1);
            endDate = DateTime.utc(
                now.month == 1 ? now.year - 1 : now.year,
                now.month > 1 ? now.month - 1 : 12,
                DateTime(now.month == 1 ? now.year - 1 : now.year,
                        (now.month > 1 ? now.month - 1 : 12) + 1, 0)
                    .day);
          } else if (btnID == 7) {
            /// custom range
            var res = await showCalendarDatePicker2Dialog(
              context: context!,
              config: CalendarDatePicker2WithActionButtonsConfig(
                calendarType: CalendarDatePicker2Type.range,
              ),
              dialogSize: const Size(325, 400),
              borderRadius: BorderRadius.circular(15),
            );

            if (res != null && res.length > 0) {
              startDate = res[0]!;
              endDate = res[1]!;
            } else {
              startDate = now;
              endDate = now;
            }
          }
          Navigator.pop(ctx);
        },
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Future<DateRangeResult?> get getSelectedDate async {
    await showDialog(
      context: context!,
      builder: (BuildContext ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: MediaQuery.sizeOf(context!).height * 0.5,
          padding: EdgeInsets.all(0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Center(
                        child: Text(
                          title ?? "Date Range Filter",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    filterItemButton(todayLabel ?? "Today", 1, ctx),
                    Divider(thickness: 1, height: 0),
                    filterItemButton(yesterdayLabel ?? "Yesterday", 2, ctx),
                    Divider(thickness: 1, height: 0),
                    filterItemButton(last7DaysLabel ?? "Last 7 Days", 3, ctx),
                    Divider(thickness: 1, height: 0),
                    filterItemButton(last30DaysLabel ?? "Last 30 Days", 4, ctx),
                    Divider(thickness: 1, height: 0),
                    filterItemButton(thisMonthLabel ?? "This Month", 5, ctx),
                    Divider(thickness: 1, height: 0),
                    filterItemButton(lastMonthLabel ?? "Last Month", 6, ctx),
                    Divider(thickness: 1, height: 0),
                    filterItemButton(
                        customRangeLabel ?? "Custom Range", 7, ctx),
                    SizedBox(height: 60),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context!);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Center(
                      child: Text(
                        closeButtonText ?? "Cancel",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return startDate != null && endDate != null
        ? DateRangeResult(
            startDate: startDate!,
            endDate: endDate!,
          )
        : null;
  }
}

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class DateRangeResult {
  DateTime startDate;
  DateTime endDate;

  DateRangeResult({required this.startDate, required this.endDate});
}

class DateRangeFilter {
  DateRangeFilter({
    required this.context,
    required this.color,
    required this.labelColor,
    this.closeButtonText,
    this.title,
    this.todayLabel,
    this.yesterdayLabel,
    this.last7DaysLabel,
    this.last30DaysLabel,
    this.thisMonthLabel,
    this.lastMonthLabel,
    this.thisYearLabel,
    this.lastYearLabel,
    this.customRangeLabel,
    this.customDateTimeLabel,
  });

  DateTime? startDate;
  DateTime? endDate;
  BuildContext? context;
  Color? color;
  Color? labelColor;
  Color? closeButtonColor;
  Color? titleColor;
  String? closeButtonText;
  String? title;
  String? todayLabel;
  String? yesterdayLabel;
  String? last7DaysLabel;
  String? last30DaysLabel;
  String? thisMonthLabel;
  String? lastMonthLabel;
  String? thisYearLabel;
  String? lastYearLabel;
  String? customRangeLabel;
  String? customDateTimeLabel;

  Widget filterItemButton(String label, int btnID, BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: labelColor,
        ),
        onPressed: () async {
          var now = DateTime.now();
          if (btnID == 1) {
            startDate = now;
            endDate = now;
          } else if (btnID == 2) {
            startDate = now.subtract(Duration(days: 1));
            endDate = now.subtract(Duration(days: 1));
          } else if (btnID == 3) {
            startDate = now.subtract(Duration(days: 6));
            endDate = now;
          } else if (btnID == 4) {
            startDate = now.subtract(Duration(days: 29));
            endDate = now;
          } else if (btnID == 5) {
            startDate = DateTime(now.year, now.month, 1);
            endDate = DateTime(now.year, now.month + 1, 0);
          } else if (btnID == 6) {
            startDate = DateTime(now.month == 1 ? now.year - 1 : now.year,
                now.month > 1 ? now.month - 1 : 12, 1);
            endDate = DateTime(now.month == 1 ? now.year - 1 : now.year,
                now.month > 1 ? now.month : 1, 0);
          } else if (btnID == 7) {
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
          } else if (btnID == 8) {
            /// this year
            startDate = DateTime(now.year, 1, 1);
            endDate = DateTime(now.year, 12, 31);
          } else if (btnID == 9) {
            /// last year
            startDate = DateTime(now.year - 1, 1, 1);
            endDate = DateTime(now.year - 1, 12, 31);
          } else if (btnID == 10) {
            /// custom datetime
            DateTime? pickedStart = await showDatePicker(
              context: context!,
              initialDate: now,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedStart != null) {
              TimeOfDay? startTime = await showTimePicker(
                context: context!,
                initialTime: TimeOfDay.now(),
              );
              if (startTime != null) {
                startDate = DateTime(pickedStart.year, pickedStart.month,
                    pickedStart.day, startTime.hour, startTime.minute);
                endDate = DateTime(pickedStart.year, pickedStart.month,
                    pickedStart.day, startTime.hour, startTime.minute);
              }
            }
          }

          Navigator.pop(ctx);
        },
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
          height: 60 * 10,
          padding: const EdgeInsets.all(0),
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          title ?? "Date Range Filter",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: titleColor ?? Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    filterItemButton(todayLabel ?? "Today", 1, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(yesterdayLabel ?? "Yesterday", 2, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(last7DaysLabel ?? "Last 7 Days", 3, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(last30DaysLabel ?? "Last 30 Days", 4, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(thisMonthLabel ?? "This Month", 5, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(lastMonthLabel ?? "Last Month", 6, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(thisYearLabel ?? "This Year", 8, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(lastYearLabel ?? "Last Year", 9, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(
                        customDateTimeLabel ?? "Custom Date Time", 10, ctx),
                    const Divider(thickness: 0.5, height: 0),
                    filterItemButton(
                        customRangeLabel ?? "Custom Date Range", 7, ctx), 
                    const SizedBox(height: 60),
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
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        closeButtonText ?? "Cancel",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: closeButtonColor ?? Colors.white,
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
        ? DateRangeResult(startDate: startDate!, endDate: endDate!)
        : null;
  }
}

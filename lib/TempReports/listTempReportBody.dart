import '../CommonWidgets/deleteDialog.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../Models/reportData.dart';
import '../Storage/files.dart';
import '../Storage/localStorage.dart';
import '../TempReports/listTempReportCard.dart';
import 'package:flutter/material.dart';

class ListTempReportBody extends StatefulWidget {
  ListTempReportBody();

  @override
  _ListTempReportBodyState createState() => _ListTempReportBodyState();
}

class _ListTempReportBodyState extends State<ListTempReportBody> {
  Future<List<ReportData>> data;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    data = getData();
    super.initState();
  }

  refreshData() {
    setState(() {
      data = getData();
    });
  }

  Future<List<ReportData>> getData() async {
    LocalStorage localStorage = new LocalStorage(FileName().report);
    return await localStorage.readReports();
  }

  Future<List<ReportData>> deleteReport(int index) async {
    LocalStorage localStorage = new LocalStorage(FileName().report);
    return await localStorage.deleteReport(index);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return LoadingScreen();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else {
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: () async {
                    refreshData();
                  },
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: ValueKey(snapshot.data[index].id),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {},
                            confirmDismiss: (direction) async {
                              final result = await showDialog(
                                      context: context,
                                      builder: (_) => DeleteDialog()) ??
                                  false;
                              if (result) {
                                setState(() {
                                  data = deleteReport(index);
                                });
                              }
                              return result;
                            },
                            background: Container(
                              color: Colors.blue,
                              padding: EdgeInsets.only(left: 16),
                              child: Align(
                                child: Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            child: ListTempReportCard(snapshot.data[index]));
                      }),
                );
              }
          }
        });
  }
}

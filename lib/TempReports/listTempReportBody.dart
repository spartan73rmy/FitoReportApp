import '../CommonWidgets/deleteDialog.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../Models/reportData.dart';
import '../Storage/files.dart';
import '../Storage/localStorage.dart';
import '../TempReports/listTempReportCard.dart';
import 'package:flutter/material.dart';

class ListTempReportBody extends StatefulWidget {
  const ListTempReportBody({super.key});

  @override
  _ListTempReportBodyState createState() => _ListTempReportBodyState();
}

class _ListTempReportBodyState extends State<ListTempReportBody> {
  late Future<List<ReportData>> data;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
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
    LocalStorage localStorage = LocalStorage(FileName().report);
    return await localStorage.readReports();
  }

  Future<List<ReportData>> deleteReport(int index) async {
    LocalStorage localStorage = LocalStorage(FileName().report);
    return await localStorage.deleteReport(index);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data,
        builder: (context, AsyncSnapshot<List<ReportData>> snapshot) {
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
                      itemCount: snapshot.data?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: ValueKey(snapshot.data?[index].id),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {},
                            confirmDismiss: (direction) async {
                              final result = await showDialog(
                                      context: context,
                                      builder: (_) => const DeleteDialog()) ??
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
                              padding: const EdgeInsets.only(left: 16),
                              child: const Align(
                                child: Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            child: ListTempReportCard(snapshot.data![index]));
                      }),
                );
              }
          }
        });
  }
}

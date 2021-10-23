import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:http/http.dart' as http;

class GuessPage extends StatefulWidget {
  const GuessPage({Key? key}) : super(key: key);

  @override
  _GuessPageState createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  var year = 0.0;
  var month = 0.0;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GUESS TEACHER AGE"),
        ),
        body: Stack(
          children: [
        Container(
        color: Colors.yellow[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Text("อายุอาจารย์")),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Wrap(alignment: WrapAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            Text("ปี"),
                            SpinBox(
                              min: 1,
                              max: 80,
                              value: year,
                              onChanged: (value) =>
                                  setState(() {
                                    year++;
                                  }),
                            )
                            , Text("เดือน")
                            ,
                            SpinBox(
                              min: 0,
                              max: 12,
                              value: month,
                              onChanged: (value) =>
                                  setState(() {
                                    month++;
                                  }),
                            ),
                            ElevatedButton(onPressed: () {
                              setState(() {
                                Map<String,dynamic> map = {"year":year.toInt(),"month":month.toInt()};
                                print(map);
                                 submit(map);

                                // _showMaterialDialog(
                                //     "ผลการทาย", '$year ปี $month เดือน');
                              });
                            }, child: Text("ทาย"))
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
    Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ))
      ],
    ),);
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> submit(
      Map<String, dynamic> params,) async {
    var url = Uri.parse(
        'https://cpsu-test-api.herokuapp.com/guess_teacher_age');
    setState(() {
      _isLoading =true;
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(params),
    );
    Map map = json.decode(response.body);
    print(map);
    var ans =map['data']['text'];
    _showMaterialDialog("ผลการทาย",ans);
    setState(() {
      _isLoading =false;
    });
  }


}

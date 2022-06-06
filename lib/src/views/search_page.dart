import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:patent_control_system/src/helpers/functions.dart';
import 'package:patent_control_system/src/models/patent.dart';
import 'package:patent_control_system/src/views/auth.dart';
import 'package:progress_indicators/progress_indicators.dart';

String searchString = "";
bool loading = false;
List<Patent> patents = [];

class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {
  late Future<Patent> futurePatent;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPatents("");
  }

  getPatents(String search) async {
    String searchtext = "";
    if (search != "") {
      searchtext =
          "https://api.patentsview.org/patents/query?q={\"_text_any\":{\"patent_title\":\"" +
              search +
              "\"}}&f=[\"patent_number\",\"patent_title\"]&o={\"per_page\": 1000}";
    } else {
      searchtext =
          "https://api.patentsview.org/patents/query?q={\"_gte\":{\"patent_date\":\"2007-01-04\"}}&f=[\"patent_number\",\"patent_title\"]&o={\"per_page\": 1000}";
    }

    final response = await http.get(Uri.parse(searchtext));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      dynamic responseData = convert.jsonDecode(response.body);
      patents.clear();
      if (responseData["count"] != 0) {
        for (var singleUser in responseData["patents"]) {
          var patent = Patent.fromJson(singleUser);

          //Adding user to the list.
          patents.add(patent);
        }
      }
      if (mounted)
        setState(() {
          loading = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: HexColor("F9F7F7"), body: returnBody());
  }

  returnBody() {
    if (loading) {
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20, top: 10, left: 8),
            color: HexColor("F9F7F7"),
            child: TextField(
              onChanged: (value) {
                getPatents(value.toLowerCase());
              },
              controller: _textController,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  hintText: 'Ara...',
                  hintStyle: TextStyle(color: Colors.black54)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: patents.length,
              itemBuilder: (ctx, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: HexColor("112D4E").withOpacity(0.65),
                      child: ListTile(
                        title: Text(
                          "Patent Numarası: " + patents[index].patent_number,
                          style: GoogleFonts.lora(
                              textStyle: TextStyle(
                                  color: Color.fromARGB(233, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)),
                        ),
                        subtitle: Text(
                          "Patent Başlığı: " + patents[index].patent_title,
                          style: GoogleFonts.lora(
                              textStyle: TextStyle(
                                  color: Color.fromARGB(233, 255, 255, 255),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16)),
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            backgroundColor: HexColor("3F72AF"),
            body: Center(
                child: JumpingDotsProgressIndicator(
              color: Colors.white,
              fontSize: 80,
            )),
          ),
        ),
      );
    }
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('WOP'),
          backgroundColor: HexColor("3F72AF"),
        ),
        body: Center(child: ListSearch()));
  }
}

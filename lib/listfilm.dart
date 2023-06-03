import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'grid.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  String? movie;
  bool _movieIsempty = true;
  double maxValue = 0;
  double offset = 0;
  bool max = true;

  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();
  ScrollController _controller3 = ScrollController();
  ScrollController _controller4 = ScrollController();

  Future<Map> _getMovies() async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://www.omdbapi.com/?apikey=46539e83&s=${movie}'));

    return json.decode(response.body);
  }

  @override
  void initState() {
    _controller2.addListener(() {
      maxValue = _controller2.position.maxScrollExtent;

    });

    offset = maxValue;

    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (max) {
        offset--;
        if (offset < 3) max = false;
      }
      else {
        offset++;
        if (offset >= maxValue) max = true;
      }
      _controller1.jumpTo(offset);
      _controller2.jumpTo(maxValue - offset);
      _controller3.jumpTo(offset);
      _controller4.jumpTo(maxValue - offset);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp ]);

    return Scaffold(
      appBar: AppBar(
          title: Text('Search Film'),
          automaticallyImplyLeading: false,
          flexibleSpace: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                      ),
                      Text('LOGOUT'),
                    ],
                  ),
                ],
              ),
              ),
          ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [

                  TextField(
                    onSubmitted: (text) => setState(() {
                      movie = text;
                      _movieIsempty = movie == null || movie == '';
                    }),
                    style: TextStyle(color: Colors.pink),
                    decoration: InputDecoration(
                        labelText: 'Search',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.pink,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.pink,
                          ),
                        ),

                        labelStyle: TextStyle(
                          color: Colors.black,
                        )),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            if(!_movieIsempty )Expanded(child: GridMovies(movie!,_getMovies())),
          ],
        ),
      ),
    );
  }

}
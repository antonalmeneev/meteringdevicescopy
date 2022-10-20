import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';
import 'dart:io';
// import 'package:requests/requests.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: TestHttp()));

class TestHttp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestHttpState();
}

class TestHttpState extends State<TestHttp> {
  var platform = MethodChannel('app.channel.shared.data');

  bool StateRes = false;
  var Req1 = "";
  var Req1_1 = "";
  var Req2 = "";
  var Req2_1 = "";

  @override
  initState() {
    super.initState();

    // str = 'Yes';
    // b = false;
  }

  httpGet() async {
    var sharedData = await platform.invokeMethod('getSharedText');

    // if (Req1.length > 0) {
    //
    //   this.Req1 = "0" +Req1;
    //
    // }else {


    // {
    //   "username": "sony4rever@gmail.com",
    // "email": "sony4rever@gmail.com",
    // "password": "TRNdsg124%"
    // }
    //
    // POST на waterius.ru/dj-rest-auth/login/
    //
    // Content-Type: application/json
    //
    // вы получите json
    // {
    // "key": "328f617095411f50d0815f234aee3be2b2e6fdec"
    // }
    //
    // где key - это токет по какому вы сможете делать вызовы
    // {
    // "key": "328f617095411f50d0815f234aee3be2b2e6fdec"
    // }

    try {
      //HTML = "https://waterius.ru/api/user/login?hash=50984047353244484035046568136658&email=sony4rever%40gmail.com";
      // /api/channel/

      // var response = await Dio().get('https://waterius.ru/api/user/login?hash=50984047353244484035046568136658&email=sony4rever%40gmail.com',
      // var response = await http.put('https://waterius.ru/api/user/login?hash=50984047353244484035046568136658&email=sony4rever%40gmail.com');//,
      //                     // headers: {'cookie': 'session_id=ufe1nfq69mdi67pnql6n1cs3cv; path=/; HttpOnly='});  // метод гет
      // var cookies = response.headers['set-cookie'];
      //
      // var response_redirect = await http.put('https://waterius.ru'+response.headers['location']);
      //
      // var cookies1 = response_redirect.headers['set-cookie'];

      String url2 = "";

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (sharedData == "null") {
        // url2= "https://waterius.ru/api/user/login?hash=50984047353244484035046568136658&email=sony4rever%40gmail.com";
        //
        //


        url2= prefs.getString('sharedData');

        if (url2== null){
          url2 = "https://waterius.ru/account";
        }

        //реализовать механизм сохранения во временный файл
      } else {
        url2 = sharedData;

        // int counter = (prefs.getInt('counter') ?? 0) + 1;
        // print('Pressed $counter times.');
        await prefs.setString('sharedData', sharedData);
      }

      String url3 = "https://ya.ru";
      String url1 = "https://waterius.ru/account";
      String url4 = "https://waterius.ru/api/info/";
      String url5 = "https://waterius.ru/api/info/?json";

      // var d =  await http.put(url2,headers: {"Content-Type": "application/json"});

      // await http.

      http.Client client = http.Client();
      http.Response response = await client.post(url2);

      // print(response.body);

      // print(response.statusCode);
      // print(response.isRedirect);
      if (response.statusCode == 301) {
        var url_1 = "https://waterius.ru" + response.headers['location'];
        var s = client.get(url_1);
      }
      if (response.statusCode == 302) {
        var url_2 = response.headers['location'];
        client.get(url_2);
      }
      // print(response.body);

      http.Request req = http.Request("Get", Uri.parse(url2))
        ..followRedirects = false;

      http.Client baseClient = http.Client();
      http.StreamedResponse response1 = await baseClient.send(req);
      Uri redirectUri = Uri.parse(response1.headers['location']);

      http.Request req1 = http.Request(
          "Get", Uri.parse("https://waterius.ru" + redirectUri.toString()))
        ..followRedirects = false;

      http.Client baseClient1 = http.Client();
      http.StreamedResponse response11 = await baseClient1.send(req1);
      Uri redirectUri11 = Uri.parse(response11.headers['location']);

      var res_ = response11.headers['set-cookie'].toString();

      var s = res_.split(";");

      // for (var n in s ){
      for (int i = 0; i < s.length; i++) {
        var res = s[i].split(",");
        if (res.length > 1) {
          for (var n1 in res) {
            s.add(n1.toString());
          }
          s.removeAt(i);
        }
      }

      String Cookie = "";

      Map<String, String> m = Map();

      for (int i = 0; i < s.length; i++) {
        var res = s[i].split("=");
        if (res.length > 1) {
          if (res[0].toString() == 'sessionid') {
            Cookie = Cookie + ";" + res[0] + "=" + res[1] + ";";
            // m[res[0]]=res[1];
          }

          if (res[0].toString() == 'csrftoken') {
            Cookie = Cookie + ";" + res[0] + "=" + res[1] + ";";
            // m[res[0]]=res[1];
          }
        }
      }

      m["Cookie"] = Cookie;
      // m["Content-Type"] ="application/json";
      m["Content-Type"] = "application/json; charset=utf-8";
      // "application/json; charset=utf-8"
      m["Accept-Language"] = "ru";
      m["Accept-Charset"] = "utf-8";
      m["Content-Language"] = "ru";
      m["Content-Charset"] = "utf-8";
      // m["Content-Type"] = "application/x-www-form-urlencoded";

      // var d =  await http.get(url4,headers: {"Content-Type": "application/json"});

      var d = await http.get(url4, headers: m);

      var d1 = await http.get(url5, headers: m);

      // var d1 =  await http.head('https://waterius.ru'+d.headers['location'],headers: {"Content-Type": "application/json"});

      // Future<HttpClientResponse> foo() async {
      //   Map<String, dynamic> jsonMap = {
      //     'homeTeam': {'team': 'Team A'},
      //     'awayTeam': {'team': 'Team B'},
      //   };
      //
      //   Response r = await post(
      //
      // var r = await Requests.get(url2,headers: {"Content-Type": "application/json"});
      // r.raiseForStatus();
      // String body = r.content();
      //
      // String hostname = Requests.getHostname(url2);
      // // await Requests.clearStoredCookies(hostname);
      // // await Requests.setStoredCookies(hostname, {'session': 'bla'});
      //  var cookies = await Requests.getStoredCookies(hostname);
      // String da = 'd';
      // // expect(cookies.keys.length, 1);
      // await Requests.clearStoredCookies(hostname);
      // cookies = await Requests.getStoredCookies(hostname);
      // expect(cookies.keys.length, 0);

      // var dio = Dio();
      // var cookieJar=CookieJar();
      // dio.interceptors.add(CookieManager(cookieJar));
      // await dio.get(url2);
      // // Print cookies
      // print(await cookieJar.loadForRequest(Uri.parse(url2)));
      // // second request with the cookie
      // await dio.get(url2);

      // var response = await http.get('https://waterius.ru/api/user/login?hash=50984047353244484035046568136658&email=sony4rever%40gmail.com');  // метод гет
      // var response = await http.put('https://waterius.ru/api/user/login?hash=50984047353244484035046568136658&email=sony4rever@gmail.com');  // метод гет

      // String t = response.headers['location'].toString();

      // var response_1 = await http.get('https://waterius.ru'+t);
      // var response_1 = await Dio().put('https://waterius.ru'+t);

      //  var response_1 = await http.put("https://waterius.ru");
      // var response_1 = await http.put(response);

      // String rawCookie1 =  response.request.toString();

      // String rawCookie  =response.headers['set-cookie'];

      // var response = await http.post('https://waterius.ru/',
      //     body: {'name': 'my name', 'num': '10'},
      //     headers: {'Accept': 'application/json'}); // метод пост

      StateRes = true;

      // var sdreq1 = d.body.toString();

      var convertDataToJson = json.decode(d1.body);
      var trd = convertDataToJson[0];
      var ColdWaters = trd["channels"][0]["value"];
      var ColdWatersType = trd["channels"][0]["type"];
      var HotWaters = trd["channels"][1]["value"];
      var HotWatersType = trd["channels"][0]["type"];

      Req1 = ColdWaters.toString();
      Req1_1 = ColdWatersType.toString();

      Req2 = HotWaters.toString();
      Req2_1 = HotWatersType.toString();

      // Req1 = d.body.toString();

      // print("Response status: ${response.statusCode}");
      // print("Response status: ${response_1.statusCode}");
      // print("Response body: ${response.body}");
    } catch (error) {
      print("Error: $error");

      Req1 = "Данные не получены ГВС";
      Req2 = "Данные не получены ХВС";


    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Приборы учета'),
      ),
      body: GestureDetector(
          child: Container(
            // padding: EdgeInsets.only(top:5, left:2, right:10),
            // color: Colors.white,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Expanded(
                  child: Text("Холодная вода" + "\n" + Req2,
                      style: TextStyle(
                        color: Colors.blue.shade900, // зеленый цвет текста
                        fontSize: 40, // высота шрифта 26
                        // backgroundColor: Colors.amber     // черный цвет фона текста
                      )),
                ),
                Expanded(
                  child: Text("Горячая вода" + "\n" + Req1,
                      style: TextStyle(
                        color: Colors.red.shade900, // зеленый цвет текста
                        fontSize: 40, // высота шрифта 26
                        // backgroundColor: Colors.amber     // черный цвет фона текста
                      )),
                ),

                //   Expanded(
                //   child:FlatButton(
                //  onPressed:httpGet,
                // //     (){
                // //   httpGet;
                // //   // answer = myController.text;
                // //   // isCorrect = (answer == answers.elementAt(element));
                // //   // isCorrect == true ? AnswerMessage = "Correct!" : answerMessage = "Sorry, that answer was incorrect.";
                // //   Future.delayed(const Duration(milliseconds: 50000), () {
                // //     setState(() {
                // //       // Req1 = this.Req1;
                // //       // word = questions.elementAt(element);
                // //     });
                // //   });
                // // },
                //   child: Text("Отправить")),
                // // child: Text("Отправить " + (StateRes ? this.Req1:"нет"))),
                // )
              ],
            ),
          ),
          // onTap: () =>httpGet()// updateText("onTap"), // нажмите
          onTap: () => updateText() // updateText("onTap"), // нажмите
          ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       setState(() {
      //        httpGet();
      //        Req1 = Req1 +"";
      //       });
      //     },
      //     tooltip: 'Increment',
      //     child: Icon(Icons.add),
      //   ),
    );
  }

  void updateText() {
    setState(() {
      // _operation = text;
      httpGet();
      Req1 = Req1 + "";
    });
    // подсказка
    // showSnackBar(text);
  }
}

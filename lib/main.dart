import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double aMount = 0;
  var checkNull;
  bool isCheck = false;
  double bill = 0;
  TextEditingController? textController;
  TextEditingController? numberController;
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();
  int toTal = 0;
  int vipToTal = 0;
  double toTalInCome = 0;


  @override
  void initState() {
    super.initState();
    _loadData();
    textController = TextEditingController();
    numberController = TextEditingController();
  }

  void _loadData() async {
    final daTa = await SharedPreferences.getInstance();
    setState(() {
      toTal = daTa.getInt('total') ?? 0;
      vipToTal = daTa.getInt('viptotal') ?? 0;
      toTalInCome = daTa.getDouble('totalincome') ?? 0;
    });
  }

  Widget tiTle(String tiTle) {
    return Container(
      color: Colors.green,
      child: Row(
        children: <Widget>[
          Text(tiTle),
        ],
      ),
    );
  }

  Widget inPutName() {
    return Container(
      child: Row(
        children: <Widget> [
          Expanded(
            child: Text("Tên Khách Hàng: ")
          ),
          Expanded(
              child: TextField(
                maxLines: 1,
                focusNode: nodeOne,
                decoration: new InputDecoration(hintText: "Nhập tên khách hàng"),
                controller: textController,
                onSubmitted: (value) {
                    checkNull = value;
                    FocusScope.of(context).requestFocus(nodeTwo);
                }
              )
          )
        ],
      )
    );
  }

  Widget inPutAmount() {
    return Container(
      child: Row(
        children: <Widget> [
          Expanded(
            child: Text("Số lượng sách: ")
          ),
          Expanded(
              child: TextField(
                  maxLines: 1,
                  focusNode: nodeTwo,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(hintText: "Nhập số lượng sách"),
                  controller: numberController,
                  onSubmitted: (value) {
                      aMount = double.parse(value);
                  }
              )
          )
        ],
      )
    );
  }

  Widget checkBox() {
    return Container(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Checkbox(
            activeColor: Colors.red,
              value: isCheck,
              onChanged: (value) {
                setState(() {
                  isCheck = value!;
                });
              }
          ),
          Text("Khách hàng Vip")
        ],
      )
    );
  }

  Widget billOutput () {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(child: Text("Thành Tiền: ")),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Text(bill.toString(), textAlign: TextAlign.center)
            )
          )
        ],
      ),
    );
  }

  Widget funcButton () {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(12),
            child: FlatButton(
              color: Colors.grey,
              child: Text("TÍNH TT", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              onPressed: () {
                setState (() {
                  _calCuLaTing();
                });
              }
            )
          ),
          Container(
              margin: EdgeInsets.all(12),
              child: FlatButton(
                color: Colors.grey,
                child: Text("TIẾP", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                onPressed: () {
                  setState(() {
                    _conTiNue();
                  });
                },
              )
          ),
          Container(
              margin: EdgeInsets.all(12),
              child: FlatButton(
                color: Colors.grey,
                child: Text("THỐNG KÊ", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                onPressed: () {
                  _showDialog();
                }
              )
          )
        ]
      )
    );
  }

  void _calCuLaTing() {
    if (isCheck == true)
      bill = 20000 * aMount * 90 / 100;
    else
      bill = 20000 * aMount;
  }

  void _conTiNue() async {
    final daTa = await SharedPreferences.getInstance();
    setState(() {
      if (checkNull != null) {
        toTal = (daTa.getInt('total') ?? 0) + 1;
        if (isCheck == true)
          vipToTal = (daTa.getInt('viptotal') ?? 0) + 1;
      }
      toTalInCome =  (daTa.getDouble('totalincome') ?? 0) + bill;
      daTa.setInt('total', toTal);
      daTa.setInt('viptotal', vipToTal);
      daTa.setDouble('totalincome', toTalInCome);
    });
    FocusScope.of(context).requestFocus(nodeOne);
    textController?.clear();
    numberController?.clear();
    isCheck = false;
    bill = 0;
    checkNull = null;
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('THỐNG KÊ'),
            content: Text('Tổng doanh thu: ' + toTalInCome.toString()),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Widget show(String type, String reSult) {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        children: <Widget> [
          Expanded(child: Text(type + ": ")),
          Expanded(child: Text(reSult))
        ],
      ),
    );
  }


  Widget eXit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget> [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            _showAlertDialog();
          }
        )
      ],
    );
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Icon(Icons.exit_to_app),
            content: Text('Bạn có chắc chắn muốn thoát hay không?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Không')),
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text('Có')),
            ],
          );
        });
  }

  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          title: Text("Chương trình bán sách Online"),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: <Widget> [
                tiTle("Thông tin hóa đơn"),
                inPutName(),
                inPutAmount(),
                checkBox(),
                billOutput(),
                funcButton(),
                tiTle("Thông tin thống kê"),
                show("Tổng số KH: ", toTal.toString()),
                show("Tổng số KH là VIP: ", vipToTal.toString()),
                show("Tổng doanh thu: ", toTalInCome.toString()),
                tiTle(""),
                eXit()
              ]
            )
          )
        )
      )
    );
  }
}

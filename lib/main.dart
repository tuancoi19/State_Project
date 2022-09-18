import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:provider/provider.dart';
import 'package:state/model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Data()),
          ChangeNotifierProvider(create: (_) => Bill())
        ],
        child: const MaterialApp(
            debugShowCheckedModeBanner: false, home: HomeScreen()));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<Data>().loadData();
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
    return Row(
      children: <Widget>[
        const Expanded(child: Text("Tên Khách Hàng: ")),
        Expanded(
            child: TextField(
                maxLines: 1,
                focusNode: nodeOne,
                decoration:
                    const InputDecoration(hintText: "Nhập tên khách hàng"),
                controller: context.watch<Bill>().name,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<Bill>().checkNull = value;
                    FocusScope.of(context).requestFocus(nodeTwo);
                  }
                }))
      ],
    );
  }

  Widget inPutAmount() {
    return Row(
      children: <Widget>[
        const Expanded(child: Text("Số lượng sách: ")),
        Expanded(
            child: TextField(
                maxLines: 1,
                focusNode: nodeTwo,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: "Nhập số lượng sách"),
                controller: context.watch<Bill>().number,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<Bill>().aMount = double.parse(value);
                  }
                }))
      ],
    );
  }

  Widget checkBox() {
    return SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Consumer<Bill>(builder: (context, bill, child) {
              return Checkbox(
                  activeColor: Colors.red,
                  value: bill.isCheck,
                  onChanged: (value) {
                    bill.check = value!;
                  });
            }),
            const Text("Khách hàng Vip")
          ],
        ));
  }

  Widget billOutput() {
    return Row(
      children: <Widget>[
        const Expanded(child: Text("Thành Tiền: ")),
        Expanded(
            child: Container(
                color: Colors.grey,
                child: Text(context.watch<Bill>().bill.toInt().toString(),
                    textAlign: TextAlign.center)))
      ],
    );
  }

  Widget funcButton() {
    return Row(children: <Widget>[
      const SizedBox(width: 6),
      Expanded(
          flex: 1,
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
              child: const Text("TÍNH TT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              onPressed: () {
                context.read<Bill>().calCuLaTing();
              })),
      const SizedBox(width: 12),
      Expanded(
          flex: 1,
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black)),
            child: const Text("TIẾP",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            onPressed: () {
              context.read<Bill>().conTiNue();
              context.read<Data>().loadData();
              FocusScope.of(context).requestFocus(nodeOne);
            },
          )),
      const SizedBox(width: 12),
      Expanded(
          flex: 1,
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
              child: const Text("THỐNG KÊ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              onPressed: () {
                _showDialog();
              })),
      const SizedBox(width: 6),
    ]);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('THỐNG KÊ'),
            content: Text(
                'Tổng doanh thu: ${context.watch<Data>().toTalInCome.toInt()}'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }

  Widget show(String type, String reSult) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        children: <Widget>[
          Expanded(child: Text("$type: ")),
          Expanded(child: Text(reSult))
        ],
      ),
    );
  }

  Widget eXit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _showAlertDialog();
            })
      ],
    );
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(Icons.exit_to_app),
            content: const Text('Bạn có chắc chắn muốn thoát hay không?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Không')),
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Có')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.green,
              title: const Text("Chương trình bán sách Online"),
            ),
            body: Center(child: Consumer<Data>(builder: (context, data, child) {
              return Column(children: <Widget>[
                tiTle("Thông tin hóa đơn"),
                inPutName(),
                inPutAmount(),
                checkBox(),
                billOutput(),
                funcButton(),
                tiTle("Thông tin thống kê"),
                show("Tổng số KH", data.toTal.toString()),
                show("Tổng số KH là VIP", data.vipToTal.toString()),
                show("Tổng doanh thu", data.toTalInCome.toInt().toString()),
                tiTle(""),
                eXit()
              ]);
            }))));
  }
}

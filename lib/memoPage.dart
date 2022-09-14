import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoAdd.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  State<MemoPage> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://memoapp-6f80e-default-rtdb.firebaseio.com/';
  List<Memo> memos = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child('memo');

    reference!.onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(Memo.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모앱 '),
      ),
      body: Container(
        child: Center(
          child: memos.length == 0
          ? CircularProgressIndicator()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Card(
                  child: GridTile(
                    child: Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: SizedBox(
                        child: GestureDetector(
                          onTap: () {
                            //여기에 메모 상세보기 화면으로 이동 추가 예정
                          },
                          onLongPress: (){
                            //여기에 길게 클릭 시 메모 삭체 기능 추가 예정
                          },
                          child: Text(memos[index].content),
                        ),
                      ),
                    ),
                    header: Text(memos[index].title),
                    footer: Text(memos[index].createTime.substring(0,10)),
                  ),
                );
              },
              itemCount: memos.length,),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MemoAddPage(reference!))
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


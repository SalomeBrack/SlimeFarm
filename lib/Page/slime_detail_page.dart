import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slime_farm/Database/slimes_database.dart';
import 'package:slime_farm/Model/slime_model.dart';

class SlimeDetailPage extends StatefulWidget {
  final int slimeId;

  const SlimeDetailPage({
    Key? key,
    required this.slimeId,
  }) : super(key: key);

  @override
  _SlimeDetailPageState createState() => _SlimeDetailPageState();
}

class _SlimeDetailPageState extends State<SlimeDetailPage> {
  late Slime slime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshSlime();
  }

  Future refreshSlime() async {
    setState(() => isLoading = true);

    this.slime = await SlimesDatabase.instance.readSlime(widget.slimeId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: EdgeInsets.all(12),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: [
          Icon(
            Icons.android,
            color: getColor(slime.colorGeneA),
          ),
          SizedBox(height: 8),
          Text(
            DateFormat.yMMMd().format(slime.timestamp),
            style: TextStyle(color: Colors.white38),
          ),
          SizedBox(height: 8),
          Text('', style: TextStyle(color: Colors.white70, fontSize: 18)),
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;
        /*
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(slime: slime),
        ));
        */
        refreshSlime();
      }
  );

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await SlimesDatabase.instance.delete(widget.slimeId);

      Navigator.of(context).pop();
    },
  );

  Color getColor(int i) {
    switch (i) {
      case 0:
        return Colors.lightGreenAccent;
      case 1:
        return Colors.lightBlueAccent;
      case 2:
        return Colors.pinkAccent;
      default:
        return Colors.lightGreenAccent;
    }
  }
}

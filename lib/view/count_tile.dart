import 'package:flutter/material.dart';

import '../data/count_data.dart';
import '../view_model.dart';

class CountTile extends StatelessWidget {
  const CountTile({
    Key? key,
    required this.countData,
    required this.onDeletePressed,
  }) : super(key: key);

  final CountData countData;
  final OnDeletePressed onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${countData.dateTime}'),
      trailing: Text('${countData.count}'),
      tileColor: Colors.lightBlueAccent,
      leading: IconButton(
        onPressed: () => onDeletePressed(countData),
        icon: Icon(Icons.delete),
      ),
    );
  }
}

import 'package:streamprovider/data/count_data.dart';

class Model {
  int _count;

  int get count => _count;

  List<CountData> _list = [];

  List<CountData> get list => _list;

  Model(this._count);

  CountData add(DateTime currentTime) {
    _count++;

    CountData countData = CountData(
      count: _count,
      dateTime: currentTime,
    );

    _list.add(countData);
    return countData;
  }

  bool delete(CountData countData) {
    return _list.remove(countData);
  }
}

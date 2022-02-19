import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamprovider/repository/count_data_dao.dart';
import 'provider.dart';

import 'data/count_data.dart';
import 'model.dart';

typedef OnDeletePressed = void Function(CountData data);

class ViewModel {
  late WidgetRef _ref;

  Model model = Model(0);

  int get counter => _ref.watch(countProvider);
  List<CountData> get list => _ref.watch(listProvider);

  void setRef(WidgetRef ref) {
    this._ref = ref;
  }

  void incrementCounter(DateTime dateTime) {
    model.add(dateTime);

    _ref.read(countProvider.state).update((state) => model.count);
    _ref.read(listProvider.state).update((state) => model.list);
  }

  bool delete(CountData countData) {
    bool result = model.delete(countData);
    if (result) {
      _ref.read(listProvider.state).update((state) => model.list);
    }
    return result;
  }
}

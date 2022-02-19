import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/count_data.dart';

final countProvider = StateProvider<int>((ref) => 0);
final listProvider = StateProvider<List<CountData>>((ref) => []);

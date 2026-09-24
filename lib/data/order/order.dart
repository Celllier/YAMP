import 'dart:math';

import 'package:yamp/data/song.dart';

abstract class OrderStrategy {

  final String name;

  const OrderStrategy(this.name);

  int compare(Song a, Song b);
}



class OrderByNameAsc extends OrderStrategy {

  const OrderByNameAsc() : super('Order By Name - Asc');

  @override
  int compare(Song a, Song b) {
    return a.title.compareTo(b.title);
  }

}

class OrderByNameDesc extends OrderStrategy {

  const OrderByNameDesc() : super('Order By Name - Desc');

  @override
  int compare(Song a, Song b) {
    return b.title.compareTo(a.title);
  }
}




class OrderDurationAsc extends OrderStrategy {

  const OrderDurationAsc() : super('Order By Duration - Asc');

  @override
  int compare(Song a, Song b) {
    return a.durationSeconds.compareTo(b.durationSeconds);
  }

}

class OrderDurationDesc extends OrderStrategy {

  const OrderDurationDesc() : super('Order By Duration - Desc');

  @override
  int compare(Song a, Song b) {
    return b.durationSeconds.compareTo(a.durationSeconds);
  }

}


class OrderRandom extends OrderStrategy {

  const OrderRandom() : super('Random Order');

  @override
  int compare(Song a, Song b) {
    return Random().nextInt(10);
  }

}


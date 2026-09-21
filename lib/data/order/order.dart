import 'package:yamp/data/song.dart';

abstract class OrderStrategy {

  final String name;

  const OrderStrategy(this.name);

  void order(List<Song> songs);
}



class OrderByNameAsc extends OrderStrategy {

  const OrderByNameAsc() : super('Order By Name - Asc');

  @override
  void order(List<Song> songs) {
    songs.sort(
      (a, b) => a.title.compareTo(b.title)
    );
  }

}

class OrderByNameDesc extends OrderStrategy {

  const OrderByNameDesc() : super('Order By Name - Desc');

  @override
  void order(List<Song> songs) {
    songs.sort(
      (a, b) => b.title.compareTo(a.title)
    );
  }
}




class OrderDurationAsc extends OrderStrategy {

  const OrderDurationAsc() : super('Order By Duration - Asc');

  @override
  void order(List<Song> songs) {
    songs.sort(
      (a, b) => a.durationSeconds.compareTo(b.durationSeconds)
    );
  }

}

class OrderDurationDesc extends OrderStrategy {

  const OrderDurationDesc() : super('Order By Duration - Desc');

  @override
  void order(List<Song> songs) {
    songs.sort(
      (a, b) => b.durationSeconds.compareTo(a.durationSeconds)
    );
  }

}


class OrderRandom extends OrderStrategy {

  const OrderRandom() : super('Random Order');

  @override
  void order(List<Song> songs) {
    songs.shuffle();
  }

}


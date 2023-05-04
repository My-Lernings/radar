import 'package:shared_preferences/shared_preferences.dart';

class LastSyncLocationRepo{
  LastSyncLocationRepo({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;


static const LAST_SYNC_CONST = 'last_sync_location';


  Future<void> setLastSyncLocation(String lat,String long)async{
    sharedPreferences.setStringList(LAST_SYNC_CONST, [lat,long]);
  }

  Future<List<double>>getLastSyncLocation()async{
    List<double> res = [];

    if(sharedPreferences.containsKey(LAST_SYNC_CONST)) {
      final list = sharedPreferences.getStringList(LAST_SYNC_CONST);

      list?.forEach((element) {
        res.add(double.parse(element));
      });
    }
    return res;
  }

}
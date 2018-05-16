import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class FirebaseAgent {

  DatabaseReference _dbRef;

  Future<FirebaseApp> init() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'opensesame-5fcab',
      options: const FirebaseOptions(
        googleAppID: '1:886232296258:ios:f2bf712232ab23b1',
        gcmSenderID: '886232296258',
        databaseURL: 'https://opensesame-5fcab.firebaseio.com',
    ));
    return app;
  }

  void connect(path, isInSync) {
    _dbRef = FirebaseDatabase.instance.reference().child(path);
    _dbRef.keepSynced(isInSync);
  }

  StreamSubscription<Event> subscribeToValues(valueType) {
    if (_dbRef == null) {
      throw Error();
    } else {
      return _dbRef.onChildAdded.listen((Event event) {
        print("Got something plm");
        return event.snapshot.value[valueType] ?? '';
      }, onError: (Object o) {  
        final DatabaseError error = o;
        return error;
      });
    }
  }

  saveData(value, path) {
    if (path) {
      FirebaseDatabase.instance.reference().child(path).push().set({
        'sensor': value
      });
    } else {
      _dbRef.push().set({
        'sensor': value
      });
    }
  }
  
}
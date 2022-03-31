import 'package:simple_moment/simple_moment.dart';

class Todo {
  String details;
  late DateTime created;
  bool done = false;
  int id;

  Todo({this.details = '', DateTime? created, this.id = 0}) {
    created == null ? this.created = DateTime.now() : this.created = created;
  }

  String get parsedDate {
    return Moment.fromDateTime(created).format('hh:mm a MMMM dd, yyyy ');
  }

  updateDetails(String update) {
    details = update;
    created = DateTime.now();
  }

  toggleDone() {
    done = !done;
  }
}

import 'package:simple_moment/simple_moment.dart';

class Todo {
  late String details;
  late DateTime created;
  bool done = false;
  Todo({
    this.details = '',
    DateTime? created,
  }) {
    created == null ? this.created = DateTime.now() : this.created = created;
  }

  Todo.fromJson(Map<String, dynamic> json) {
    details = json['details'] ?? '';
    created = json['created'] ?? DateTime.now();
    done = json['done'] ?? false;
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

  Map<String, dynamic> get json => {
        'details': details,
        'created': created,
        'done': done,
      };

  Map<String, dynamic> toJson() {
    return json;
  }

  log() {
    print(json);
  }
}

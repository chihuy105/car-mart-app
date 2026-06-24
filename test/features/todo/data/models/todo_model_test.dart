import 'package:car_mart/features/todo/data/models/todo_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoModel', () {
    const json = {
      'userId': 1,
      'id': 1,
      'title': 'delectus aut autem',
      'completed': false,
    };

    test('fromJson parses title', () {
      final model = TodoModel.fromJson(json);
      expect(model.title, 'delectus aut autem');
      expect(model.id, 1);
      expect(model.completed, false);
    });

    test('toEntity maps fields and defaults nulls', () {
      const model = TodoModel(id: null, title: null, completed: null);
      final entity = model.toEntity();
      expect(entity.id, 0);
      expect(entity.title, '');
      expect(entity.completed, false);
    });
  });
}

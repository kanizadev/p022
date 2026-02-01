import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:p022/database/database_helper.dart';
import 'package:p022/models/user.dart';

void main() {
  setUpAll(() {
    // Initialize FFI for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // Ensure test binding is initialized to avoid window assertion errors
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('users');
  });

  tearDownAll(() async {
    await DatabaseHelper.instance.close();
  });

  test('CRUD operations', () async {
    final db = DatabaseHelper.instance;

    final id = await db
        .createUser(User(name: 'Kaniza', email: 'kaniza@mail.com', age: 17));
    expect((await db.getUser(id))?.name, equals('Kaniza'));

    await db.updateUser(
        User(id: id, name: 'Tanjia', email: 'tanjia@mail.com', age: 17));
    expect((await db.getUser(id))?.name, equals('Tanjia'));

    expect((await db.getAllUsers()).length, equals(1));

    await db.deleteUser(id);
    expect(await db.getUser(id), isNull);
  });
}

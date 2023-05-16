import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matchify/authentication/auth.dart';
import '../mock.dart';


class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}
class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
          Invocation.method(#signInWithEmailAndPassword, [email, password]),
          returnValue: Future.value(MockUserCredential()));
}

class MockDatabaseReference extends Mock implements DatabaseReference {}
class MockUser extends Mock implements User {}
void main() {
  group('Auth tests', () {
    late Auth auth;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockDatabaseReference mockDatabaseReference;
    late MockFirebaseDatabase mockFirebaseDatabase;
    setupFirebaseAuthMocks();
    setUp(() async {
      await Firebase.initializeApp();
      mockFirebaseAuth = MockFirebaseAuth();
      mockDatabaseReference = MockDatabaseReference();
      mockFirebaseDatabase = MockFirebaseDatabase();
      auth = Auth()
        ..firebaseAuth = mockFirebaseAuth
        ..firebaseDatabase=mockFirebaseDatabase;
    });

    test('sign in with email and password', () async {
      final email = 'test@example.com';
      final password = 'password';

      final mockUserCredential = MockUserCredential();
      when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password)).thenAnswer((_) => Future.value(mockUserCredential));

      await auth.signInWithEmailAndPassword(email: email, password: password);

      verify(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password));
    });
  });
}

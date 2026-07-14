import 'package:get/get.dart';
import '../services/supabase_service.dart';

class AuthRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  Future<bool> login(String email, String password) async {
    try {
      return await _supabase.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      return await _supabase.signUp(email, password, name);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await _supabase.logOut();
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _supabase.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  bool get isAuthenticated => _supabase.isAuthenticated.value;
}

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/environment.dart';

class SupabaseService extends GetxService {
  late SupabaseClient client;
  final Rxn<User> currentUser = Rxn<User>();
  final RxBool isAuthenticated = false.obs;
  bool _isMockMode = true;

  Future<SupabaseService> init() async {
    print('SupabaseService: Initializing...');
    try {
      // Check if already initialized by trying to access instance
      try {
        if (Supabase.instance.client != null) {
           print('SupabaseService: Already initialized.');
           client = Supabase.instance.client;
           _isMockMode = false;
           currentUser.value = client.auth.currentUser;
           isAuthenticated.value = client.auth.currentUser != null;
           return this;
        }
      } catch (_) {
        // Not initialized, continue
      }

      final url = Environment.supabaseUrl;
      final key = Environment.supabaseAnonKey;
      
      print('SupabaseService: URL: $url');
      print('SupabaseService: KEY (first 5): ${key.substring(0, 5)}...');
      
      bool isInvalidKey = !key.contains('.') || key.length < 20;
      
      if (url.contains('YOUR_SUPABASE') || url.contains('placeholder') || url.isEmpty || key.contains('placeholder') || isInvalidKey) {
        _isMockMode = true;
        if (isInvalidKey && !key.contains('placeholder')) {
          print('SupabaseService: Invalid key format detected (not a JWT). Falling back to mock mode.');
        } else {
          print('SupabaseService: Running in offline mock mode (placeholders or empty values detected).');
        }
      } else {
        print('SupabaseService: Connecting to real Supabase...');
        await Supabase.initialize(
          url: url,
          anonKey: key,
        ).timeout(const Duration(seconds: 8));
        
        client = Supabase.instance.client;
        _isMockMode = false;
        currentUser.value = client.auth.currentUser;
        isAuthenticated.value = client.auth.currentUser != null;

        // Listen to auth changes
        client.auth.onAuthStateChange.listen((data) {
          currentUser.value = data.session?.user;
          isAuthenticated.value = data.session?.user != null;
        });
        print('SupabaseService: Connected successfully.');
      }
    } catch (e) {
      _isMockMode = true;
      print('SupabaseService: Initialization failed ($e). Falling back to mock mode.');
    }
    return this;
  }

  // Mock mode helper
  bool get isMockMode => _isMockMode;

  Future<bool> login(String email, String password) async {
    print('SupabaseService: Attempting login for $email');
    if (isMockMode) {
      print('SupabaseService: Mock Login');
      await Future.delayed(const Duration(seconds: 1));
      isAuthenticated.value = true;
      return true;
    }
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('SupabaseService: Login response received. User: ${response.user?.id}');
      return response.user != null;
    } on AuthException catch (e) {
      print('SupabaseService: AuthException during login: ${e.message} (Status: ${e.statusCode})');
      rethrow;
    } catch (e) {
      print('SupabaseService: Unexpected error during login: $e');
      rethrow;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    print('SupabaseService: Attempting sign up for $email');
    if (isMockMode) {
      print('SupabaseService: Mock Sign Up');
      await Future.delayed(const Duration(seconds: 1));
      isAuthenticated.value = true;
      return true;
    }
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );
      print('SupabaseService: Sign up response received. User: ${response.user?.id}, Session: ${response.session != null}');
      
      if (response.user != null && response.session == null) {
        print('SupabaseService: Sign up successful but session is null. Email confirmation might be required.');
        return true;
      }

      if (response.user != null) {
        print('SupabaseService: Creating profile in database...');
        try {
          await client.from('profiles').upsert({
            'id': response.user!.id,
            'email': email,
            'full_name': name,
            'updated_at': DateTime.now().toIso8601String(),
          });
          print('SupabaseService: Profile created/updated successfully.');
        } catch (dbError) {
          print('SupabaseService: Profile database error: $dbError');
          // In some cases, we might want to rethrow or handle this
        }
        return true;
      }
      return false;
    } on AuthException catch (e) {
      print('SupabaseService: AuthException during sign up: ${e.message} (Status: ${e.statusCode})');
      rethrow;
    } catch (e) {
      print('SupabaseService: Unexpected error during sign up: $e');
      rethrow;
    }
  }

  Future<void> logOut() async {
    print('SupabaseService: Logging out...');
    if (isMockMode) {
      isAuthenticated.value = false;
      currentUser.value = null;
      return;
    }
    await client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    if (isMockMode) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    await client.auth.resetPasswordForEmail(email);
  }
}

import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class StorageService extends GetxService {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  SharedPreferences? _prefs;

  Future<StorageService> init() async {
    try {
      _prefs = await SharedPreferences.getInstance().timeout(const Duration(seconds: 5));
    } catch (e) {
      print('StorageService init error: $e');
    }
    return this;
  }

  // Local key-value storage
  bool? getBool(String key) => _prefs?.getBool(key);
  Future<bool> setBool(String key, bool value) async => await _prefs?.setBool(key, value) ?? false;
  String? getString(String key) => _prefs?.getString(key);
  Future<bool> setString(String key, String value) async => await _prefs?.setString(key, value) ?? false;
  int? getInt(String key) => _prefs?.getInt(key);
  Future<bool> setInt(String key, int value) async => await _prefs?.setInt(key, value) ?? false;

  Future<String> uploadProfileImage(File file, String userId) async {
    if (_supabase.isMockMode) {
      // Mock upload
      await Future.delayed(const Duration(seconds: 1));
      return 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=200&fit=crop';
    }

    try {
      final fileExtension = file.path.split('.').last;
      final path = '$userId/profile.$fileExtension';
      
      await _supabase.client.storage.from('avatars').upload(
        path,
        file,
        fileOptions: const FileOptions(upsert: true),
      );
      
      final publicUrl = _supabase.client.storage.from('avatars').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadBodyScanImage(File file, String userId, String scanId, String position) async {
    if (_supabase.isMockMode) {
      await Future.delayed(const Duration(seconds: 1));
      return 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd';
    }

    try {
      final fileExtension = file.path.split('.').last;
      final path = '$userId/scans/$scanId/$position.$fileExtension';

      await _supabase.client.storage.from('scans').upload(
        path,
        file,
        fileOptions: const FileOptions(upsert: true),
      );

      final publicUrl = _supabase.client.storage.from('scans').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }
}

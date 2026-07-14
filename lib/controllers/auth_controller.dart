import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';
import '../routes/app_routes.dart';
import '../services/supabase_service.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final resetEmailController = TextEditingController();

  // Form Keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();

  // State
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Login
  Future<void> login() async {
    print('AuthController: Login process started');
    if (!loginFormKey.currentState!.validate()) {
      print('AuthController: Login form validation failed');
      return;
    }
    isLoading.value = true;
    try {
      print('AuthController: Calling repository login');
      final success = await _authRepo.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      print('AuthController: Repository login result: $success');
      if (success) {
        _clearFields();
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.snackbar(
          'Login Failed',
          'Invalid email or password. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } on AuthException catch (e) {
      print('AuthController: AuthException: ${e.message}');
      Get.snackbar(
        'Authentication Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e, stack) {
      print('AuthController: Unexpected login error: $e');
      print(stack);
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register
  Future<void> register() async {
    print('AuthController: Registration process started');
    if (!registerFormKey.currentState!.validate()) {
      print('AuthController: Registration form validation failed');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      print('AuthController: Password mismatch');
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match. Please re-enter.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }
    isLoading.value = true;
    try {
      print('AuthController: Calling repository signUp');
      final success = await _authRepo.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );
      print('AuthController: Repository signUp result: $success');
      if (success) {
        final supabase = Get.find<SupabaseService>();
        if (supabase.client.auth.currentSession == null) {
          print('AuthController: Registration success, but session null (confirmation required)');
          Get.snackbar(
            'Success',
            'Account created! Please check your email to confirm your account before logging in.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 6),
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
          Get.offAllNamed(AppRoutes.login);
        } else {
          print('AuthController: Registration success, session found. Navigating to main');
          _clearFields();
          Get.offAllNamed(AppRoutes.main);
        }
      } else {
        print('AuthController: Registration failed (success=false)');
        Get.snackbar(
          'Sign Up Failed',
          'Unable to create account. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } on AuthException catch (e) {
      print('AuthController: AuthException during register: ${e.message}');
      Get.snackbar(
        'Registration Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e, stack) {
      print('AuthController: Unexpected registration error: $e');
      print(stack);
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password
  Future<void> forgotPassword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await _authRepo.forgotPassword(resetEmailController.text.trim());
      Get.snackbar(
        'Email Sent',
        'Check your inbox for a password reset link.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logOut() async {
    await _authRepo.logOut();
    _clearFields();
    Get.offAllNamed(AppRoutes.login);
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    resetEmailController.clear();
  }

  // Validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    resetEmailController.dispose();
    super.onClose();
  }
}

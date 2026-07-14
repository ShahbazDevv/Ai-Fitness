import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName => '.env';

  static String get supabaseUrl {
    return dotenv.env['SUPABASE_URL'] ?? 'https://placeholder.supabase.co';
  }

  static String get supabaseAnonKey {
    return dotenv.env['SUPABASE_ANON_KEY'] ?? 'placeholder-anon-key';
  }

  static String get hfApiKey {
    return dotenv.env['HF_API_KEY'] ?? '';
  }

  static String get hfModel {
    return dotenv.env['HF_MODEL'] ?? 'mistralai/Mistral-7B-Instruct-v0.3';
  }

  static String get hfBaseUrl {
    return dotenv.env['HF_BASE_URL'] ?? 'https://router.huggingface.co/hf/v1';
  }
}

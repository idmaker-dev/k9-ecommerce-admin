import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Map<String, dynamic> flattenRow(Map<String, dynamic> row) {
  final data = Map<String, dynamic>.from(row['data'] ?? {});
  data['id'] = row['id'];
  return data;
}

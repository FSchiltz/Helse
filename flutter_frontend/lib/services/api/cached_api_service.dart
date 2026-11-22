import 'package:helse/services/api/api_service.dart';
import 'package:helse/services/local/local_cache_service.dart';

abstract class CachedApiService extends ApiService {
  final LocalCacheService cache;

  CachedApiService(super.account) : cache = LocalCacheService(account);
}

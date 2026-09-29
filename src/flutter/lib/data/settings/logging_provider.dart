import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../logging_service.dart';

final loggingProvider = Provider<LoggingService>(
  (ref) => AppServices.loggingService,
);

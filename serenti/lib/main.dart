// This file is a proxy to allow Android Studio's "Generate Signed APK" 
// to find an entry point. By default, it points to production.
// For flavored builds, it's recommended to use the Flutter CLI:
// flutter build apk --flavor <flavor> -t lib/main_<flavor>.dart

import 'package:serenti/main_production.dart' as production;

void main() => production.main();

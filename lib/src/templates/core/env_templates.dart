/// Template for .env.example file
const String envExampleTemplate = r'''
# API Configuration
API_BASE_URL=__api_base_url__
API_TIMEOUT=30
API_KEY=your_api_key_here

# App Configuration
APP_NAME=__app_name__
ENVIRONMENT=development

# Feature Flags
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
ENABLE_LOGGING=true

# Third-Party Services (Optional)
# FIREBASE_API_KEY=
# SENTRY_DSN=
# GOOGLE_MAPS_API_KEY=
''';

/// Template for .env file (with actual values)
const String envTemplate = r'''
# API Configuration
API_BASE_URL=__api_base_url__
API_TIMEOUT=30
API_KEY=

# App Configuration
APP_NAME=__app_name__
ENVIRONMENT=development

# Feature Flags
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
ENABLE_LOGGING=true

# Third-Party Services (Optional)
# FIREBASE_API_KEY=
# SENTRY_DSN=
# GOOGLE_MAPS_API_KEY=
''';

/// Template for .env.dev file
const String envDevTemplate = r'''
# Development Environment
API_BASE_URL=__api_base_url__/dev
API_TIMEOUT=30
APP_NAME=__app_name__ (Dev)
ENVIRONMENT=development
ENABLE_LOGGING=true
''';

/// Template for .env.staging file
const String envStagingTemplate = r'''
# Staging Environment
API_BASE_URL=__api_base_url__/staging
API_TIMEOUT=30
APP_NAME=__app_name__ (Staging)
ENVIRONMENT=staging
ENABLE_ANALYTICS=true
ENABLE_LOGGING=true
''';

/// Template for .env.prod file
const String envProdTemplate = r'''
# Production Environment
API_BASE_URL=__api_base_url__
API_TIMEOUT=30
APP_NAME=__app_name__
ENVIRONMENT=production
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
ENABLE_LOGGING=false
''';

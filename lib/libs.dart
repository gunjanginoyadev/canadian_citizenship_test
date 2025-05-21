export 'package:flutter/material.dart';
export 'package:canadian_citizenship/app.dart';
export 'package:flutter_svg/svg.dart';
export 'package:flutter/services.dart';
export 'dart:convert';
export 'package:provider/provider.dart';
export 'package:xml/xml.dart';
export 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
export 'package:percent_indicator/circular_percent_indicator.dart';
export 'package:dots_indicator/dots_indicator.dart';
export 'package:canadian_citizenship/screens/main_screen.dart';

// constants
export 'core/constants/app_colors.dart';
export 'core/constants/text_style.dart';
export 'core/constants/app_theme.dart';
export 'core/constants/app_assets.dart';

// service
export 'package:canadian_citizenship/services/pref_service.dart';
export 'package:canadian_citizenship/services/tts_service.dart';

// extensions
export 'core/extensions/context_extensions.dart';

// models
export 'package:canadian_citizenship/model/lesson.dart';
export 'package:canadian_citizenship/model/glossary_model.dart';
export 'package:canadian_citizenship/model/mock_test.dart';

// helpers
export 'package:canadian_citizenship/core/helper/tts_helper.dart';

// screens
// onboarding screen
export 'screens/onboarding_screen/onboarding_screen.dart';

// home screen
export 'screens/home_screen/home_screen.dart';
export 'screens/home_screen/widget/home_screen_app_bar.dart';
export 'screens/home_screen/widget/continue_studying_card.dart';
export 'package:canadian_citizenship/provider/home_screen_provider.dart';

// lessons screen
export 'screens/lessons_screen/lessons_screen.dart';
// glossary screen
export 'screens/glossary_screen/glossary_screen.dart';
export 'screens/glossary_screen/widget/search_box.dart';
export 'package:canadian_citizenship/provider/glossary_provider.dart';

// mock test screen
export 'package:canadian_citizenship/screens/mock_test_screen/all_mock_test_screen.dart';
export 'package:canadian_citizenship/provider/mock_test_provider.dart';

// settings screen
export 'package:canadian_citizenship/screens/settings_screen/settings_screen.dart';

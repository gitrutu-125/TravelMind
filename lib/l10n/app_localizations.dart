import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('mr'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TravelMind'**
  String get appTitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseLanguage;

  /// No description provided for @selectLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for a personalized travel experience.'**
  String get selectLanguageDescription;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @helloTraveller.
  ///
  /// In en, this message translates to:
  /// **'Hello, Traveller! 👋'**
  String get helloTraveller;

  /// No description provided for @readyForAdventure.
  ///
  /// In en, this message translates to:
  /// **'Ready for your next adventure?'**
  String get readyForAdventure;

  /// No description provided for @whereToGo.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get whereToGo;

  /// No description provided for @searchDestinations.
  ///
  /// In en, this message translates to:
  /// **'Search Goa, Manali, Jaipur...'**
  String get searchDestinations;

  /// No description provided for @startPlanning.
  ///
  /// In en, this message translates to:
  /// **'Start Planning'**
  String get startPlanning;

  /// No description provided for @exploreTravelMind.
  ///
  /// In en, this message translates to:
  /// **'Explore TravelMind'**
  String get exploreTravelMind;

  /// No description provided for @popularDestinations.
  ///
  /// In en, this message translates to:
  /// **'Popular Destinations'**
  String get popularDestinations;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @languageChangeNote.
  ///
  /// In en, this message translates to:
  /// **'You can change your language later in settings.'**
  String get languageChangeNote;

  /// No description provided for @aiPoweredTravel.
  ///
  /// In en, this message translates to:
  /// **'AI POWERED TRAVEL'**
  String get aiPoweredTravel;

  /// No description provided for @planDreamTrip.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Dream Trip!'**
  String get planDreamTrip;

  /// No description provided for @discoverAmazingPlaces.
  ///
  /// In en, this message translates to:
  /// **'Discover amazing places and create your personalized travel itinerary.'**
  String get discoverAmazingPlaces;

  /// No description provided for @featuresCount.
  ///
  /// In en, this message translates to:
  /// **'6 Features'**
  String get featuresCount;

  /// No description provided for @noDestinationsFound.
  ///
  /// In en, this message translates to:
  /// **'No destinations found.'**
  String get noDestinationsFound;

  /// No description provided for @exploreDestination.
  ///
  /// In en, this message translates to:
  /// **'Explore destination'**
  String get exploreDestination;

  /// No description provided for @adventureCalling.
  ///
  /// In en, this message translates to:
  /// **'Adventure is calling!'**
  String get adventureCalling;

  /// No description provided for @exploreNewPlaces.
  ///
  /// In en, this message translates to:
  /// **'Explore new places and make memories.'**
  String get exploreNewPlaces;

  /// No description provided for @aiTripPlanner.
  ///
  /// In en, this message translates to:
  /// **'AI Trip Planner'**
  String get aiTripPlanner;

  /// No description provided for @moodPlanner.
  ///
  /// In en, this message translates to:
  /// **'Mood Planner'**
  String get moodPlanner;

  /// No description provided for @companionship.
  ///
  /// In en, this message translates to:
  /// **'Companionship'**
  String get companionship;

  /// No description provided for @packingAssistant.
  ///
  /// In en, this message translates to:
  /// **'Packing Assistant'**
  String get packingAssistant;

  /// No description provided for @destination360View.
  ///
  /// In en, this message translates to:
  /// **'360° View'**
  String get destination360View;

  /// No description provided for @trafficMap.
  ///
  /// In en, this message translates to:
  /// **'Traffic Map'**
  String get trafficMap;

  /// No description provided for @createPerfectTrip.
  ///
  /// In en, this message translates to:
  /// **'Create your perfect trip'**
  String get createPerfectTrip;

  /// No description provided for @travelWithYourMood.
  ///
  /// In en, this message translates to:
  /// **'Travel with your mood'**
  String get travelWithYourMood;

  /// No description provided for @findTravelBuddies.
  ///
  /// In en, this message translates to:
  /// **'Find travel buddies'**
  String get findTravelBuddies;

  /// No description provided for @packSmartlyWithAI.
  ///
  /// In en, this message translates to:
  /// **'Pack smartly with AI'**
  String get packSmartlyWithAI;

  /// No description provided for @explorePlacesVirtually.
  ///
  /// In en, this message translates to:
  /// **'Explore places virtually'**
  String get explorePlacesVirtually;

  /// No description provided for @discoverBetterRoutes.
  ///
  /// In en, this message translates to:
  /// **'Discover better routes'**
  String get discoverBetterRoutes;

  /// No description provided for @beachesAndAdventure.
  ///
  /// In en, this message translates to:
  /// **'Beaches & Adventure'**
  String get beachesAndAdventure;

  /// No description provided for @mountainsAndNature.
  ///
  /// In en, this message translates to:
  /// **'Mountains & Nature'**
  String get mountainsAndNature;

  /// No description provided for @cultureAndHeritage.
  ///
  /// In en, this message translates to:
  /// **'Culture & Heritage'**
  String get cultureAndHeritage;

  /// No description provided for @natureAndBackwaters.
  ///
  /// In en, this message translates to:
  /// **'Nature & Backwaters'**
  String get natureAndBackwaters;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature will be developed in the upcoming TravelMind development phase.'**
  String get featureComingSoon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'gu',
    'hi',
    'mr',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

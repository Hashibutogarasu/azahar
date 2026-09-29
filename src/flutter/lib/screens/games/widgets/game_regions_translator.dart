import '../../../i18n/translations.g.dart';

/// Translates [Game.regions] (a comma-separated list of English region names built natively,
/// e.g. "Japan, North America, Europe", or the special "Region free"/"Invalid region" strings)
/// into the app's current locale.
String translateGameRegions(Translations t, String regions) {
  if (regions == 'Region free') return t.games.regionFree;
  if (regions == 'Invalid region') return t.games.invalidRegion;

  return regions
      .split(', ')
      .map(
        (part) => switch (part) {
          'Japan' => t.games.regionJapan,
          'North America' => t.games.regionNorthAmerica,
          'Europe' => t.games.regionEurope,
          'Australia' => t.games.regionAustralia,
          'China' => t.games.regionChina,
          'Korea' => t.games.regionKorea,
          'Taiwan' => t.games.regionTaiwan,
          _ => part,
        },
      )
      .join(', ');
}

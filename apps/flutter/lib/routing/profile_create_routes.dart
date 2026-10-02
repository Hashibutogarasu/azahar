part of 'app_routes.dart';

/// The pages for adding a profile. They share [ProfileCreateShell] as their layout, apart from
/// the app's own shell, and each step is a page of its own.
@TypedShellRoute<ProfileCreateShellRoute>(
  routes: [
    TypedGoRoute<ProfileNameRoute>(path: '/profiles/new/name'),
    TypedGoRoute<ProfileUserDirectoryRoute>(
      path: '/profiles/new/user-directory',
    ),
    TypedGoRoute<ProfileGamesDirectoryRoute>(
      path: '/profiles/new/games-directory',
    ),
  ],
)
class ProfileCreateShellRoute extends ShellRouteData {
  const ProfileCreateShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return ProfileCreateShell(child: navigator);
  }
}

class ProfileNameRoute extends AppRouteData with $ProfileNameRoute {
  const ProfileNameRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileNamePage();
  }
}

class ProfileUserDirectoryRoute extends AppRouteData
    with $ProfileUserDirectoryRoute {
  const ProfileUserDirectoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileUserDirectoryPage();
  }
}

class ProfileGamesDirectoryRoute extends AppRouteData
    with $ProfileGamesDirectoryRoute {
  const ProfileGamesDirectoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileGamesDirectoryPage();
  }
}

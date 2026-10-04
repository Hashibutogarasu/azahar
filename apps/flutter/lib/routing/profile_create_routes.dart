part of 'app_routes.dart';

/// The pages for adding a profile. They share [ProfileCreateShell] as their layout, apart from
/// the app's own shell, and each step is a page of its own.
@TypedShellRoute<ProfileCreateShellRoute>(
  routes: [
    TypedGoRoute<ProfileNameRoute>(path: '/profiles/new/name'),
    TypedGoRoute<ProfileDirectoriesRoute>(path: '/profiles/new/directories'),
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

class ProfileDirectoriesRoute extends AppRouteData
    with $ProfileDirectoriesRoute {
  const ProfileDirectoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileDirectoriesPage();
  }
}

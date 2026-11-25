# helse

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Linux OAuth callback setup

For a directly distributed Linux build bundle, run
`register_oauth_handler.sh` from the bundle after extracting it. This registers
the `com.helse://` callback scheme for the current user. If the bundle is
elsewhere, pass its directory as an argument to the script.

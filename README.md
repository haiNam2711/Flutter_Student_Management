# test_dropdownbutton

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Center(
child: CupertinoButton(
child: const Text('Next page'),
onPressed: () {
Navigator.of(context).push(
CupertinoPageRoute<void>(
builder: (BuildContext context) {
return CupertinoPageScaffold(
navigationBar: CupertinoNavigationBar(
middle: Text('Page 2 of tab 1'),
),
child: Center(
child: CupertinoButton(
child: const Text('Back'),
onPressed: () {
Navigator.of(context).pop();
},
),
),
);
},
),
);
},
),
),
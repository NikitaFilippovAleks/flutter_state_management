
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
      ),
      home: HomePage(),
    );
  }
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;

  double get value => _value;

  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    super.key,
    required super.child,
    required SliderData sliderData
  }) : super(notifier: sliderData);

  static double of(BuildContext context) =>
    context
      .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
      ?.notifier
      ?.value ??
    0.0;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page'),),
      body: SliderInheritedNotifier(
        sliderData: sliderData,
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Slider(
                  value: SliderInheritedNotifier.of(context),
                  onChanged: (value) {
                    sliderData.value = value;
                  }
                ),
                Row(
                  children: [
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 100,
                        color: Colors.red,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 100,
                        color: Colors.blue,
                      ),
                    )
                  ].expandEqually().toList(),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}

extension ExpendEqually on Iterable<Widget> {
  Iterable<Widget> expandEqually() => map(
    (w) => Expanded(child: w)
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santo_ui/santo_ui.dart';

const Duration _duration = Duration(milliseconds: 200);

class _CollapseHost extends StatefulWidget {
  const _CollapseHost({
    this.mode = SantoCollapseMode.multiple,
    this.initialValue = const ['a'],
    this.secondDisabled = false,
    this.placement,
  });

  final SantoCollapseMode mode;
  final List<String> initialValue;
  final bool secondDisabled;
  final SantoCollapsePlacement? placement;

  @override
  State<_CollapseHost> createState() => _CollapseHostState();
}

class _CollapseHostState extends State<_CollapseHost> {
  late List<String> _value;
  List<String>? lastEmitted;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: SingleChildScrollView(
          child: SantoCollapse<String>(
            mode: widget.mode,
            animationDuration: _duration,
            value: _value,
            onChanged: (value) {
              lastEmitted = value;
              setState(() => _value = value);
            },
            children: [
              SantoCollapsePanel<String>(
                value: 'a',
                placement: widget.placement ?? SantoCollapsePlacement.bottom,
                headerBuilder: (context, isExpanded) => const Text('面板A'),
                body: const SizedBox(
                  height: 200,
                  child: Text('面板A内容'),
                ),
              ),
              SantoCollapsePanel<String>(
                value: 'b',
                disabled: widget.secondDisabled,
                headerBuilder: (context, isExpanded) => const Text('面板B'),
                body: const Text('面板B内容'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('expanding animates height gradually and never fades content',
      (tester) async {
    await tester.pumpWidget(const _CollapseHost(initialValue: []));
    await tester.pumpAndSettle();

    final collapsed = tester.getSize(find.byKey(const ValueKey<String>('a')));
    expect(collapsed.height, lessThan(60));

    await tester.tap(find.text('面板A'));
    await tester.pump();
    await tester.pump(_duration ~/ 2);

    expect(
      find.ancestor(
          of: find.text('面板A内容'), matching: find.byType(FadeTransition)),
      findsNothing,
    );

    final half = tester.getSize(find.byKey(const ValueKey<String>('a')));
    expect(half.height, greaterThan(collapsed.height));

    await tester.pumpAndSettle();
    final expanded = tester.getSize(find.byKey(const ValueKey<String>('a')));
    expect(expanded.height, greaterThan(half.height));
    expect(expanded.height - collapsed.height, greaterThan(200));
  });

  testWidgets('collapsing animates height gradually', (tester) async {
    await tester.pumpWidget(const _CollapseHost());
    await tester.pumpAndSettle();

    final expanded = tester.getSize(find.byKey(const ValueKey<String>('a')));

    await tester.tap(find.text('面板A'));
    await tester.pump();
    await tester.pump(_duration ~/ 2);

    final half = tester.getSize(find.byKey(const ValueKey<String>('a')));
    expect(half.height, lessThan(expanded.height));

    await tester.pumpAndSettle();
    final collapsed = tester.getSize(find.byKey(const ValueKey<String>('a')));
    expect(collapsed.height, lessThan(half.height));
  });

  testWidgets('initially expanded panel mounts at full height without animation',
      (tester) async {
    await tester.pumpWidget(const _CollapseHost());
    await tester.pump();

    final mounted = tester.getSize(find.byKey(const ValueKey<String>('a')));
    await tester.pumpAndSettle();
    final settled = tester.getSize(find.byKey(const ValueKey<String>('a')));
    expect(mounted.height, settled.height);
  });

  testWidgets('multiple mode keeps other panels open', (tester) async {
    await tester.pumpWidget(const _CollapseHost());

    await tester.tap(find.text('面板B'));
    await tester.pumpAndSettle();

    final state = tester.state<_CollapseHostState>(find.byType(_CollapseHost));
    expect(state.lastEmitted, ['a', 'b']);
  });

  testWidgets('accordion mode replaces the expanded value', (tester) async {
    await tester.pumpWidget(const _CollapseHost(mode: SantoCollapseMode.accordion));

    await tester.tap(find.text('面板B'));
    await tester.pumpAndSettle();

    final state = tester.state<_CollapseHostState>(find.byType(_CollapseHost));
    expect(state.lastEmitted, ['b']);
  });

  testWidgets('disabled panel does not emit value changes', (tester) async {
    await tester.pumpWidget(const _CollapseHost(secondDisabled: true));

    await tester.tap(find.text('面板B'));
    await tester.pumpAndSettle();

    final state = tester.state<_CollapseHostState>(find.byType(_CollapseHost));
    expect(state.lastEmitted, isNull);
    expect(state._value, ['a']);
  });

  testWidgets('placement top renders body above the header', (tester) async {
    await tester.pumpWidget(
        const _CollapseHost(placement: SantoCollapsePlacement.top));
    await tester.pumpAndSettle();

    final bodyTop = tester.getTopLeft(find.text('面板A内容')).dy;
    final headerTop = tester.getTopLeft(find.text('面板A')).dy;
    expect(bodyTop, lessThan(headerTop));
  });
}

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.



import 'package:flutter/material.dart';

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [SantoExpandableGroupWidget] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of

class SantoExpandableContainerWidget extends StatefulWidget {
  final Widget Function(BuildContext context)? headerBuilder;

  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const SantoExpandableContainerWidget({
    Key? key,
    this.onExpansionChanged,
    this.headerBuilder,
    this.child,
    this.initiallyExpanded = false,
    this.animationDuration,
    this.expandableController,
  }) : super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool>? onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final Widget? child;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  final Duration? animationDuration;

  final SantoExpandableContainerController? expandableController;

  @override
  _SantoExpansionContainerElementState createState() =>
      _SantoExpansionContainerElementState();
}

class _SantoExpansionContainerElementState
    extends State<SantoExpandableContainerWidget>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  SantoExpandableContainerController? _expandableController;
  AnimationController? _animationController;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  Widget? arrowIcon;

  @override
  void initState() {
    super.initState();
    _isExpanded =
        PageStorage.of(context).readState(context) ?? widget.initiallyExpanded;

    _expandableController =
        widget.expandableController ?? SantoExpandableContainerController();

    _expandableController!.addListener(_expandableContainerControllerTick);
    _animationController = AnimationController(
        duration: widget.animationDuration ??
            Duration(milliseconds: 200) /*_kExpand*/,
        vsync: this);
    _heightFactor = _animationController!.drive(_easeInTween);
    if (_isExpanded) {
      _animationController!.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _animationController!.isDismissed;
    return AnimatedBuilder(
      animation: _animationController!.view,
      builder: _buildHeader,
      child: closed ? null : widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _expandableController?.removeListener(_expandableContainerControllerTick);
    _expandableController = null;
    _animationController?.dispose();
  }

  void _expandableContainerControllerTick() {
    if (_expandableController!.expandableAction != SantoExpandableAction.none) {
      if (_expandableController!.expandableAction ==
          SantoExpandableAction.toggle) {
        _handleTap();
      } else if (_isExpanded == false &&
          _expandableController!.expandableAction ==
              SantoExpandableAction.expand) {
        _handleTap();
      } else if (_isExpanded == true &&
          _expandableController!.expandableAction ==
              SantoExpandableAction.collapse) {
        _handleTap();
      }
    }
    _expandableController!.expandableAction = SantoExpandableAction.none;
  }

  void _handleTap() {
    if (!mounted) return;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged!(_isExpanded);
  }

  Widget _buildHeader(BuildContext context, Widget? child) {
    Widget? content;
    if (widget.headerBuilder != null) {
      content = widget.headerBuilder!(context);
    }
    content ??= Container();

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            content,
          ]),

          /// 可展开收起项
          Container(
            child: ClipRect(
              child: Align(
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SantoExpandableContainerController extends ChangeNotifier {
  SantoExpandableAction expandableAction = SantoExpandableAction.none;

  void toggle() {
    expandableAction = SantoExpandableAction.toggle;
    notifyListeners();
  }

  void expand() {
    expandableAction = SantoExpandableAction.expand;
    notifyListeners();
  }

  void collapse() {
    expandableAction = SantoExpandableAction.collapse;
    notifyListeners();
  }
}

enum SantoExpandableAction {
  expand,
  collapse,
  toggle,
  none,
}

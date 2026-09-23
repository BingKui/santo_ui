import 'package:flutter/material.dart' hide DropdownMenu;
import 'package:santo_ui/santo_ui.dart';

class FlatSelectionThreeTagsExample extends FlatSelectionExample {
  const FlatSelectionThreeTagsExample(
    super.title,
    super.filterData, {
    super.key,
  }) : super(preLineTagSize: 3);
}

class FlatSelectionExample extends StatefulWidget {
  const FlatSelectionExample(
    this.title,
    this.filterData, {
    required this.preLineTagSize,
    super.key,
  });

  final String title;
  final List<SantoSelectionEntity> filterData;
  final int preLineTagSize;

  @override
  State<FlatSelectionExample> createState() => _FlatSelectionExampleState();
}

class _FlatSelectionExampleState extends State<FlatSelectionExample> {
  late final SantoFlatSelectionController _controller;
  var _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _controller = SantoFlatSelectionController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SantoPageLayout(
      title: widget.title,
      scrollable: false,
      padding: EdgeInsets.zero,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SantoButton(
                text: _isExpanded ? '收起筛选' : '展开筛选',
                type: SantoButtonType.text,
                onTap: () => setState(() => _isExpanded = !_isExpanded),
              ),
            ),
            Expanded(
              child: _isExpanded
                  ? Column(
                      children: [
                        Expanded(
                          child: ColoredBox(
                            color: Colors.white,
                            child: SantoFlatSelection(
                              preLineTagSize: widget.preLineTagSize,
                              entityDataList: widget.filterData,
                              controller: _controller,
                              confirmCallback: (data) {
                                SantoToast.show(
                                  data.entries
                                      .map(
                                        (entry) =>
                                            '${entry.key}: ${entry.value}',
                                      )
                                      .join(' '),
                                  context,
                                );
                              },
                            ),
                          ),
                        ),
                        _buildActions(),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8EAEC))),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 11, 20, 11),
        child: Row(
          children: [
            InkWell(
              onTap: _controller.resetSelectedOptions,
              child: const Padding(
                padding: EdgeInsets.only(left: 12, right: 20),
                child: Column(
                  children: [
                    SantoIcon(
                      SantoIcons.refresh,
                      size: 24,
                      color: Color(0xFF808695),
                    ),
                    Text(
                      '重置',
                      style: TextStyle(fontSize: 11, color: Color(0xFF808695)),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SantoButton(
              width: 104,
              type: SantoButtonType.normal,
              size: SantoButtonSize.large,
              text: '取消',
              onTap: () {
                _controller.cancelSelectedOptions();
                setState(() => _isExpanded = false);
              },
            ),
            const SizedBox(width: 20),
            SantoButton(
              width: 104,
              type: SantoButtonType.primary,
              size: SantoButtonSize.large,
              text: '确定',
              onTap: () {
                _controller.confirmSelectedOptions();
                setState(() => _isExpanded = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

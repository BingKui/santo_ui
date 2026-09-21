# Santo UI

[English](README.md) | [简体中文](README_zh-CN.md)

An enterprise-grade Flutter widget library. Santo (Cloud First) integrated and improved on existing open-source projects, mainly for internal application development. It provides unified theme customization, multi-theme configId registration, and out-of-the-box mobile widgets.

## References

This library was designed and implemented with references to the following great open-source projects:

1. **[Bruno](https://github.com/LianjiaTech/bruno)** - Flutter component library by Beike
2. **[antd](https://github.com/ant-design/ant-design)** - Ant Design React component library
3. **[TDesign](https://github.com/Tencent/tdesign-flutter)** - Tencent TDesign Flutter component library
4. **[Vant](https://github.com/youzan/vant)** - Vant mobile component library by Youzan

Thanks to these projects for their valuable references and inspiration.

## Icon Source

The `SantoIcon` widget is powered by **[Iconoir](https://github.com/iconoir-icons/iconoir)** (MIT). All SVG assets are bundled in `assets/iconoir/`: 1383 regular (outlined) icons and 288 solid icons, accessed by name. See the [SantoIcon docs](doc/components/icon/santo_icon.md).

## Components

Santo UI ships **81** widgets, grouped into 7 categories following the example app menu.

### General

| Widget | Description |
| --- | --- |
| Button | Single button entry: type / size / color & variant / shape / icon / ghost / danger / loading / disabled / block |
| Fab | Floating action button |
| Link | Text link |
| Icon | Single icon entry, bundled with the full Iconoir set (1383 icons), accessed by name |
| Panel | Title + action + scrollable content |
| Section | Demo content block with title and description |
| SafeArea | Top and bottom safe area |
| Descriptions | Single/multi-column key-value description list |

### Layout

| Widget | Description |
| --- | --- |
| Divider | Solid and dashed dividers |
| Space | Gap between widgets |
| Masonry | Multi-column masonry layout |
| Skeleton | Loading placeholder skeleton |
| FloatingPanel | Draggable, snap-to-edge bottom panel |
| AppLayout | Bottom floating menu bar + multiple pages |
| PageLayout | Configurable nav bar + scrollable content container |

### Navigation

| Widget | Description |
| --- | --- |
| AppBar | Top navigation bar |
| Tabs | Content category switching |
| MenuBar | Default and floating styles |
| Sidebar | Side navigation menu |
| Steps | Progress steps |
| AnchorTab | Anchor navigation |
| BackTop | Back to top for long lists |
| Drawer | Side slide-out panel |
| Guide | Onboarding guide |
| ActionBar | Bottom action bar |

### Data Entry

| Widget | Description |
| --- | --- |
| Input | Text input |
| Form | Form collection |
| Radio | Single choice |
| Checkbox | Multiple choices |
| Switch | Toggle |
| Rate | Star rating |
| Stepper | Quantity stepper |
| Slider | Range value selection |
| SearchText | Search input |
| Picker | Bottom sheet picker |
| Cascader | Multi-level cascading selection |
| DropdownMenu | Dropdown filter menu |
| Selection | Complex condition filtering |
| Tree | Tree structure selection |
| Calendar | Date selection |
| CitySelection | City list selection |

### Data Display

| Widget | Description |
| --- | --- |
| Avatar | User avatar |
| Badge | Dot / count badge |
| Cell | Standard list row |
| Card | Title / action / meta info and shadow card container |
| Swiper | Image / content carousel |
| Collapse | Expandable / collapsible panels |
| Image | Enhanced image widget |
| Table | Data table |
| Pagination | Page switching |
| Segmented | Segmented control |
| Statistic | Highlighted statistics |
| Tag | Marking and classification |
| BubbleText | Speech bubble text |
| Highlight | Keyword highlighting |
| TextEllipsis | Multi-line ellipsis with expand/collapse |
| Popover | Anchor-anchored popover |
| SwipeCell | Swipe actions on list items |
| NoticeBar | Scrolling notice bar |
| Progress | Linear / circular progress |
| TimeCounter | Countdown / count-up timer |
| Empty | Empty state placeholder |
| Footer | Page footer info |
| Gallery | Large image preview |

### Feedback

| Widget | Description |
| --- | --- |
| Dialog | Modal dialogs |
| ActionSheet | Bottom action menu |
| Share | Share panel |
| Toast | Lightweight toast |
| Message | Global top notification |
| Tooltip | Positioned tooltip bubble |
| OverlayWindow | Independent window above the page |
| Loading | Unified loading entry, aligned with antd Spin: size / tip / delay / wrapper / fullscreen / progress / overlay |
| Refresh | Pull-down refresh / load more |
| Result | Operation result feedback |
| Appraise | Rating & appraisal |

### Charts

| Widget | Description |
| --- | --- |
| BrokenLine | Line chart |
| Radar | Radar chart |
| Funnel | Funnel chart |
| Doughnut | Doughnut chart |
| ProgressChart | Progress chart |
| BarChart | Bar chart |

Full docs live in `doc/components/`; run the example with `cd example && flutter run`.

## Project Structure

```shell
santo_ui/
├── lib/
│   ├── santo_ui.dart                 # Single entry: import 'package:santo_ui/santo_ui.dart'
│   └── src/
│       ├── theme/                    # Theme system (SantoThemeConfigurator + per-widget Config)
│       └── components/               # Widgets grouped by category (74 category folders)
├── example/                          # Example app (category navigation + per-widget demo pages)
├── doc/                              # Documentation site sources
│   ├── santo_ui.md / start.md / theme.md / contribution.md / FAQ.md
│   └── components/<category>/santo_<widget>.md
├── tool/gen_doc.dart                 # Parameter table generation + doc validation script
└── test/                             # Unit tests (behavior cases + golden)
```

## Getting Started

```yaml
dependencies:
  santo_ui: ^1.1.0
```

```dart
import 'package:santo_ui/santo_ui.dart';

// Register a brand theme (optional; the default theme is used otherwise)
SantoThemeConfigurator.instance.register(
  SantoAllThemeConfig(
    commonConfig: SantoCommonConfig(brandPrimary: const Color(0xFF1677FF)),
  ),
);

// Bottom sheet tag picker: data is a list of tag texts, result is reported by index
SantoTagsPicker(
  context: context,
  tags: <String>['Washer', 'Fridge', 'TV'],
  maxSelectItemCount: 5,
  onConfirm: (List<int> indexes, String text) {
    print('Selected indexes: $indexes, input: $text');
  },
).show();

SantoButton(
  text: 'Submit',
  type: SantoButtonType.primary,
  size: SantoButtonSize.large,
  block: true,
  onTap: () {},
);
SantoToast.show('Saved', context);
// Use static methods for one-shot confirms; use the constructor + showDialog for complex dialogs
SantoDialog.confirm(context, title: 'Notice', message: 'Delete this item?');

showDialog<void>(
  context: context,
  builder: (_) => SantoDialog(
    iconType: SantoDialogIconType.info,
    title: 'Reject reason',
    showInput: true,
    inputController: controller,
    closable: true,
    cancelText: 'Cancel',
    okText: 'OK',
  ),
);
```

## Theming & Design Tokens

Tokens live in `SantoCommonConfig` (colors, font sizes, spacings, radii). Register with `SantoThemeConfigurator.instance.register(SantoAllThemeConfig(...), configId: ...)`. Multiple configIds can coexist (`SantoPadThemeConfig` is the Pad-side theme).

| Token | Default | Description |
| --- | --- | --- |
| `brandPrimary` | `0xFF1677FF` | Brand color; used by selected states and primary buttons |
| `radiusXs / Sm / Md / Lg` | 12 | Widget, card and overlay radii |
| `gapXs / gapSm / gapMd / gapLg / gapXl / gapXxl` | 5 / 10 / 15 / 20 / 20 / 40 | Standard spacings, derived from `iDefaultGap` (5) multiples |
| `hSpacingXs / Sm / Md / Lg / Xl / Xxl` | 5 / 10 / 15 / 20 / 20 / 40 | Horizontal spacings |
| `vSpacingXs / Sm / Md / Lg / Xl / Xxl` | 5 / 10 / 15 / 20 / 20 / 40 | Vertical spacings |

For block-level padding, use the preset constants: `iGapAllSmall / iGapAll / iGapAllMiddle / iGapAllLarger` (5 / 10 / 15 / 20) plus `iGapHorizontal / iGapVertical`. Widget content areas take `gapMd` uniformly; ad-hoc spacings like `pageGap` are gone.

Full docs live in `doc/components/`; run the example with `cd example && flutter run`.

## Development

```bash
flutter pub get
dart analyze lib example/lib         # Static analysis
flutter test test                    # Unit tests & golden
dart run tool/gen_doc.dart --all     # Generate widget parameter tables
dart run tool/gen_doc.dart --check   # Validate every widget has docs
dart doc                             # API Reference (--output doc/api)
```

Before touching a widget, read [AGENTS.md](./AGENTS.md): how to handle the bottom safe area, which spacing token to use for content areas and blocks, and how demo pages are organized.

## License

MIT License.

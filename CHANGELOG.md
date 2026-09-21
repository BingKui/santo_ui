# Changelog

[English](CHANGELOG.md) | [简体中文](CHANGELOG_zh-CN.md)

All notable changes are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/); versioning follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

### 🔄 PageLayout pull-to-refresh jitter

- **Fixed**: the refresh header used to be a `Column` sibling above the scroll view, so its growing height squeezed the list viewport on every frame — the page jittered while pulling and very little content stayed visible. The header is now an overlay on top of the list and the list content is moved with `Transform.translate` (paint-only, no relayout), so the viewport stays constant during the whole pull; the translate offset subtracts the negative scroll pixels so Bouncing physics (iOS) does not double-shift the content
- **Fixed**: `SantoPageLayout.enableRefresh` chained a bare `AlwaysScrollableScrollPhysics` (no parent physics) onto the built-in `SingleChildScrollView`, which removed boundary conditions and the ballistic settle simulation — the scroll position stayed negative after release and every subsequent scroll re-opened the refresh header. The platform physics (`ScrollConfiguration.of(context).getScrollPhysics(context)`) is now chained as the parent
- **Added**: regression tests asserting the scroll position returns to 0 after a refresh and the scroll viewport height stays constant while pulling

### 🏙 City selection

- **Fixed**: the white `DecoratedBox` between the list `ListTile`s and the nearest `Material` hid ink splashes and triggered the framework's "ListTile background color or ink splashes may be invisible" assertion; the body now uses a white `Material` directly
- **Changed**: the hot-city chips get rounded corners (`radiusXs`), keep a fixed 36px height and a transparent background
- **Changed**: the search bar padding is uniform (`hSpacingMd`) instead of left/right 20 / top/bottom 10, and the divider under the search bar follows the standard 0.5 hairline spec
- **Changed**: the A-Z index bar shows a persistent selected style — the letter of the current list section renders as a brand-colored circle with a white letter (`IndexBar.currentTag`, driven by `AzListView`); while pressing, the touched letter keeps a grey circle highlight; the unused `IndexBar.touchDownTextStyle` was removed

### 🗺 Area cascader

- **Added**: `SantoCascader.showArea()` opens a province/city/district picker backed by the built-in area data ported from `@vant/area-data` (34 provinces / 369 cities / 3478 counties, 6-digit national administrative codes)
- **Added**: `SantoAreaData` exposes `provinceList` / `cityList` / `countyList` flat code-to-name maps and `cascaderItems` (a province/city/county tree derived from code prefixes, values are codes and labels are names) for use with the generic `SantoCascader.show()`
- **Added**: the `showArea` confirm callback returns a `SantoAreaResult` with `codes` / `names` / `text` (names joined by "/") and per-level getters `provinceCode` / `provinceName` / `cityCode` / `cityName` / `districtCode` / `districtName`; `initialValues` accepts administrative codes for echo display

### 🖼 Empty illustrations

- **Changed**: the built-in illustrations of `SantoEmpty` are replaced by 12 SVG assets under `assets/empty`; the `SantoEmptyImageType` values are redefined as notFound / contentEmpty / importLoading / listEmpty / loadFail / noAccess / notOpenPayType / offline / orderEmpty / searchEmpty / unbindAccount / wait (the old noData / networkError values are removed)
- **Changed**: the `img` parameter is widened from `Image?` to `Widget?`, so any image widget (including SVG) can be passed; custom images still take priority over `imageType`
- **Changed**: the preset mapping of `SantoAbnormalStateUtils` is updated: getDataFailed → loadFail, networkConnectError → offline, noData → listEmpty
- **Removed**: the legacy illustrations `assets/images/no_data.png` and `assets/images/network_error.png` and the `SantoAsset.noData` / `SantoAsset.networkError` constants

### 🧭 TabBar indicator

- **Changed**: the selected tab indicator of `SantoTabBar` is now the bottom border of the rounded selected area (full item width, clipped to the rounded corners), following the same switch animation as the selected background; the built-in `TabBar` indicator is disabled
- **Removed**: `SantoTabBar.indicatorWidth` and `SantoTabBar.indicatorPadding` (no longer meaningful); `indicatorWeight` still controls the border thickness and `indicatorColor` the border color; `SantoAnchorTabBarStyle.indicatorPadding` removed accordingly
- **Fixed**: the "more" button container passed tight constraints down to the icon, so the arrow SVG rendered ~25px regardless of `SantoIcon.size`; it now centers a 20px icon (the chevron glyph spans half of its viewBox, ~10px visually)

### 📜 Drawer long content

- **Fixed**: the `SantoBottomDrawer` content area is now scrollable, so long content scrolls within `maxHeight` (default 85% of the screen height) instead of overflowing vertically; the drawer example gained a "long content auto scroll" case

### 🔄 Refresh header radius

- **Fixed**: the default pull-to-refresh header is now rounded (theme `radiusMd`) instead of a square full-bleed band

### 🗑 Legacy bitmap cleanup

- **Removed**: 28 obsolete `SantoAsset` constants (single/multi selected boxes, alert/warning/success, star_size, arrow_up/down, require_red, star_select, the notice family) and their PNG assets; component icons are now fully provided by SantoIcon, trimming `assets/images` from 50 to 40 files and `assets/icons` from 33 to 12

## [1.1.1] - 2026-09-21

### 🧩 Segmented badge

- **Added**: `SantoSegmentedOption.badgeCount` renders a count badge to the right of the label (via `SantoBadge`, capped at 99+) and `SantoSegmentedOption.dot` renders a dot badge, aligned with the antd Segmented item badge; comes with a new "badge" example section

### 🖼 Empty image parameter

- **Changed**: `SantoEmpty` supports the new `imageType` parameter (`SantoEmptyImageType` — noData / networkError) to show different built-in illustrations; when neither `imageType` nor `img` is set no image is rendered; `img` keeps the highest priority; `SantoAbnormalStateUtils` now presets illustrations via `imageType`

## [1.1.0] - 2026-09-20

Buttons, loading, dialogs, Card and Tag converged into single entries, icons unified on SantoIcon, and widget spacings moved to theme tokens. **Breaking changes.**

### 💥 Breaking changes

#### Buttons converge on a single SantoButton

- **Added**: `SantoButton` as the unified button with new `color` / `variant` / `size` / `shape` / `ghost` / `iconSize` parameters
- **Added**: `SantoButtonColor` semantic colors neutral / primary / danger / success / warning / info, mapped to `colorTextBase` / `brandPrimary` / `brandError` / `brandSuccess` / `brandWarning` / `brandAuxiliary`
- **Added**: `SantoButtonSize` — large (48/16), middle (32/14, default, min width 84), small (24/12)
- **Removed**: `SantoNormalButton` (incl. `SantoNormalButton.outline`), `SantoBigMainButton`, `SantoBigOutlineButton`, `SantoBigGhostButton`, `SantoSmallMainButton`, `SantoSmallOutlineButton`, `SantoSmallGhostButton`
- **Removed**: `SantoIconButton`, `SantoVerticalIconButton` (icon buttons merged into `SantoButton` via `icon` + `iconPlacement`; the `Direction` enum moved to the Guide widget), `SantoButtonConstant`
- **Removed**: `SantoButtonPanel`, `SantoButtonPanelConfig`, `SantoBottomButtonPanel`, `SantoTextButtonPanel`, `SantoMultipleBottomButton`; button groups are now assembled by callers with `Row` / `Expanded` / `SantoSpace`
- **Changed**: `SantoButtonConfig`'s `bigButton*` / `smallButton*` renamed to `largeButton*` / `middleButton*`, plus new `smallButton*`
- **Changed**: default button font size and height are determined by `size`; default size is middle
- **Changed**: removed `themeData` and `maxWidth` from individual button widgets in favor of the global `SantoButtonConfig` and parameters such as `fontSize` / `width`

#### Dialogs converge on a single SantoDialog

- **Added**: `SantoDialog` as the unified dialog entry, with all six parts parameterized — icon `icon` / `iconType`, title `title` / `titleWidget`, message `message` / `messageWidget`, input `showInput` plus the `input*` group, bottom buttons `okText` / `cancelText`, and close button `closable`
- **Added**: the input renders `SantoInputText` internally; `messageMaxHeight` bounds the message area with inner scrolling
- **Added**: named constructors `SantoDialog.alert` (vertical primary/secondary emphasis), `SantoDialog.richText` (long CSS2 rich text), `SantoDialog.singleSelect`, `SantoDialog.multiSelect`, `SantoDialog.share`
- **Added**: static methods `SantoDialog.confirm` / `info` / `success` / `warning` / `error` for one-shot dialogs without manual `new` and `pop`; `SantoDialog.show` / `SantoDialog.dismiss` close dialogs precisely by tag
- **Added**: `SantoDialogIconType` presets info / warning / error / success rendered with `SantoIcon` line icons and theme semantic colors; callback types `SantoDialogSingleSelectSubmit` / `SantoDialogMultiSelectSubmit` / `SantoDialogSelectItemClick` / `SantoDialogShareItemClick`
- **Removed**: `SantoDialogManager` (its three show methods are covered by `SantoDialog.confirm` and the constructor + `showDialog`)
- **Removed**: `SantoEnhanceOperationDialog`, `SantoDialogConstants`
- **Removed**: `SantoContentExportWidget`, `SantoScrollableTextDialog`, `SantoScrollableText`
- **Removed**: `SantoMiddleInputDialog`, `SantoSingleSelectDialog`, `SantoSingleSelectDialogWidget`
- **Removed**: `SantoMultiSelectDialog`, `MultiSelect` (option `MultiSelectItem` kept)
- **Removed**: `SantoShareDialog` (channel form merged into `SantoDialog.share`; bottom-sheet sharing keeps using `SantoShare`)
- **Removed**: `SantoSafeDialog` (covered by `SantoDialog.show` / `SantoDialog.dismiss`) and `SantoDialogUtils`
- **Changed**: bottom buttons changed from `actionsText` + `indexedActionCallback` to `okText` / `cancelText` / `onOk` / `onCancel`; `actionsWidget` replaced by `footer` — for three or more buttons assemble them with `Row` / `Column`
- **Changed**: header icon changed from `showIcon` / `iconImage` to `iconType` / `icon`; close button from `isClose` / `onCloseClick` to `closable` / `onClose`
- **Changed**: message parameter `messageText` → `message`; `dismissOnActionsTap` → `dismissOnActionTap`
- **Changed**: button taps now "close the dialog first, then invoke the callback"; the input value is read from `inputController.text` (previously `onConfirm(value)`)
- **Changed**: dialog paddings and block spacings now use standard spacing tokens, dropping legacy Bruno values (title horizontal 40, content horizontal 20, title-body 8, icon-title 12, body-footer 28, warning top 6, no-icon top 25): horizontal and block spacings use `hSpacingMd` / `vSpacingMd` (15), with a dedicated top tier — icon top offset `vSpacingXxl` (40), or `vSpacingXl` (20) without an icon
- **Changed**: dialog width restored to 85% of screen width (same as `SantoDialog` before the convergence; the convergence briefly misused the unused `dialogWidth` 300 theme value); pass `width` for a fixed width
- **Changed**: no duplicated gray background/Scaffold inside dialogs; a single white rounded `Material`, scrollable as a whole when content overflows

#### ActionBar adopts the unified icon & button system

- **Changed (breaking)**: `SantoActionBarIcon`'s `icon` parameter changed from `Widget` to a `String` icon name (see `SantoIcons` / `SantoSolidIcons`), rendered internally by `SantoIcon`, with color and size controlled by the widget
- **Changed**: `SantoActionBarButton` is now implemented on top of `SantoButton` instead of custom containers and press feedback; the disabled state changed from 0.4 opacity to the standard `SantoButton` disabled style (grayed out), font weight changed to the `SantoButton` default w500, and the global multi-click guard is applied

#### Card convergence & Descriptions

- **Changed (breaking)**: `SantoShadowCard` renamed to `SantoCard`, with new `title` / `titleWidget` / `extra` / `meta` parameters and a default background of theme `fillBase` (white)
- **Added**: `SantoCardMeta` (avatar + title + description) and `SantoDescriptions` / `SantoDescriptionsItem`, aligned with antd Descriptions, supporting `column` / `layout` / `bordered` / `size` / `colon` / `labelWidth` / `span`
- **Removed**: `SantoInsertInfo` (duplicated `SantoBubbleText`; use `SantoBubbleText` for bubble texts)
- **Removed**: `SantoFollowPairInfo`, `SantoAlignPairInfo` (covered by `SantoPairInfoTable`'s `isValueAlign`; both became private implementations)
- **Changed (breaking)**: Tag converged on a single `SantoTag`; plain / bordered / state / colorful forms are all parameter-driven. `SantoTagCustom` (incl. `buildBorderTag`) and `SantoStateTag` are removed; the `TagState` enum is renamed to `SantoTagState`

### ⏳ Loading convergence

- **Added**: `SantoLoading` as the unified loading widget, aligned with antd Spin, covering size, tip, controlled visibility, delay, custom indicator, wrapper, fullscreen and progress
- **Added**: `SantoLoadingSize` — small (14), medium (20, default), large (32)
- **Added**: static methods `SantoLoading.show` / `SantoLoading.dismiss` to show and dismiss the loading overlay
- **Removed**: `SantoPageLoading`, `SantoLoadingDialog`, covered by `SantoLoading` and `SantoLoading.show` / `dismiss`
- **Changed**: overlay tip parameter renamed from `content` to `tip`

### 🎨 Icons unified on SantoIcon

- **Added**: `SantoIcon` unified icon widget, addressed by name; `SantoIcons` provides constants for all 1383 regular icons
- **Added**: the open-source [Iconoir](https://github.com/iconoir-icons/iconoir) (MIT) SVG assets bundled under `assets/iconoir/`, in regular (1383) and solid (288) styles
- **Added**: the `solid` parameter enables the solid style, with the `SantoSolidIcons` name constants
- **Changed**: new dependency `flutter_svg ^2.3.0`
- **Changed**: line icons such as search, close, right/up/down arrows, triangle, add/remove, question mark and calendar paging replaced PNG assets with `SantoIcon` across 43 widget files; multi-color PNG icons (selection indicators, rating stars, filter reset, dropdown arrows, required-star, the ten NoticeBar state icons) were replaced as well, with dialog preset icons and selected/lit states using solid variants from `SantoSolidIcons`
- **Kept**: appraisal emojis, share-channel brand icons, step number badges, and illustration images (`SantoEmpty`'s no_data / network_error, city selection empty state)
- **Changed**: stepper add/remove buttons now differentiate enabled/disabled with theme colors `colorTextSecondary` / `colorTextDisabled`
- **Removed**: 56 unreferenced constants in `SantoAsset`; 63 unreferenced asset files under `assets/` (incl. the whole `assets/icons/radio/` directory)

### 🧩 Table scrolling & fixed columns

- **Added**: `SantoTable.height` for the content area height; data scrolls vertically inside the area with a fixed header (aligned with antd `scroll.y`)
- **Added**: horizontal scrolling, enabled automatically when column widths exceed the container; all columns render with fixed widths, defaulting to 120 when unset
- **Added**: `SantoTableColumn.fixed` (left / right) pins columns to the sides during horizontal scrolling, combinable with vertical scrolling (aligned with `column.fixed`)
- **Removed**: `SantoTable.pinnedHeader`, replaced by `height`
- **Changed**: when all columns are fixed-width and exceed the container, the table scrolls horizontally instead of squeezing proportionally

### 📏 Spacings unified on theme tokens

- **Changed**: `SantoSpace` preset gaps changed from hardcoded 8/16/24 to theme tokens (horizontal `hSpacingSm/Md/Lg`, vertical `vSpacingSm/Md/Lg`, default 10/15/20)
- **Changed**: `SantoDividerSize` doc comments corrected to match the implementation (theme `vSpacingSm/Md/Lg`); behavior unchanged

### 📝 Examples & docs

- Button example page rewritten in antd Button groups: type / ghost / danger / icon / icon placement / loading / sizes / disabled / block / color & variant / shape / custom disabled background / button groups
- All call sites (dialogs, pickers, tag selection, appraisal, filters, etc.) and examples migrated to `SantoButton`
- Dialog example page rewritten in antd Modal groups: basic / icon / message / input / warning / close button / custom footer / alert / semantic dialogs / long text / single-select / multi-select / share / close by tag
- The "CardContent" entry renamed to "Descriptions", with its example rewritten as a single page
- Material icons in ActionBar examples and docs fully replaced with SantoIcon icons
- New widget docs: `doc/components/button/santo_button.md`, `doc/components/icon/santo_icon.md`, `doc/components/dialog/santo_dialog.md` (with a migration table from the 9 legacy dialog classes to the new API), `doc/components/card/santo_card.md`, `doc/components/descriptions/santo_descriptions.md`

## [1.0.1] - 2026-09-18

### 🐛 Bug fixes

- Fixed a compile error in `SantoProgress` where `initState` still referenced `_previousValue` after the field was removed
- Removed a redundant null check on the result of `Overlay.of(context)` in `SantoMessage`

### ⚡ Improvements

- Removed unused variables, redundant non-null assertions and unused imports from `SantoAvatar`, `SantoDrawer`, `SantoLink`, `SantoSkeleton` and `SantoMenuBar`; `dart analyze` passes with no warnings

## [1.0.0] - 2026-09-18

Initial release of Santo UI v1.0.0. Ships **80** widgets grouped into General, Layout, Navigation, Data Entry, Data Display, Feedback and Charts following the example app menu.

### Highlights

- **Unified theme system**: `SantoThemeConfigurator` supports multiple configIds and provides full customization of brand colors, radii, spacings, etc.
- **Standard spacing system**: `gapXs~gapXxl` (5/10/15/20/30/40) plus `iGapAll/iGapAllSmall/iGapAllMiddle/iGapAllLarger` presets
- **Bottom safe area convention**: bottom-anchored widgets paint their background to the screen bottom while content avoids the safe area; not configurable
- **Unified corner radius**: 12px baseline with theme tokens radiusXs/Sm/Md/Lg and per-widget container radii

### 📦 Widget list (by example menu)

#### General (7)

Button, Fab, Link, Panel, Section, SafeArea, CardContent

#### Layout (7)

Divider, Space, Masonry, Skeleton, FloatingPanel, AppLayout, PageLayout

#### Navigation (10)

AppBar, Tabs, MenuBar, Sidebar, Steps, AnchorTab, BackTop, Drawer, Guide, ActionBar

#### Data Entry (16)

Input, Form, Radio, Checkbox, Switch, Rate, Stepper, Slider, SearchText, Picker, Cascader, DropdownMenu, Selection, Tree, Calendar, CitySelection

#### Data Display (23)

Avatar, Badge, Cell, Card, Swiper, Collapse, Image, Table, Pagination, Segmented, Statistic, Tag, BubbleText, Highlight, TextEllipsis, Popover, SwipeCell, NoticeBar, Progress, TimeCounter, Empty, Footer, Gallery

#### Feedback (11)

Dialog, ActionSheet, Share, Toast, Message, Tooltip, OverlayWindow, Loading, Refresh, Result, Appraise

#### Charts (6)

BrokenLine, Radar, Funnel, Doughnut, ProgressChart, BarChart

### 🎯 Design references

This library integrates and improves on the following great open-source projects:

- [Bruno](https://github.com/LianjiaTech/bruno) - Flutter component library by Beike
- [antd](https://github.com/ant-design/ant-design) - Ant Design React component library
- [TDesign](https://github.com/Tencent/tdesign-flutter) - Tencent TDesign Flutter component library
- [Vant](https://github.com/youzan/vant) - Vant mobile component library by Youzan

### 📚 Docs & examples

- Full widget documentation site (`doc/components/`)
- Example app (`example/`) with demos for every widget
- Development conventions (`AGENTS.md`)
- API version annotation conventions

### 🔧 Tech stack

- Flutter >=3.10.0
- Dart >=3.13.3
- Dependencies: xml ^6.1.0, lpinyin ^2.0.3, path_drawing ^1.0.0, intl >=0.18.0 <2.0.0, photo_view ^0.15.0

---

## References

- [Keep a Changelog](https://keepachangelog.com/) - changelog format
- [Semantic Versioning 2.0.0](https://semver.org/) - versioning scheme

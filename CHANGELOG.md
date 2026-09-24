# Changelog

[English](CHANGELOG.md) | [简体中文](CHANGELOG_zh-CN.md)

All notable changes are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/); versioning follows [Semantic Versioning](https://semver.org/).

## [2.0.0] - 2026-09-24

### 🎨 Every style token lives in the theme

- **Added (breaking)**: shadow tokens — `shadowColor`, `shadowSm` / `shadowMd` / `shadowLg` (`List<BoxShadow>`); components default to a preset and can override it
- **Added (breaking)**: semantic tint tokens — `brandPrimaryBg` / `brandSuccessBg` / `brandWarningBg` / `brandErrorBg`, plus `fillBaseInverse` (inverse surface, e.g. the image viewer) and `appBarDarkBackgroundColor`
- **Added (breaking)**: chart tokens — `chartPalette` (categorical series colours), `chartAxisColor`, `chartAxisTextColor`, `chartGridColor`
- **Added (breaking)**: `SantoAppBarConfig.leadingSize` / `leadingSpacing` / `doubleLeadingSize`
- **Changed (breaking)**: `lib/src/components/picker/base/santo_picker_constants.dart` is removed from the public API — the symbols `pickerBackgroundColor`, `pickerShowTitleDefault`, `pickerHeight`, `pickerTitleHeight`, `pickerItemHeight`, `datetimePickerItemTextStyle` and `pickerItemTextStyle` are gone. Use `SantoPickerConfig` (heights, background) and `SantoCommonConfig` (colours) instead
- **Changed (breaking)**: `SantoAppBarTheme` (the private `navbar/santo_appbar_theme.dart`) is removed — its colours and font sizes now come from `SantoCommonConfig`, its geometry from `SantoAppBarConfig`
- **Changed**: components no longer hard-code colours; `tree`, `cascader`, `dropdown_menu`, `drawer`, `sidebar`, `tag`, `switch`, `form`, `picker`, `charts` and the default configs now read `colorTextBase` / `colorTextSecondary` / `fillBase` / `dividerColorBase` / `brand*` and friends, so a custom theme reaches them
- **Changed**: the chart defaults are theme-derived — `SantoProgressChart.colors` / `backgroundColor`, `SantoProgressBarBundle.colors` / `hintColors`, `SantoProgressBarChartPainter.unselectedColor` / `selectedHintTextColor` / `selectedHintTextBackgroundColor` and `SantoRadarChart.axisLineColor` are nullable and fall back to the theme; `SantoRadarChart.defaultRadarChartStyles` and `SantoFunnelChart.defaultLayerColors` are now derived from `brandPrimary` / `chartPalette`
- **Changed**: `SantoPickerTitleConfig.showTitle` keeps its `true` default, now expressed as a literal instead of the removed constant
- **Changed (breaking)**: `SantoStepper` drops the public constant `kSantoStepperRadius` (the radius comes from `SantoCommonConfig.radiusMd`)
- **Changed (breaking)**: `SantoShare.textColor` / `shareTextColor`, `SantoStepLine.lineWidth` and `SantoSearchText.outSideColor` / `innerPadding` / `borderRadius` are now nullable so the theme value applies when they are omitted

### 🧭 `SantoAnchorTab` renamed `SantoAnchor`

- **Changed (breaking)**: `SantoAnchorTab` is renamed `SantoAnchor` and `SantoAnchorTabBarStyle` is renamed `SantoAnchorBarStyle`, so no public symbol carries the old name — the builders become `AnchorWidgetIndexedBuilder` (was `AnchorTabWidgetIndexedBuilder`) and `AnchorIndexedTabBuilder` (was `AnchorTabIndexedBuilder`), and the component moves to `lib/src/components/anchor/santo_anchor.dart`
- **Changed**: the example moves to `anchor/anchor_example.dart` (`AnchorExample`); the menu entry, page title and intro title are now all `Anchor 锚点`

### 🧩 New layout components

- **Added**: `SantoFlex` (lib/src/components/flex/santo_flex.dart) — a flex layout component modelled on antd Flex: `orientation` (horizontal/vertical), `wrap`, `justify` (main axis), `align` (cross axis, defaulting to start horizontally and stretch vertically), a uniform `flex` value that wraps every child in `Expanded`, and gap control via `gapSize` (the `SantoSpaceSize` small/middle/large tiers, resolved from theme spacing tokens) or a custom `gap` value
- **Added**: `SantoGrid` — `SantoRow` + `SantoCol` (lib/src/components/grid/santo_grid.dart), a 24-column grid modelled on antd Grid: `span` / `offset` / `order` / `push` / `pull` / `flex` per column, `gutter` column spacing (first/last column content flush with the row edges), `verticalGutter` row spacing, automatic wrapping when spans exceed 24, plus `justify` / `align`. antd's responsive breakpoints (xs–xxl) are not ported — they are specific to CSS media queries

### 📝 `SantoInputText` renamed `SantoInput`

- **Changed (breaking)**: `SantoInputText` is renamed `SantoInput` and moves to `lib/src/components/input/santo_input.dart`; the example class becomes `SantoInputExample`
- **Added**: `type` parameter switches the unified entry between modes, modelled on antd Input — `SantoInputMode.text` (single-line, default), `SantoInputMode.search` (built-in leading search icon unless a custom `prefix` is given), `SantoInputMode.textarea` (multi-line, `minLines` defaults to 4 and the height grows with content). The enum is `SantoInputMode` (the name `SantoInputType` was already taken by the form system)
- **Changed**: the single-line content height drops from 44 to 32; the border width is pinned to 1 (no longer follows the `borderWidthMd` theme tier)
- **Changed**: `SantoSearchText` gains an optional `height` for the inner field; the default is now 32, aligned with the new single-line standard (previously the field auto-sized to the content)

### 🏙️ City selection refresh

- **Changed**: the hot-city chips in `SantoCitySelection` now render a selectable `SantoTag` group (uniform 15 outer padding, 10 gaps, three equal-width tags per row); tapping a tag returns the city and closes the page
- **Changed**: the search bar keeps `SantoSearchText` but renders the inner field at the standard 32 height with a uniform 15 padding; the header height estimate is now derived from the real layout so no blank gap is left below the chips

## [1.5.1] - 2026-09-24

### 💬 Chat custom messages

- **Added**: `SantoChatCustomMessage` — a message whose content is supplied by the host app through a `builder`, rendered in a **bare bubble** (no bubble background or padding, the content brings its own container), the same treatment as document messages. This closes the gap where the closed message hierarchy could not carry business cards such as an approval card.

### 💬 More chat message types

- **Added**: `SantoChatApprovalMessage` + `SantoChatApprovalCard` — an approval card (task no, status tag, title, flow / applicant / current node) that shows 通过 / 驳回 when the task is pending and `canApprove` is true; the taps call `onApprove` / `onReject`, and the card itself calls `onApprovalTap`. `SantoChatApprovalStatus` plus `kSantoChatApprovalStatusText` / `santoChatApprovalTagState` cover the status label and tag colour
- **Added**: `SantoChatNoticeMessage` + `SantoChatNoticeCard` — a notification card (type icon, unread dot, title, body, time). `SantoChatNoticeType` decides the icon and colour (`kSantoChatNoticeIcons` / `santoChatNoticeColor`), the tap calls `onNoticeTap`, and the card also works standalone as a notification-centre row
- **Added**: `SantoChatEmojiMessage` + `SantoChatEmojiView` — a single emoji message; a `[name]` token registered in `SantoChatEmojiRegistry` renders as an image, otherwise the built-in Unicode character is used
- **Added**: `recalled` on `SantoChatMessage` — a recalled message renders nothing (the recall notice is expected to arrive as a system message), matching DevOpsMobile
- **Changed**: group announcements reuse `SantoNotice` through the `header` slot instead of a hand-rolled container
- **Changed**: the close button of the input bar's reply / edit banner is now a solid `xmark-circle` in the error colour and slightly larger (20, `kSantoChatBannerCloseSize`)

- **Changed**: message status is now text instead of icons — outgoing messages show 发送中 / 已发送 / 未读 / 已读 **below the bubble**, aligned with the avatar side (unread states take the primary colour), and only the failed warning icon stays next to the bubble
- **Added**: read receipts — `SantoChatReadReceipt` (`readCount` / `unreadCount` plus optional `readMembers` / `unreadMembers`) renders DingTalk-style text: 已读 / 未读 for a 1:1 chat and 「N人未读 / 全部已读」 for a group. Tapping the text calls `onReadReceiptTap`, and `SantoChatReadReceiptSheet.show` opens the read / unread member list
- **Fixed**: messages from the same sender in one run now keep the avatar slot even when the avatar itself is hidden, so bubbles and their receipt line up on the same right edge


### 🧭 MenuBar selected state

- **Changed**: the floating `SantoMenuBar` / `SantoAppLayout` selected item now takes a neutral light-grey background (`0xFFF0F0F0`) with the theme colour on the selected icon and label, instead of a primary-coloured pill with white text. Pass `itemSelectedBgColor` / `selectedTextColor` to bring back a custom look
- **Changed**: `selectedTextColor` now defaults to the theme colour for both styles, so the selected icon and label follow `brandPrimary`

- **Fixed**: with a custom theme colour the outgoing bubble stayed the default blue — `SantoDefaultConfigUtils.defaultChatConfig` no longer pins any colour or text style, so every chat colour is derived from the live `SantoCommonConfig` at read time

### 🔔 One SantoNotice for every notice

- **Changed (breaking)**: `SantoNoticeBar` and `SantoNoticeBarWithButton` are gone — both are merged into `SantoNotice`, the single notice-bar entry point. The left slot is either a status icon or a tag (`leftTagText`), the right slot is either a status icon or a button (`rightButtonText` + `onRightButtonTap`), and `minHeight` defaults to 54 when a tag or a button is present, 36 otherwise
- **Changed**: the ten built-in `NoticeStyles` presets now resolve their colour from the live `SantoCommonConfig` — 进行中 / 通知 take the theme colour (`brandPrimary`), 完成 `brandSuccess`, 警告 `brandWarning`, 失败 `brandError`, with the background as that colour at 10% opacity, so a custom theme colour reaches the notice bar too. The colours stored on `NoticeStyle` stay as fallbacks for hand-rolled styles, and the 通知 preset is no longer orange
- **Added**: `SantoNoticeStyleType` and `SantoNoticeRightIconKind` describe a preset; `kSantoNoticeStyleIcons` / `santoNoticeStyleColor` expose the icon and colour used for it

### ⭐ Rate follows the theme colour

- **Changed**: the selected / half star now takes `brandPrimary` instead of `brandWarning`, the unselected star takes `dividerColorBase` instead of a hard-coded grey, and the star size follows `iconSizeMd` — so a custom theme colour reaches the rating too. Pass `starBuilder` when a fixed look is needed

## [1.5.0] - 2026-09-24

### 💬 Chat conversation widgets

- **Added**: `SantoChat` (header + message list + input bar), `SantoChatMessageList`, `SantoChatBubble`, `SantoChatInput`, `SantoChatList` and `SantoChatSelectionBar`
- **Added**: message content widgets `SantoChatText` (`@` mentions, emoji registry, links), `SantoChatQuoteView`, `SantoChatImage`, `SantoChatVideo`, `SantoChatVoice`, `SantoChatFile`, `SantoChatDocCard`, `SantoChatSystemNotice`, `SantoChatTypingIndicator`, `SantoChatReactionView` and `SantoChatMessageMenu`
- **Added**: message models (`SantoChatMessage` with text/image/video/voice/file/doc/system variants, plus author, mention, quote and reaction), `SantoChatConversation`, the global `SantoChatEmojiRegistry`, `SantoChatMenuItem` and `SantoChatExtension`
- **Added**: message list features — date separators, sender grouping, swipe to reply, a long-press menu (reactions plus per-type and custom actions, wrapping 5 per row), pull-up history loading and a scroll-to-bottom button
- **Added**: message status indicators (`delivered` / `read` added to `SantoChatMessageStatus`, drawn on the avatar side of outgoing bubbles) and the `isEdited` flag; when a message fails, a solid warning icon (`warning-circle-solid`) is drawn on the opposite (non-avatar) side of the bubble, vertically centered against it, and tapping it retries via `onRetry`
- **Added**: message editing through the input bar, and multi-select with a checkbox per row plus a bottom action bar
- **Added**: input bar extension menu (photo / camera / file by default, customizable) that swaps with the keyboard below the input row, plus a built-in emoji panel (32 emojis, `[name]` tokens) sharing the same fixed 230 panel height — both panels are top-left grids with fixed cells and kept empty slots, paged 2 rows (`kSantoChatMenuItemRows`) × 5 columns for the extension menu and 4 rows (`kSantoChatEmojiRows`) × 8 columns for emojis, overflowing pages reached by swiping left/right with a page indicator at the bottom
- **Added**: document messages — `SantoChatDocMessage` renders as a `SantoChatDocCard` (doc title, optional note, 「点击查看文档」 hint) inside a **bare bubble** (`SantoChatBubble.bare`: no bubble background or padding, the card brings its own container); tapping it calls `onDocTap` so the host app can check permissions and open the doc (mirrors DevOpsMobile)
- **Added**: `SantoChatConfig` theme config, registered in `SantoAllThemeConfig` and `SantoDefaultConfigUtils`
- **Changed**: the input bar no longer renders a send button — sending goes through the IME send key, and the keyboard stays up between messages; the `sendButton` parameter was removed
- **Changed**: the input hint no longer wraps — it is single line and ellipsizes

### 🔄 Pull-to-refresh over nested scrollables

- **Fixed**: pull-to-refresh no longer dies when the content contains its own scrollable (e.g. a `SantoTable` with `height`, or a nested `ListView`) — `SantoRefresh` takes the gesture over once the nested container reaches its leading edge, shows the refresh header and triggers the refresh; on `SantoPageLayout` the nested content now stays put instead of rubber-banding down and back
- **Fixed**: load-more is only driven by the scrollable `SantoRefresh` directly hosts, so a nested list reaching its end no longer triggers `onLoadMore`
- **Fixed**: the refresh header is no longer a transparent overlay floating over the first row — pulling opens the top area and shifts the content down (paint-only translation, viewport height unchanged), so the area always carries the header content instead of overlapping the list

### 🏷️ One SantoTag for every tag

- **Changed (breaking)**: `SantoSelectTag` and `SantoDeleteTag` are gone — both are merged into `SantoTag`, the single tag entry point. `SantoDeleteTagController` is renamed `SantoTagController` (same methods)
- **Added**: tag group support on `SantoTag` — pass `tags` (or a `controller`) and the widget lays out a group of tags, keeping the old `SantoSelectTag` parameters: `spacing`, `verticalSpacing`, `softWrap`, `fixWidthMode`, `tagWidth`, `tagHeight`, `tagTextStyle`, `selectedTagTextStyle`, `tagBackgroundColor`, `selectedTagBackgroundColor`, `alignment`, `themeData`
- **Added**: `selectable` / `deletable` switches. Single tag: `initSelected` + `onSelectedChange`, and `onDelete`. Tag group: `isSingleSelect` / `initTagState` / `onChanged`, and `onTagDelete` / `controller`
- **Added**: `height` on `SantoTag` — the text is centred vertically within it
- **Changed**: `SantoTag` is now a `StatefulWidget` (internal state only, the API is unchanged) and `text` is optional, since the same widget also renders tag groups
- **Changed**: defaults now come from the theme — `height` 32 (`tagHeight`), `fontSize` 12 (`tagTextStyle`, was 11), `borderRadius` 12 (`tagRadius`), horizontal padding `hSpacingSm` (10, was a fixed 4); `padding` is now nullable so a value can override it
- **Changed**: `SantoTagConfig.tagHeight` default 34 → 32, and `SantoTagsPicker.tagHeight` default 34 → 32
- **Changed**: `SantoDeleteTag.backgroundColor` → `SantoTag.tagBackgroundColor`, `SantoDeleteTag.horizontalSpacing` → `SantoTag.spacing`; the old white wrapper and `padding` of `SantoDeleteTag` were dropped (handle it with the surrounding container)
- **Fixed**: a deletable tag group no longer forces the fixed `tagWidth`, which left the label only ~35px wide (ellipsis-only) once the delete icon was in place — such groups size to their content unless `tagWidth` is passed explicitly
- **Fixed**: a tag group is now single-line and ellipsised instead of wrapping inside its fixed height

## [1.4.3] - 2026-09-23

### 🧭 SantoAppBar examples

- **Added**: standalone light and dark custom-background pages for verifying status-bar icon brightness

### 🔄 Pull-to-refresh

- **Changed**: keep scroll content stationary while refreshing; the refresh header now overlays the content instead of translating it down and back.

## [1.4.2] - 2026-09-23

### 🗂️ SantoEmpty layout

- **Fixed**: vertically center empty-state content, constrain built-in SVG illustrations to their original aspect ratio, and trim their transparent top and bottom canvas space
- **Added**: a titled `SantoPanel` empty-state example with a fixed display height

## [1.4.1] - 2026-09-23

### 🧭 Selection examples

- **Changed**: reorganized complex-filter examples into grouped entry pages, migrated every third-level example page to `SantoPageLayout`, and consolidated the flat-filter demos into a shared implementation
- **Fixed**: removed obsolete top-level close-panel placeholders from the date-range and selection-limit examples

## [1.4.0] - 2026-09-22

### 🗂️ SantoEmpty fixed-height layout

- **Added**: `height` for rendering the empty state at a fixed height and vertically centering its content within that area

### 📊 SantoTable feature expansion

- **Added**: horizontal and vertical cell merging, single/multiple row selection, client-side sorting, expandable rows, pagination, and page-size selection
- **Added**: stable `rowKey` plus controlled selection and expansion state; existing custom rendering, fixed-height scrolling, fixed columns, and border control continue to work with the new table pipeline
- **Changed**: the default header now uses the theme's light fill color and primary text color instead of a brand-color background with inverse text
- **Changed**: default cell padding now reads `commonConfig.hSpacingMd`

## [1.3.0] - 2026-09-22

### 🧭 AppBar action icon alignment

- **Added**: `icon` (icon name) on `SantoIconAction` — the icon is then built by the component at the theme icon size, so it matches the leading arrow in size and follows the AppBar-resolved content color; `child` is kept for custom widgets (an unsized `SantoIcon` still renders at its own default), and `size` now sets the icon dimension instead of the tap area
- **Fixed**: the right-side icon actions had a 20×20 tap target with Material's circular ink splash while `SantoBackLeading` used a 32×32 target with a 12-radius rounded rect; both sides now share `SantoAppBarTheme.leadingSize` (32×32) and the same 12-radius `InkWell`
- **Fixed**: `Icon`-based children were squeezed into the 20×20 box and drawn overflowing at 24; action icons now render at the resolved 20
- **Changed**: the gap between actions (`SantoAppBarConfig.itemSpacing`, defaulting to `SantoAppBarTheme.iconMargin`) is now 5 instead of 20, matching `leadingSpacing` on the left — both sides keep 15 edge padding, so the whole bar reads symmetrically

### 🔄 SantoRefresh pull safety zone

- **Added**: `triggerDistance` — the pull distance required to trigger a refresh (the "safety zone" height), default 50. Below it the header shows nothing and releasing does not refresh; once reached the header shows "release to refresh" and releasing triggers the refresh
- **Changed**: `loadingBarHeight` no longer doubles as the trigger threshold — it now only defines the header height (the height the header holds while refreshing); whether the pull is ready is decided by `triggerDistance`
- **Added**: an assertion for `triggerDistance <= maxBarHeight`, otherwise the pull could never reach the trigger distance

### 📐 PageLayout top safe area

- **Fixed**: with a `header` and no `appBar` (e.g. a full-page custom brand header), the content area's `MediaQuery.padding.top` still carried the status-bar height. A `ListView` that owns its own scrolling and does not pass an explicit `padding` consumed it as top padding, leaving a status-bar-height blank strip below the `header`. The content area's `MediaQuery.padding.top` is now always zeroed — the top inset is owned solely by the layout (merged into `padding` when there is no `header`, or handled by the header's own `SafeArea` when there is one), consistently across the scrolling and non-scrolling modes
- **Added**: two regression tests (content top inset is 0 with a `header`; the gap between the header and the first content block contains only `padding`, not the status-bar height)

### ➖ Divider custom spacing

- **Added**: `spacing` — a custom vertical spacing for horizontal dividers that takes precedence over `size`; pass `0` to remove the vertical whitespace entirely (e.g. when the surrounding rows already carry their own padding)

## [1.2.0] - 2026-09-21

### 🧭 AppBar redesign

- **Changed**: the back button and each slot of `SantoDoubleLeading` now use a fixed 32×32 tap area (`SantoAppBarTheme.leadingSize`), with 5 spacing between the two leading ops and 15 edge padding on both sides of the app bar; the double-leading width and the reserved leading slot are computed from the same formula, so the previous horizontal overflow is gone
- **Changed**: the title is always centered on the bar (`centerTitle` fixed)
- **Added**: light/dark content modes — when the background luminance < 0.5 (dark mode or a custom background color), title / action texts / back arrow / icon theme default to white while custom colors are preserved; on a light background the content defaults to black and a custom white is automatically clamped back to black (invisible on white)
- **Fixed**: `SantoAppBarConfig.copyWith` / constructor parameter renamed from `systemUiOverlayStyle` to `systemOverlayStyle`, consistent with Flutter's `AppBar`

### 🧭 MenuBar select styling

- **Added**: `selectedTextStyle` / `unselectedTextStyle` for full control of the selected / unselected label font (size, weight, color; falls back to the color params)
- **Added**: docked style now supports `itemSelectedBgColor` (sliding animated selection background, same as floating; not rendered by default)
- **Fixed**: docked-style icon colors now follow the selected / unselected colors via `IconTheme` (icons with an explicit color still win)

### 📐 PageLayout extensions

- **Added**: `header` — a fixed area right below the title (search bar, filters, tabs, steps, calendar…), full-width, no padding, auto height and not scrolling with content
- **Added**: `enableRefresh` / `onRefresh` — the built-in scroll container is hosted by `SantoRefresh`; `AlwaysScrollableScrollPhysics` is applied so short content can still be pulled
- **Added**: `padding` to override the default content inset (top safe-area avoidance is still applied by the layout)
- **Added**: `appBar*` passthrough parameters (`appBarLeading` / `appBarActions` / `appBarBackgroundColor` / `appBarElevation` / `appBarShadowColor` / `appBarShape` / `appBarIconTheme` / `appBarActionsIconTheme` / `appBarSystemOverlayStyle` / `appBarBackLeadCallback`) for the title-only construction path

### 🧭 ActionBar spacing & divider

- **Changed**: the action bar button area now uses 10 horizontal outer padding (first / last button) and 5 vertical padding; the button height is stretched to the remaining bar height instead of a fixed 40
- **Added**: a 0.5px hairline divider on top of the action bar

Pull-to-refresh rework, TabBar indicator, Empty illustrations, Checkbox/Radio card style, city selection and the area cascader. **Breaking changes** to `SantoEmptyImageType` values, `SantoTabBar` indicator parameters and some legacy `SantoAsset` constants.

### 🔄 PageLayout pull-to-refresh jitter

- **Fixed**: after releasing a pull past the threshold, the header used to collapse all the way to 0 following the iOS bounce rebound (the `ScrollEndNotification` is delayed until the rebound simulation finishes) and only then pop the loading area back to the loading height. Release is now detected on the first post-drag scroll update: the header smoothly shrinks from the pull distance to `loadingBarHeight` and holds there while refreshing, then shrinks to 0 after the done state — the same sequence as Vant's PullRefresh
- **Changed**: the default refresh header no longer paints the theme `fillBody` rounded background; it is now transparent and only shows the loading icon and status text
- **Changed**: the done state of the default refresh header now shows the success icon (`check-circle`, theme `brandSuccess` color) instead of the pull arrow
- **Changed**: the done state (success icon and "refresh complete" text) now persists through the whole collapse animation — the state only returns to inactive after the header has fully closed, instead of flipping back to the pull arrow as soon as the collapse starts
- **Added**: regression tests forcing Bouncing physics asserting the header settles at the loading height (never below it) during refresh and returns to 0 after completion
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

### 📜 Drawer safe areas & width cap

- **Added**: the content area of `SantoDrawer` now avoids the top status bar and bottom home indicator according to the slide direction — top drawers keep the top inset, bottom drawers keep the bottom inset, left/right full-height drawers keep both. Like `SantoBottomDrawer` / `SantoFloatingPanel`, the inset is delivered by rewriting the content `MediaQuery` padding (not configurable) so it lives inside the content instead of an extra blank region: scrollable content (e.g. a `ListView` without explicit padding) consumes it as its own scroll padding — the scroll area spans the full drawer and the last item settles above the home indicator when scrolled to the end; fixed headers/footers read `MediaQuery.of(context).padding` inside the drawer subtree and fold the inset into their own padding. The drawer example was restructured to demonstrate both patterns (title as the first list item with auto-consumed padding; pinned action row with inset-aware padding)
- **Changed**: the width of left/right drawers is now capped at 95% of the screen width; larger values are clamped to the cap

### 🔄 Refresh header radius

- **Fixed**: the default pull-to-refresh header is now rounded (theme `radiusMd`) instead of a square full-bleed band

### 🗑 Legacy bitmap cleanup

- **Removed**: 28 obsolete `SantoAsset` constants (single/multi selected boxes, alert/warning/success, star_size, arrow_up/down, require_red, star_select, the notice family) and their PNG assets; component icons are now fully provided by SantoIcon, trimming `assets/images` from 50 to 40 files and `assets/icons` from 33 to 12
- **Removed**: 10 unused example assets — `example/assets/image`: arrow_up / icon_clear_grey / icon_navbar_add_hei / icon_navbar_im_bai / icon_navbar_xiala_hei / icon_refresh / icon_theme / network_error / no_data, and `example/assets/icons`: navbar_house. The now-empty `assets/icons/` entry was dropped from the example pubspec. `assets/icons/grey_place_holder.png` is kept: the gallery config and two ActionSheet examples resolve it from the package (`SantoTools.getAssetImage` adds `package: santo_ui`)

### 🧭 Example icons de-picturized

- **Changed**: the NavBar and Toast examples no longer load PNG icons — the search / plus / close / dropdown / share / group / heart / message glyphs now come from `SantoIcon` (`SantoIcons.search` / `plus` / `xmark` / `navArrowDown` / `shareIos` / `group` / `heart` / `chatLines`), the Toast pre-icons use the solid `check-circle` / `xmark-circle`, and the 16 converted PNGs are deleted
- **Changed**: `SantoToast.show`'s `preIcon` and `ToastChild.leading` are widened from `Image?` to `Widget?`, so any widget (including `SantoIcon`) can be passed as the pre-icon

### ☑️ Checkbox & Radio card style

- **Changed**: the selected state of a `cardMode` card is now a solid `check-circle` icon on the right of the card — same color as the card border, side length 50% of the card height — replacing the brand triangle with a white check that used to sit in the top-left corner; the triangle painter (`_CornerCheck`) is removed
- **Fixed**: the card description (`subTitle`) was indented by one extra `insetSpacing` because the container padding was counted twice, so it did not line up with the title; the description now left-aligns with the title for every combination of `cardMode` and `contentDirection`

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

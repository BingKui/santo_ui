"""把 Bruno 风格示例页的 fontSize:28 文字标题分块转换为 SantoPanel.
转换失败时自动还原单个文件。"""
import re
import glob
import subprocess


def find_matching(text, start):
    depth = 0
    i = start
    in_str = None
    while i < len(text):
        c = text[i]
        if in_str:
            if c == in_str and text[i - 1] != '\\':
                in_str = None
            i += 1
            continue
        if c in ("'", '"'):
            in_str = c
            i += 1
            continue
        if c in '([{':
            depth += 1
        elif c in ')]}':
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


def split_top_level(text):
    entries, depth, cur, i = [], 0, '', 0
    in_str = None
    while i < len(text):
        c = text[i]
        if in_str:
            cur += c
            if c == in_str and text[i - 1] != '\\':
                in_str = None
            i += 1
            continue
        if c in ("'", '"'):
            in_str = c
            cur += c
            i += 1
            continue
        if c in '([{':
            depth += 1
            cur += c
        elif c in ')]}':
            depth -= 1
            cur += c
        elif c == ',' and depth == 0:
            entries.append(cur)
            cur = ''
        else:
            cur += c
        i += 1
    if cur.strip():
        entries.append(cur)
    return entries


HEADER_RE = re.compile(
    r"^\s*Text\(\s*'([^']*)'\s*,\s*style:\s*TextStyle", re.S)
HEADER_FONT_RE = re.compile(r'fontSize:\s*28')


def transform(path):
    src = open(path).read()
    if 'fontSize: 28' not in src:
        return None
    m = re.search(r'fontSize: 28', src)
    list_start = src.rfind('children: [', 0, m.start())
    if list_start < 0:
        list_start = src.rfind('children: <Widget>[', 0, m.start())
        open_idx = list_start + len('children: <Widget>')
    else:
        open_idx = list_start + len('children: ')
    close_idx = find_matching(src, open_idx)
    body = src[open_idx + 1:close_idx]
    entries = split_top_level(body)

    groups = []
    for e in entries:
        t = e.strip()
        hm = HEADER_RE.match(t) if t.startswith('Text(') else None
        if hm and HEADER_FONT_RE.search(t):
            groups.append((hm.group(1), []))
        else:
            if not groups:
                groups.append((None, []))
            groups[-1][1].append(e)

    if all(g[0] is None for g in groups):
        return None

    out = []
    for title, items in groups:
        if title is None:
            out.extend(items)
            continue
        items = [i for i in items if i.strip()]
        if not items:
            continue
        inner = ','.join(items)
        out.append("SantoPanel(\n"
                   "            title: '" + title + "',\n"
                   "            child: Column(\n"
                   "              crossAxisAlignment: CrossAxisAlignment.start,\n"
                   "              children: [" + inner + "],\n"
                   "            ),\n"
                   "          )")
    new_body = ',\n'.join(out) + ','
    return src[:open_idx + 1] + '\n' + new_body + '\n' + src[close_idx:]


files = []
for pat in ['example/lib/sample/components/button/*.dart',
            'example/lib/sample/components/step/*.dart',
            'example/lib/sample/components/card_title/*.dart',
            'example/lib/sample/components/card/content/*.dart',
            'example/lib/sample/components/card/bubble/*.dart']:
    files += glob.glob(pat)
# 排除入口列表页
skip = ('button_entry_page', 'bottom_button_entry_page',
        'button_panel_entry_page', 'bubble_entry_page',
        'text_content_entry_page')
files = [f for f in files if not any(s in f for s in skip)]

for f in files:
    try:
        new = transform(f)
        if new is None:
            print('SKIP', f)
            continue
        open(f, 'w').write(new)
        r = subprocess.run(
            ['dart', 'analyze', f], capture_output=True, text=True,
            cwd='example')
        if 'error -' in r.stdout:
            subprocess.run(['git', 'checkout', '--', f])
            print('REVERTED(has error)', f)
        else:
            print('OK', f)
    except Exception as ex:
        subprocess.run(['git', 'checkout', '--', f])
        print('FAIL', f, ex)

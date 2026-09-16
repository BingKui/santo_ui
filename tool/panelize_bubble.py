"""把 bubble_text_example 的 _buildSection 替换为 SantoPanel."""
import re

p = 'example/lib/sample/components/bubble_text/bubble_text_example.dart'
s = open(p).read()

# _buildSection('X', [ ... ])  ->  SantoPanel(title: 'X', child: ...)
pattern = re.compile(
    r"_buildSection\('([^']*)',\s*\[(.*?)\]\)", re.S)


def repl(m):
    title, body = m.group(1), m.group(2).strip('\n')
    inner = body.strip()
    single = ',' not in re.sub(r"'[^']*'", '', inner)  # 粗略判断是否多个子项
    if single and '\n' not in inner.replace(',\n', '\n', 1):
        child = inner.rstrip(',')
        return (f"SantoPanel(\n"
                f"              title: '{title}',\n"
                f"              child: {child},\n"
                f"            )")
    return (f"SantoPanel(\n"
            f"              title: '{title}',\n"
            f"              child: Column(\n"
            f"                crossAxisAlignment: CrossAxisAlignment.start,\n"
            f"                children: [{body}],\n"
            f"              ),\n"
            f"            )")


s = pattern.sub(repl, s)
# 移除面板之间的分隔与标题下方多余间距
s = s.replace('            SizedBox(height: 24),\n', '')
# 移除 _buildSection 辅助方法
m = re.search(r'\n  Widget _buildSection\(String title, List<Widget> children\) \{', s)
if m:
    start = m.start()
    brace = s.index('{', s.index('List<Widget> children)', start))
    depth, i = 0, brace
    while True:
        if s[i] == '{':
            depth += 1
        elif s[i] == '}':
            depth -= 1
            if depth == 0:
                break
        i += 1
    end = i + 1
    while end < len(s) and s[end] == '\n':
        end += 1
    s = s[:start] + s[end:]

open(p, 'w').write(s)
print('panels:', s.count('SantoPanel('))

"""Rounded tabs that fit their decorations and title into Kitty's cell budget."""

from kitty.fast_data_types import Screen, split_into_graphemes, wcswidth
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb


def tail_title(title: str, width: int) -> str:
    """Keep the useful end of a title without splitting a Unicode grapheme."""
    if width <= 0:
        return ""
    # Titles must stay on one line and cannot inject terminal controls.
    title = " ".join(title.split())
    title = "".join(c for c in title if ord(c) >= 32 and not 127 <= ord(c) < 160)
    if wcswidth(title) <= width:
        return title
    suffix = []
    used = 1  # leading ellipsis
    for grapheme in reversed(tuple(split_into_graphemes(title))):
        cells = max(0, wcswidth(grapheme))
        if used + cells > width:
            break
        suffix.append(grapheme)
        used += cells
    return "…" + "".join(reversed(suffix))


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    width = max(0, min(max_tab_length, screen.columns - before))
    if draw_data.max_tab_title_length > 0:
        width = min(width, draw_data.max_tab_title_length)
    if not width:
        return before

    # Reserve the caps and gap before measuring any title text.
    gap = 1 if width >= 4 else 0
    body_width = width - gap - 2
    prefix = f" [{index}] "
    if body_width >= len(prefix) + 2:
        marker = ""
        if tab.needs_attention:
            marker += draw_data.bell_on_tab
        if tab.has_activity_since_last_focus:
            marker += draw_data.tab_activity_symbol
        body = prefix + tail_title(marker + tab.title, body_width - len(prefix) - 1) + " "
    elif body_width >= len(str(index)):
        body = str(index)
    else:
        # At one or two cells there is no room for a complete pill.
        body = "…"

    rounded = width >= 3
    total = wcswidth(body) + (2 if rounded else 0) + gap
    if extra_data.for_layout:
        screen.cursor.x = before + total
        return screen.cursor.x - gap

    fg = as_rgb(draw_data.tab_fg(tab))
    bg = as_rgb(draw_data.tab_bg(tab))
    outer_bg = as_rgb(int(draw_data.default_bg))
    # Some themes give the active tab the same background as the bar.
    # Reverse that pair so the active pill remains visible.
    if tab.is_active and bg == outer_bg:
        fg, bg = bg, fg
    if rounded:
        screen.cursor.fg, screen.cursor.bg = bg, outer_bg
        screen.draw("")
    screen.cursor.fg, screen.cursor.bg = fg, bg
    screen.draw(body)
    if rounded:
        screen.cursor.fg, screen.cursor.bg = bg, outer_bg
        screen.draw("")
    end = screen.cursor.x
    screen.cursor.fg = 0
    screen.cursor.bg = outer_bg
    screen.cursor.bold = screen.cursor.italic = False
    if gap:
        screen.draw(" ")
    return end

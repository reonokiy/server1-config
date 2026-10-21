# English and Chinese font rendering

Configured on 2026-10-22 using per-user Fontconfig aliases. The installed file is `~/.config/fontconfig/conf.d/60-english-chinese.conf` (or beneath `$XDG_CONFIG_HOME`).

| Generic family | English preference | Simplified Chinese fallback |
| --- | --- | --- |
| sans-serif | Noto Sans | Noto Sans CJK SC |
| serif | Noto Serif | Noto Serif CJK SC |
| monospace | DejaVu Sans Mono | Noto Sans Mono CJK SC |

Weak aliases preserve explicitly requested fonts and allow document language to influence regional glyph selection. Taiwan and Hong Kong text can select regional Noto CJK variants. Verified Chinese-character matching selected TC for `zh-tw`, HK for `zh-hk` in sans and monospace, and TC for Hong Kong serif requests on this installation.

GNOME's existing Ubuntu Sans 11 and Ubuntu Sans Mono 11 UI preferences remain unchanged. Chinese-character fallback from those explicitly named fonts was verified to select Noto Sans CJK SC. Applications may implement their own font selection; a particular terminal's wide-character layout still needs visual checking.

## Restore

Run as the normal desktop user from the repository:

```bash
bash scripts/setup-fonts.sh
```

The script installs font dependencies, backs up an existing different copy of this configuration, installs the tracked file, and rebuilds the cache. Restart open applications to load the preferences. This setup does not change the desktop language or force display-specific subpixel rendering.

## Verify

```bash
fc-match 'sans-serif:lang=en:charset=41'
fc-match 'sans-serif:lang=zh-cn:charset=4e2d'
fc-match 'serif:lang=zh-cn:charset=4e2d'
fc-match 'monospace:lang=zh-cn:charset=4e2d'
fc-match 'sans-serif:lang=zh-tw:charset=4e2d'
```

The `charset` constraint matters: a Latin-only monospace font can otherwise match the request without demonstrating Chinese glyph coverage. Visually check mixed text such as `Ubuntu English 中文测试 123，。` in the applications you use.

## Undo

```bash
rm "${XDG_CONFIG_HOME:-$HOME/.config}/fontconfig/conf.d/60-english-chinese.conf"
fc-cache -f
```

If you replaced an older configuration, restore its backup. Fonts can stay installed.

Reference: [Fontconfig configuration and matching](https://fontconfig.pages.freedesktop.org/fontconfig/fontconfig-user.html).

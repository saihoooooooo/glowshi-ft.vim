glowshi-ft.vim
=============

glowshi-ft is glow shift for f/t(F/T).
The basic behavior is the same as f, but when there are multiple letters in same line, you are able to choose position which glow (highlight).

Screencapture
-----

![myimage](misc/screencapture.gif)

Usage
-----

The first keymap in nomal/operator/visual.

Keymap|movement
---|---
f{char}|search {char} to the right of the cursor.
F{char}|search {char} to the left of the cursor.
t{char}|till before f.
T{char}|till after F.

When there are multiple letters in same line.

Keymap|movement
---|---
[count] h|[count] position to left.
[count] l|[count] position to right.
^ or 0|first position.
$|last position.
\<ESC>|cancel moving.
[other key]|choose now position.

customizing
-----------

* g:glowshift_no_default_key_mappings
 * this value is 1 when dont set keymaps.

* g:glowshift_ignorecase
 * ignore case in glowfhi-ft search patterns.
 * default 0

* g:glowshift_t_highlight_exactly
 * highlight in t/T come to the position just before the target letter.
 * default 0

* g:glowshift_selected_hl_ctermfg
 * color in position choosing.
 * default 'Black'

* g:glowshift_selected_hl_ctermbg
 * background color in position choosing.
 * default 'White'

* g:glowshift_selected_hl_guifg
 * color in position choosing (GUI).
 * default '#000000'

* g:glowshift_selected_hl_guibg
 * background color in position choosing (GUI).
 * default '#FFFFFF'

* g:glowshift_candidates_hl_ctermfg
 * color in position of candidates.
 * default 'Black'

* g:glowshift_candidates_hl_ctermbg
 * background color in position of candidates(GUI).
 * default 'Red'

* g:glowshift_candidates_hl_guifg
 * color in position of candidates(GUI).
 * default '#000000'

* g:glowshift_candidates_hl_guibg
 * background color in position of candidates(GUI).
 * default '#FF0000'

Installation
------------

You can install the plugin just copy "plugin" and "autoload" directories under your ~/.vim.

or

* [Pathogen][1]
 * `git clone https://github.com/saihoooooooo/tasmaniandevil ~/.vim/bundle/tasmaniandevil`
* [Vundle][2]
 * `Bundle 'saihoooooooo/glowshi-ft.vim'`
* [NeoBundle][3]
 * `NeoBundle 'saihoooooooo/glowshi-ft.vim'`

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/gmarik/vundle
[3]: https://github.com/Shougo/neobundle.vim

#!/usr/bin/sips -j

/*
 * sipsコマンドを使用してtreeコマンドの結果を画像化するスクリプト
 *
 * ```
 *  sips -j treeToImg.js
 * ```
 */

const filename = 'dirTree.png';

const text = `
.
├── .gitconfig
├── .gitignore
├── README.md
├── bash
│   ├── .bash_profile
│   └── .bashrc
├── brew
│   ├── Brewfile
│   └── README.md
├── code
│   ├── keybindings.json
│   └── settings.json
├── config
│   └── .config
│       ├── afx
│       ├── cheat
│       ├── dlv
│       ├── hub
│       ├── iterm2
│       ├── karabiner
│       ├── multitail
│       ├── mume
│       ├── nvim
│       └── sh
├── deploy.sh
├── etc
│   ├── launchd
│   │   ├── umasoya.brew.upgrade.daily.plist
│   │   └── umasoya.gitomatic.daily.plist
│   └── scripts
│       └── brew_upgrade.sh
├── git
│   ├── .gitconfig
│   └── .gitignore
├── iterm2
│   ├── KeyBindings.itermkeymap
│   └── SolarizedDark.json
├── misc
│   ├── .curlrc
│   ├── .dircolors
│   └── .eslintrc.yml
├── multipass
│   └── init.yml
├── mysql
│   ├── .my.cnf
│   └── .myclirc
├── pt
│   └── .ptconfig.toml
├── removal.sh
├── tmux
│   ├── .tmux
│   │   ├── _init.tmux
│   │   ├── _keybind.tmux
│   │   ├── _pane.tmux
│   │   ├── _status.tmux
│   │   ├── _tpm.tmux
│   │   ├── _variables.tmux
│   │   └── plugins
│   └── .tmux.conf
├── vim
│   ├── .vim
│   │   ├── Makefile
│   │   ├── dein.vim
│   │   ├── doc
│   │   ├── filetype.vim
│   │   ├── ftplugin
│   │   ├── rc
│   │   ├── swap
│   │   ├── syntax
│   │   ├── template
│   │   ├── tmp
│   │   ├── toml
│   │   └── undo
│   └── .vimrc
└── zsh
    ├── .zshenv
    └── .zshrc

40 directories, 38 files
2023/01/06 15:05:03
`;
const rows = text.split("\n");
const len  = rows.length;

// Color
const bg = 'black';
const fg = 'skyblue';

// ヒラギノ角ゴシック W2
const fontFamily = 'HiraginoSans-W1';
const fontSize   = 24; // px

// 書き込みの初期位置
const x = fontSize / 2;
const y = 0;

/*
 * canvasサイズ
 * 横は固定値、縦は自動計算
 * 行間を設定しないと微妙に上下で重なることがある
 */
const margin = 5;
const width  = 800;
const height = fontSize * len + (margin * (len - 1));

const canvas = new Canvas(width, height);
// 背景色で全体を塗り潰し
canvas.filllStyle = bg;
canvas.fillRect(0, 0, canvas.width, canvas.height);

// フォント等の設定
canvas.font = `${fontSize}px ${fontFamily}`;
canvas.textAlign = 'start';
canvas.textBaseline = 'middle';
canvas.fillStyle = fg;

/*
 * canvasでは改行は自動で出来ないので
 * Y軸方向の位置を計算して自前で行う
 */
for (var i = 0; len > i; i++) {
  let row      = rows[i];
  let interval = fontSize;

  // 2行目以降のY軸方向の位置を計算
  i && (interval += fontSize * i + (margin * (i - 1)));

  canvas.fillText(row, x, y + interval);

  // 一応コンソールに出力する
  console.log(`${x}, ${y + interval}, ${row}`);
}

const output = new Output(canvas, filename);
output.addToQueue();

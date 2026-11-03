{ pkgs }:
let
  enhancd = pkgs.stdenvNoCC.mkDerivation {
    pname = "enhancd";
    version = "2.5.1";
    src = pkgs.fetchFromGitHub {
      owner = "babarot";
      repo = "enhancd";
      rev = "b911969f32c69402954da97d84b549303638cb1f";
      hash = "sha256-kaintLXSfLH7zdLtcoZfVNobCJCap0S/Ldq85wd3krI=";
    };
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/enhancd"
      cp -R init.sh VERSION config.ltsv src functions "$out/share/enhancd/"
      runHook postInstall
    '';
  };
in
with pkgs; [
  bashInteractive
  curl
  git
  gh
  ghq
  vim
  zsh
  enhancd
  zsh-fast-syntax-highlighting
  pure-prompt
  direnv
  fzf
  jq
  ripgrep
  fd
  eza
  shellcheck
  shfmt
  docker-client
  codex
  claude-code
  herdr
]

# Linux config

My Ubuntu/Debian base Linux config for comfort and effective work.

## What I use

There are several main packages:
  * i3wm - to create windows layout;
  * tmux - to maintain several terminal sessions;
  * zsh - as default shell;
  * picom - compositor to make non-active windows transparent;
  * git-credential-manager - to simplify git auth;
  * vscode - to edit;
  * btop - to monitor your system;
  * speedtest-cli - to monitor your network;
  * ShareClipbrd - if you use VM to copy and paste from host to VM and vice-versa.

## How to use

Run `my-config.sh` script with specified git info:
```bash
$ GIT_USERNAME="IlorDash" GIT_EMAIL="ilordash02@gmail.com" ./my-config.sh
```

> **_NOTE:_** If you are using Linux in VM, add `USE_VM=""` to variable list.

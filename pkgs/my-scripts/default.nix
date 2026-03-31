{ pkgs, ... }:

pkgs.runCommand "my-scripts" { } ''
  mkdir -p $out/bin
  cp -r ${../../scripts}/* $out/bin/
  chmod +x $out/bin/*
''

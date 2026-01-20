{
  pkgs ? import <nixpkgs> {},
  lib,
  SattyPackage ? pkgs.satty,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "hyprquickshot";
  version = "0.1.0";

  nativeBuildInputs = with pkgs; [
    makeWrapper
    kdePackages.wrapQtAppsHook
  ];
  buildInputs = with pkgs; [
    quickshell
    grim
    imagemagick
    wl-clipboard
    kdePackages.kirigami
    kdePackages.kirigami-addons
  ];

  src = pkgs.lib.cleanSource ./.;

  installPhase = ''
    mkdir -p $out/bin

    mv icons shaders src shell.qml $out

    echo "#!/usr/bin/env sh" > $out/bin/hyprquickshot
    echo "quickshell -p $out" >> $out/bin/hyprquickshot
    chmod +x $out/bin/hyprquickshot

    wrapProgram $out/bin/hyprquickshot \
      --set PATH "$PATH:${lib.makeBinPath [
      pkgs.quickshell
      pkgs.grim
      pkgs.imagemagick
      pkgs.wl-clipboard
      pkgs.kdePackages.kirigami
      pkgs.kdePackages.kirigami-addons
      ''${SattyPackage}''
    ]}"
  '';
}

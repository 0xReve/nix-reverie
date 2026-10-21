# Packaging of sgtaziz/lian-li-linux (upstream v1.2.2), adapted from
# github:SChimera/lian-li-linux-nix:
# - npm lockfile (no bun.lock)
# - evdi is dlopen'd (no link-time libevdi)
#
# Exposed as pkgs.lianli-linux via overlays.nix (unstable.callPackage).
# Version/hashes: versions.json.
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cmake,
  clang,
  nasm,
  nodejs,
  cacert,
  makeWrapper,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,
  coreutils,
  runtimeShell,
  libusb1,
  ffmpeg,
  fontconfig,
  libjpeg_turbo,
  libdrm,
  webkitgtk_4_1,
  gtk3,
  glib,
  libsoup_3,
  librsvg,
  libayatana-appindicator,
  libxkbcommon,
  wayland,
  libinput,
  libGL,
}:
let
  # Single bump surface — keep src/cargo/node hash churn out of this file.
  versions = lib.importJSON ./versions.json;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lianli-linux";
  inherit (versions) version;

  src = fetchFromGitHub {
    owner = "sgtaziz";
    repo = "lian-li-linux";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = versions.hash;
  };

  cargoHash = versions.cargoHash;

  # Upstream lockfile lacks many "resolved" URLs; prefetch full node_modules.
  nodeModules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      nodejs
      cacert
      writableTmpDirAsHomeHook
    ];
    dontConfigure = true;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    buildPhase = ''
      runHook preBuild
      cd crates/lianli-gui
      npm ci --no-audit --no-fund
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = versions.nodeModulesHash;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    clang
    nasm
    nodejs
    makeWrapper
    wrapGAppsHook3
    writableTmpDirAsHomeHook
    rustPlatform.bindgenHook
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    libusb1
    ffmpeg
    fontconfig
    libjpeg_turbo
    libdrm
    webkitgtk_4_1
    gtk3
    glib
    libsoup_3
    librsvg
    libxkbcommon
    wayland
    libinput
    libGL
  ];

  env.TURBOJPEG_SOURCE = "pkg-config";

  postPatch = ''
    rm -f rust-toolchain.toml

    substituteInPlace packaging/udev/60-lianli.rules \
      --replace-fail ', RUN{builtin}+="uaccess"' ''' \
      --replace-fail '/bin/sh' '${runtimeShell}' \
      --replace-fail 'exec chmod' 'exec ${coreutils}/bin/chmod'
  '';

  preBuild = ''
    cp -R ${finalAttrs.nodeModules}/node_modules crates/lianli-gui/node_modules
    chmod -R u+w crates/lianli-gui/node_modules
    patchShebangs --build crates/lianli-gui/node_modules
    (
      cd crates/lianli-gui
      # Avoid broken .bin shebangs after the FOD copy (same trick as SChimera).
      node node_modules/vite/bin/vite.js build
      node scripts/stamp-build.mjs
    )
  '';

  doCheck = false;

  postInstall = ''
    rm -f $out/bin/bind_tool $out/bin/render-preview

    install -Dm644 packaging/udev/60-lianli.rules \
      $out/lib/udev/rules.d/60-lianli.rules

    # Shared flock targets the daemon refuses to start without.
    install -Dm644 packaging/tmpfiles.d/lianli.conf \
      $out/lib/tmpfiles.d/lianli.conf

    install -Dm644 packaging/systemd/lianli-daemon.service \
      $out/lib/systemd/user/lianli-daemon.service
    substituteInPlace $out/lib/systemd/user/lianli-daemon.service \
      --replace-fail /usr/bin/lianli-daemon $out/bin/lianli-daemon

    install -Dm644 packaging/desktop/com.sgtaziz.lianlilinux.desktop \
      $out/share/applications/com.sgtaziz.lianlilinux.desktop
    install -Dm644 assets/icons/32x32.png \
      $out/share/icons/hicolor/32x32/apps/com.sgtaziz.lianlilinux.png
    install -Dm644 assets/icons/128x128.png \
      $out/share/icons/hicolor/128x128/apps/com.sgtaziz.lianlilinux.png
    install -Dm644 "assets/icons/128x128@2x.png" \
      $out/share/icons/hicolor/256x256/apps/com.sgtaziz.lianlilinux.png
    install -Dm644 assets/icons/icon.svg \
      $out/share/icons/hicolor/scalable/apps/com.sgtaziz.lianlilinux.svg
  '';

  # WebKitGTK + NVIDIA Wayland: opening Naive UI dropdowns/popovers crashes
  # WebKitWebProcess in Skia/GPU path (SIGSEGV/SIGABRT). Prefer disabling
  # NVIDIA explicit sync so DMABUF stays accelerated; fall back composition
  # disable only if needed. See https://v2.tauri.app/develop/debug/linux-graphics/
  postFixup = ''
    wrapProgram $out/bin/lianli-gui \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}" \
      --set __NV_DISABLE_EXPLICIT_SYNC 1 \
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1
  '';

  meta = {
    description = "Open-source L-Connect 3 replacement for Lian Li fans, AIO, RGB, and LCD";
    homepage = "https://github.com/sgtaziz/lian-li-linux";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "lianli-gui";
  };
})

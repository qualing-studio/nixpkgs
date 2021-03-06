{ stdenv, fetchFromGitHub, meson, pkgconfig, ninja
, wayland, wlroots, gtkmm3, libinput, libsigcxx, jsoncpp, fmt
, traySupport  ? true,  libdbusmenu-gtk3
, pulseSupport ? false, libpulseaudio
, nlSupport    ? true,  libnl
, udevSupport  ? true,  udev
, swaySupport  ? true,  sway
, mpdSupport   ? true,  mpd_clientlib
}:
  stdenv.mkDerivation rec {
    name = "waybar-${version}";
    version = "0.6.1";

    src = fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = version;
      sha256 = "1hzwqg22sjiirx6743512271p3jlakrw0155av1phrv5b7p3ws8a";
    };

    nativeBuildInputs = [
      meson ninja pkgconfig
    ];

    buildInputs = with stdenv.lib;
      [ wayland wlroots gtkmm3 libinput libsigcxx jsoncpp fmt ]
      ++ optional  traySupport  libdbusmenu-gtk3
      ++ optional  pulseSupport libpulseaudio
      ++ optional  nlSupport    libnl
      ++ optional  udevSupport  udev
      ++ optional  swaySupport  sway
      ++ optional  mpdSupport   mpd_clientlib;

    mesonFlags = [
      "-Ddbusmenu-gtk=${ if traySupport then "enabled" else "disabled" }"
      "-Dpulseaudio=${ if pulseSupport then "enabled" else "disabled" }"
      "-Dlibnl=${ if nlSupport then "enabled" else "disabled" }"
      "-Dlibudev=${ if udevSupport then "enabled" else "disabled" }"
      "-Dmpd=${ if mpdSupport then "enabled" else "disabled" }"
      "-Dout=${placeholder "out"}"
    ];

    meta = with stdenv.lib; {
      description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
      license = licenses.mit;
      maintainers = with maintainers; [ FlorianFranzen minijackson ];
      platforms = platforms.unix;
    };
  }

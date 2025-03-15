self: super:
let
  policies = {
    DisableAppUpdate = true;
  };

  policiesJson = super.pkgs.writeText "firefox-policies.json" (builtins.toJSON { inherit policies; });

  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  firefoxPackage = edition:
    super.stdenv.mkDerivation rec {
      inherit (sources."${edition}") version;
      pname = "Firefox";

      buildInputs = [ super.pkgs.undmg ];
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        runHook preInstall

        appDir="Applications/Firefox.app"

        mkdir -p $out/Applications
        cp -r Firefox*.app "$out/$appDir"

        libDir="$out/$appDir/Contents/Resources"

        mkdir -p "$libDir/distribution"
        POL_PATH="$libDir/distribution/policies.json"
        rm -f "$POL_PATH"
        ln -s ${policiesJson} "$POL_PATH"

        runHook postInstall
      '';

      src = super.fetchurl {
        name = "Firefox-${version}.dmg";
        inherit (sources."${edition}") url sha256;
      };

      meta = {
        description = "Mozilla Firefox, free web browser (binary package)";
        homepage = "http://www.mozilla.com/en-US/firefox/";
      };
    };

  floorpPackage = edition:
    super.stdenv.mkDerivation rec {
      inherit (sources."${edition}") version;
      pname = "Floorp";
  
      buildInputs = [ super.pkgs._7zz ];
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
  
      unpackPhase = ''
        runHook preUnpack
        7zz x "$src" -o"$sourceRoot"
        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall

        appDir="Applications/Floorp.app"

        mkdir -p $out/Applications
        cp -r Floorp.app "$out/$appDir"

        libDir="$out/$appDir/Contents/Resources"

        mkdir -p "$libDir/distribution"
        POL_PATH="$libDir/distribution/policies.json"
        rm -f "$POL_PATH"
        ln -s ${policiesJson} "$POL_PATH"

        runHook postInstall
      '';

      src = super.fetchurl {
        name = "Floorp-${version}.dmg";
        inherit (sources."${edition}") url sha256;
      };
  
      meta = {
        description = "Floorp is a new Firefox based browser from Japan with excellent privacy & flexibility.";
        homepage = "https://floorp.app/en";
      };
    };

  librewolfPackage = edition:
    super.stdenv.mkDerivation rec {
      inherit (sources."${edition}") version;
      pname = "Librewolf";

      buildInputs = [ super.pkgs.undmg ];
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        runHook preInstall

        appDir="Applications/LibreWolf.app"

        mkdir -p $out/Applications
        cp -r LibreWolf.app "$out/$appDir"

        libDir="$out/$appDir/Contents/Resources"

        mkdir -p "$libDir/distribution"
        POL_PATH="$libDir/distribution/policies.json"
        rm -f "$POL_PATH"
        ln -s ${policiesJson} "$POL_PATH"

        runHook postInstall
      '';

      src = super.fetchurl {
        name = "Librewolf-${version}.dmg";
        inherit (sources."${edition}") url sha256;
      };

      meta = {
        description = "Mozilla Firefox, free web browser (binary package)";
        homepage = "http://www.mozilla.com/en-US/firefox/";
      };
    };

  zenPackage = edition:
    super.stdenv.mkDerivation rec {
      inherit (sources."${edition}") version;
      pname = "Zen";

      buildInputs = [ super.pkgs.undmg ];
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        runHook preInstall

        appDir="Applications/Zen.app"

        mkdir -p $out/Applications
        cp -r "Zen.app" "$out/$appDir"

        libDir="$out/$appDir/Contents/Resources"

        mkdir -p "$libDir/distribution"
        POL_PATH="$libDir/distribution/policies.json"
        rm -f "$POL_PATH"
        ln -s ${policiesJson} "$POL_PATH"

        runHook postInstall
      '';

      src = super.fetchurl {
        name = "Zen-${version}.dmg";
        inherit (sources."${edition}") url sha256;
      };

      meta = {
        description = "Firefox based browser with a focus on privacy and customization.";
        homepage = "https://zen-browser.app/";
      };
    };
in {
  firefox-bin = firefoxPackage "firefox";
  firefox-beta-bin = firefoxPackage "firefox-beta";
  firefox-devedition-bin = firefoxPackage "firefox-devedition";
  firefox-esr-bin = firefoxPackage "firefox-esr";
  firefox-nightly-bin = firefoxPackage "firefox-nightly";
  librewolf = if super.pkgs.system == "x86_64-darwin" then librewolfPackage "librewolf-x86_64" else librewolfPackage "librewolf-arm64";
  zen-bin = zenPackage "zen";
}

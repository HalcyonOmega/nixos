final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    kfinal: kprev:
    let
      version = "6.6.90";
      mkSource = name: sha256:
        (final.fetchurl {
          url = "mirror://kde/unstable/plasma/${version}/${name}-${version}.tar.xz";
          inherit sha256;
        })
        // {
          inherit version;
        };
    in
    {
      spectacle = kprev.spectacle.overrideAttrs (_oldAttrs: {
        patches = [ ];
      });

      krdp = kprev.krdp.overrideAttrs (oldAttrs: {
        extraBuildInputs = (oldAttrs.extraBuildInputs or [ ]) ++ [
          kfinal.kirigami-addons
        ];
        extraPropagatedBuildInputs = (oldAttrs.extraPropagatedBuildInputs or [ ]) ++ [
          kfinal.kirigami-addons
        ];
        preConfigure = (oldAttrs.preConfigure or "") + ''
          export NIXPKGS_QML_SEARCH_PATHS="${kfinal.kirigami-addons}/lib/qt-6/qml''${NIXPKGS_QML_SEARCH_PATHS:+:$NIXPKGS_QML_SEARCH_PATHS}"
        '';
      });

      kwin = kprev.kwin.overrideAttrs (oldAttrs: {
        patches = [
          ./patches/kwin-6.6.90-qpa-allow-nixos-wrapper.patch
        ] ++ builtins.tail oldAttrs.patches;
      });

      kscreen = kprev.kscreen.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
          kfinal.kitemmodels
          kfinal.plasma5support
        ];
      });

      kdeplasma-addons = kprev.kdeplasma-addons.overrideAttrs (oldAttrs: {
        cargoRoot = "kdeds/kameleon/qmk/kameleon-qmk-helper";
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit (oldAttrs) src;
          sourceRoot = "kdeplasma-addons-${version}/kdeds/kameleon/qmk/kameleon-qmk-helper";
          hash = "sha256-2gtz9D05VloEKkQGF9/0fuMrFUtp2NpE/mcEd7D3Gkc=";
        };
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
          final.corrosion
          final.udev
        ];
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
          final.cargo
          final.corrosion
          final.pkg-config
          final.rustc
          final.rustPlatform.cargoSetupHook
        ];
      });

      kinfocenter = kprev.kinfocenter.overrideAttrs (oldAttrs: {
        prePatch = (oldAttrs.prePatch or "") + ''
          sed -i '/QLocale().measurementSystem()/,+4c\        m_outputContext = new CommandOutputContext(u"sensors"_s, {}, parent);' kcms/sensors/main.cpp
        '';
        postPatch = (oldAttrs.postPatch or "") + ''
          sed -i '/m_outputContext = new CommandOutputContext/c\        if (QLocale().measurementSystem() == QLocale::ImperialUSSystem) {\n            m_outputContext = new CommandOutputContext(u"${final.lib.getExe' final.lm_sensors "sensors"}"_s, {u"-f"_s}, parent);\n        } else {\n            m_outputContext = new CommandOutputContext(u"${final.lib.getExe' final.lm_sensors "sensors"}"_s, {}, parent);\n        }' kcms/sensors/main.cpp
        '';
      });

      plasma-nm = kprev.plasma-nm.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
          kfinal.qtkeychain
        ];
      });

      plasma-desktop = kprev.plasma-desktop.overrideAttrs (oldAttrs: {
        patches = builtins.filter (
          patch:
          !(final.lib.hasSuffix "hwclock-path.patch" (baseNameOf (toString patch)))
          && baseNameOf (toString patch) != "tzdir.patch"
        ) oldAttrs.patches;
      });

      plasma-keyboard = kprev.plasma-keyboard.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
          kfinal.libplasma
        ];
      });

      plasma-workspace = kprev.plasma-workspace.overrideAttrs (oldAttrs: {
        patches = [
          ./patches/plasma-workspace-6.6.90-dependency-paths.patch
        ] ++ builtins.tail oldAttrs.patches;
      });

      plasma-login-manager = kprev.plasma-login-manager.overrideAttrs (oldAttrs: {
        patches = builtins.filter (
          patch: baseNameOf (toString patch) != "config-mtime.patch"
        ) oldAttrs.patches;
      });

      powerdevil = kprev.powerdevil.overrideAttrs (oldAttrs: {
        patches = builtins.filter (
          patch: baseNameOf (toString patch) != "rb-batterymonitor.patch"
        ) oldAttrs.patches;
      });

      sources = kprev.sources // {
        aurorae = mkSource "aurorae" "0ac86c2c745eb137bb281bebdd0ad9912629c132e152233de1716442132fd534";
        bluedevil = mkSource "bluedevil" "14580a635c3184db50749ab90e1efdf539fd8029d4f07c27420db1b0eec1b69e";
        breeze = mkSource "breeze" "c944ae8e419d3ff91b7ce68e7af273209693dd21b981495d39633fd09c78e1ae";
        breeze-grub = mkSource "breeze-grub" "aa25681be55892a91520ba581fc01ec16d0bce723ded0f7d7d7686f80f51acaf";
        breeze-gtk = mkSource "breeze-gtk" "feb61dac6cc5755a388e49bac686cf7dc7f2f64e91fe78a099930b401cf62852";
        breeze-plymouth = mkSource "breeze-plymouth" "0dff5a816294fbacb6be387dea406f8b51fc9b8b45ef76fc64fbe54205bebbc4";
        discover = mkSource "discover" "4e55063a9fbed1225d244926a7329167da9f1a31bd5abb9787ef42e23dff1be3";
        drkonqi = mkSource "drkonqi" "3ca2453c19e9b57edc5d1e3db89b1e57e894a1896fc1b962cdfb26895eda5f7b";
        flatpak-kcm = mkSource "flatpak-kcm" "a450d7e04b7c29488d111c13aa75bc5b58eb1f804587a8ed07ff27104f9478cc";
        kactivitymanagerd = mkSource "kactivitymanagerd" "8c1f0421d0ee17c50cce09e1caedc20eea065f46dd2677d9d91b5bdacfccc761";
        kde-cli-tools = mkSource "kde-cli-tools" "8491c65062be59291d4970a992951735b84058371032f2c6b5319e59d024225e";
        kde-gtk-config = mkSource "kde-gtk-config" "5a0f422de1c7e3d64e9f4805bccb582ad45faf6b1915bfe37bcc41c080209607";
        kdecoration = mkSource "kdecoration" "e7a4dd7964cf993909384646a1dd58c5d3037043483e17997b380f76a0c5c70e";
        kdeplasma-addons = mkSource "kdeplasma-addons" "b2cadf7b96306b9f4ea68486130b3bf291312d7a3ece0d6ffef4be095f7761ec";
        kgamma = mkSource "kgamma" "6a5fca21a2f2d03b757bd4b4be92d599ea6af6a981a5887c42d18d7df7a968d8";
        kglobalacceld = mkSource "kglobalacceld" "71b7d798d04dd9566479b1d215711abdce08d01c309e15062b84d797d2055f8b";
        kinfocenter = mkSource "kinfocenter" "d131dde3a75dbf7e6e1b4d08ddca81c6735f7b6d6785f00521d88c2c5dd759ab";
        kmenuedit = mkSource "kmenuedit" "8eb6e2480303e7f2f19af15d9c6ecacab79cb2ab03f593b4e689a2605e3732e4";
        knighttime = mkSource "knighttime" "f3a1a31f924f5526403a4e1e286d898bdbd5a85257f9cc3ef41e39890b28067d";
        kpipewire = mkSource "kpipewire" "8b16c375498feec20e098e07f524711eb87b44eae50e576c0ff63c188a26f061";
        krdp = mkSource "krdp" "b29e41bad3827efe0549881404c02dd6f3fb2c5a89f1707cf9c5e738d08f73d1";
        kscreen = mkSource "kscreen" "01fcd592cf9aeb002166e8c6b64cf155f54fbccb9fb7a6288738f6c2fd4746cb";
        kscreenlocker = mkSource "kscreenlocker" "76a2f210c320c72cbc2f47dd3997938a48e2e850f0199778e9e562b6031d6c6c";
        ksshaskpass = mkSource "ksshaskpass" "290ec1f991b9c450c1f21d6abbe519edb1b52c13d3ee00abf27d7fd4573eb93a";
        ksystemstats = mkSource "ksystemstats" "ff130b07d7203e65e5484469fbda80c97635e135fec4b6e818d5eb69f564fb5c";
        kwallet-pam = mkSource "kwallet-pam" "5654ee0892f61b25d33a6aa743a1095675f6d5453c1624f92936a99140eeb767";
        kwayland = mkSource "kwayland" "aa64f58baefedcb4f5ae4bd70665c8fff6586f91013fca0c7d0eba1ce7e873e2";
        kwayland-integration = mkSource "kwayland-integration" "35a92ce2d29141026963325fd2240c64b0523d6823764d697a851c7bd348dc0e";
        kwin = mkSource "kwin" "7af8d8e6c565e0506a227bd1fa6b073bbc552b1f89448e084891808fbf561b14";
        kwin-x11 = mkSource "kwin-x11" "d66e44aaf7022aa312daeff98d9cc01f4af87a9ca4ed7ddb5cb83991fdc2ec51";
        kwrited = mkSource "kwrited" "3cb902987f0d691a27939e422814cb96a43e4cbb5c8cfa76e62d9e4be75ef6b1";
        layer-shell-qt = mkSource "layer-shell-qt" "769cea5e407e5fb4e1e932d1b6f3c8017da71f541f7d7c680b3f13da9d51f32b";
        libkscreen = mkSource "libkscreen" "475d1c89464c1b953f1b22895d3f5de4af076fefd3e6e6a3f28ec2d0c69c9f60";
        libksysguard = mkSource "libksysguard" "fecc9b3d313ece04ad0c21726469fc24a456b8c7a8c39d7d6b22a3fb13497568";
        libplasma = mkSource "libplasma" "92b4441cd34b5980349503ea3d20b1ce0c87906579fdcad29208b58388197a85";
        milou = mkSource "milou" "9151f4b2011fb2b99b8fd71881028d4d4da0839a0fab154d892a235a833b9e83";
        ocean-sound-theme = mkSource "ocean-sound-theme" "29b35830aa31c243c5514852572b2b77085ef1da5ffbe000b9cbb74c66df69ba";
        oxygen = mkSource "oxygen" "bbc363cd5c6c1b0b9254f53f73ddd49e50d9cbc55936a8a50c53a69ee152ce96";
        oxygen-sounds = mkSource "oxygen-sounds" "9a8cded4f8fff47b2c0aed3259a27b140ee3fdb87dd2fac806d84b324dc96c8a";
        plasma-activities = mkSource "plasma-activities" "170c5a09cffd7c4f97b78baa7c19a9a2c2dcf4036e8627069b1625a6d819eeb6";
        plasma-activities-stats = mkSource "plasma-activities-stats" "e97352b6e8c733f306ccfb2db62097ffa606f8f0f18e9394ed47b4da3fbfb531";
        plasma-bigscreen = mkSource "plasma-bigscreen" "66616e8d75f2f17d9daca642652645a7f7d4dec04ab3bd9d52ca37ee51ec5cbc";
        plasma-browser-integration = mkSource "plasma-browser-integration" "58b7948792cc4b77362e3cf732744553167ccbebf9d9333b4fad0fa3ae5da70b";
        plasma-desktop = mkSource "plasma-desktop" "1616c6b2cef60b8c4ba5b7340dbe0ab31a5c740fdb4f4b0c2fefc330743cf1d2";
        plasma-dialer = mkSource "plasma-dialer" "fc78ac61a35f0b9be7663831094049e94a801b934dd87d6d9ca175a34a325754";
        plasma-disks = mkSource "plasma-disks" "bc74dc08476b5e8d2f43f6506037bc54e86386e11f2a959a0bd3fd257b331ff7";
        plasma-firewall = mkSource "plasma-firewall" "b23d6d127413ccba0e27fc988d74e856bbda5ae418278de385d5c3e3d9f8a8cf";
        plasma-integration = mkSource "plasma-integration" "64648dbc91121c8b51c951db30775f32ccfd4182d7b0027cd6f7fbfee385e6ca";
        plasma-keyboard = mkSource "plasma-keyboard" "c8b9fad238d922ef05ddb5452b328c8f365a91fd5c04ca9b7e918df43b00cc5c";
        plasma-login-manager = mkSource "plasma-login-manager" "8a8ceede4b7907d5f6b86f4e69f30a03ad3391e355514a356438fd685cfac998";
        plasma-mobile = mkSource "plasma-mobile" "5ecd99161e69789be6fd32a9be20e7a151c890134dca63dcd4247f1b455e9642";
        plasma-nano = mkSource "plasma-nano" "63d96cfd5b2b5f99e7d9989c614e332363dd32a07e6523f29337c4d5326a4a99";
        plasma-nm = mkSource "plasma-nm" "1ee59d994b0f6b9d2fa1c4dd5588f96cc33470462dda9f11d519834b5b6226fd";
        plasma-pa = mkSource "plasma-pa" "f93684f5d882c8457ac79a3e515f0aef9dea27aa1e297ed316ba9c00cd9f5218";
        plasma-sdk = mkSource "plasma-sdk" "1a18ef08b2e3b1d4ab09ce6788a54fcc0f560da9698961166d7c5106903bc0b0";
        plasma-setup = mkSource "plasma-setup" "d0bd185d0ecfcf94fc476d94a661e5ecc4c241aa93998d45eb2e6d1ce30480b7";
        plasma-systemmonitor = mkSource "plasma-systemmonitor" "2bd37c08b7e426af0631ad42d868fdbb2ce6ed9c0e99226dff2b00abb947ee6d";
        plasma-thunderbolt = mkSource "plasma-thunderbolt" "d52a00beeae3a8cd8396da1fc4fb241e86541ecfefb3700e7b1e356f58602c84";
        plasma-vault = mkSource "plasma-vault" "14e65d67bc390dadf95ef6bddf609b1259481b75e1723afae76182d375b73ea7";
        plasma-welcome = mkSource "plasma-welcome" "dd7dc9f8af3302f8b0d6d259717bf4feb012b8b8b3fdb6544e1ef8579bc6440a";
        plasma-workspace = mkSource "plasma-workspace" "dbec8e31850abfbadb4f0c5e0712c46a325c0f4c8519012d22fc98446b7c47ec";
        plasma-workspace-wallpapers = mkSource "plasma-workspace-wallpapers" "cce0f2b7e622477f7bce0f8dbcfd74f2d3aa55b2986782e1eab5022520677302";
        plasma5support = mkSource "plasma5support" "acf8501dd7bd3e972c01c7948c60aa670be64ddcb582101162574b5eb2981559";
        plymouth-kcm = mkSource "plymouth-kcm" "0b608f5d0c881f14ff43eecc1287d91668e853c948d92f4198de55f990d7e024";
        polkit-kde-agent-1 = mkSource "polkit-kde-agent-1" "083a1d13b906d27fc791f889969d04e7cad3efe1e2810d8135665dbcb0cd3259";
        powerdevil = mkSource "powerdevil" "88b8c3d7bf896a27dcb4ddc9aa788bdba5b68a0555f9458a4a97fc55c1a4afc8";
        print-manager = mkSource "print-manager" "23eb59f99c66bf1c2c9709f3ed4e058185ed776e9321f2b185498d9c2c26f99b";
        qqc2-breeze-style = mkSource "qqc2-breeze-style" "b7e4e46db089f1f8d83663cfe876cd80e331c99a665c3841f2a53e26284c5637";
        sddm-kcm = mkSource "sddm-kcm" "c02d3d870bf9996ae1b43aa50dfe3ffe6fb7e9b71e01a8260ca2c9db4453eb11";
        spacebar = mkSource "spacebar" "7e449f3b923419b898b1aee8e84f7c18aade39851fc102f94333cba295377d33";
        spectacle = mkSource "spectacle" "0dd3726a39bff204725021e843f249eb480f76938474f761a258b511e91dd83d";
        systemsettings = mkSource "systemsettings" "7b5b989c512315eb9882cb886001c219fb287555cf50376a68ebe088d088dc8a";
        union = mkSource "union" "72e40f51eee291fca2d6588f0aa8786e36f16e03624c346c44c4173aaf0a921e";
        wacomtablet = mkSource "wacomtablet" "bc2626be146f7566b6e028c423905babe725ca65ffb25360b61e5c2d2f18997d";
        xdg-desktop-portal-kde = mkSource "xdg-desktop-portal-kde" "98ba160360c06b10d46d766e13046501112ce43ae053cb46137932d6671fbd46";
      };
    }
  );
}

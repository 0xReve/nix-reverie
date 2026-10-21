# Onboard MediaTek MT7927 / Filogic 380 (PCI 14c3:7927).
# Mainline mt7925e with ASPM off; BT firmware path for in-tree btmtk.
{ inputs, ... }:
{
  flake.modules.nixos.mt7927 =
    { pkgs, ... }:
    let
      # cmspam ships BT under mediatek/mt6639/; btmtk loads mediatek/mt7927/.
      mt7927Firmware = inputs.mt7927.packages.${pkgs.stdenv.hostPlatform.system}.firmware;

      btFirmwarePathFix = pkgs.runCommand "mediatek-mt7927-bt-firmware-path" { } ''
        mkdir -p "$out/lib/firmware/mediatek/mt7927"
        cp ${mt7927Firmware}/lib/firmware/mediatek/mt6639/BT_RAM_CODE_MT6639_2_1_hdr.bin \
          "$out/lib/firmware/mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin"
      '';
    in
    {
      # Load-time ASPM; udev covers the PCI link after bind.
      boot.extraModprobeConfig = ''
        options mt7925e disable_aspm=1
      '';

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x14c3", ATTR{device}=="0x7927", ATTR{link/l1_aspm}="0"
      '';

      hardware.firmware = [ btFirmwarePathFix ];
    };
}

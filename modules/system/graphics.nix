# Hardware-accelerated graphics (OpenGL / Vulkan).
{
  flake.modules.nixos.graphics = {
    hardware.graphics.enable = true;
  };
}

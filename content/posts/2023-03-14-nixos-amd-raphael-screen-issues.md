---
title: "NixOS + AMD Raphael iGPU: Fix for white/flashing screens and a guide for graphical installation"
slug: "nixos-amd-raphael-igpu-screen-issues"
date: 2023-03-14
summary: "How to fix white or flashing screens in NixOS when using the iGPU of an AMD Ryzen 7000 series CPU (Raphael)."
images:
  - images/nixos-amd/nixos-amd-feature-image.png
tags:
  - NixOS
  - AMD
  - Linux
---

This post has a tl;dr section just for the necessary changes to fix the screen issues, a short write-up of my experience, with some additional links for further information and at the end you'll find a condensed guide for the graphical installation process.

## tl;dr

To fix the white or flashing screen issue, add the following lines to your `configuration.nix` file:

```bash
boot.kernelPackages = pkgs.linuxPackages_latest;
boot.kernelParams = ["amdgpu.sg_display=0"];
```

Well, at least that worked for me.  
Tested with LightDM + XFCE, SDDM + KDE Plasma, GDM + GNOME.

## My experience

A week ago I built a new desktop PC including an AMD Ryzen 7950x. For the time being I use its iGPU to run my 32" 4k monitor (LG 32BN67U-B) via HDMI.

At the time of writing this post, the current NixOS version is 22.11, which comes with the 5.15.97 Linux kernel. Support for the iGPU of the new AMD Ryzen 7000 series CPUs (Raphael) comes with a later version of the kernel. Therefore, the issues aren't specific to NixOS, but affect any Linux distribution that comes with a kernel that is too old.

To use the latest kernel in NixOS I added `boot.kernelPackages = pkgs.linuxPackages_latest;` to the `configuration.nix` file.

Without any changes I booted straight to tty after the installation. With the latest kernel I was able to boot into LightDM and log into XFCE. Unfortunately, after rebooting, XFCE was flashing at my native resolution of 3840x2160. Reducing the resolution to 2560x1440 stopped the flashing.

With SDDM + KDE Plasma and GDM + GNOME, I wasn't even able to see the display manager and was greeted with a white screen and my cursor.

That means the latest kernel fixes only half the problem. After I tried a quick installation of Arch and experienced the exact same issues, I did some research and stumbled upon this issue on the GitLab instance of freedesktop.org: [Flickering or constant solid white screen with kernel >=6.1.4](https://gitlab.freedesktop.org/drm/amd/-/issues/2354)

In the comments, [user yswtrue suggested](https://gitlab.freedesktop.org/drm/amd/-/issues/2354#note_1765479) to use the kernel parameter `amdgpu.sg_display=0`. Searching for this parameter I found [this post on Phoronix](https://www.phoronix.com/news/AMD-Scatter-Gather-Re-Enabled), which references said GitLab issue and gives further background information on the problem.

So, adding `boot.kernelParams = ["amdgpu.sg_display=0"]` to `configuration.nix` also fixed the problem with a flashing screen in XFCE and the white screen in SDDM + KDE Plasma and GDM + Gnome.

I'm really looking forward to using NixOS. I love the idea of the declarative approach, which already made this whole troubleshooting and experimenting process so much more comfortable for me.

## Installation guide

1. Pick the second option with `nomodeset` to get the installer up and running
2. Follow the installation process and reboot at the end
3. After the reboot you'll be booted straight into tty
4. Login with your user
5. Open the configuration file, e.g. `sudo nano ../../etc/nixos/configuration.nix`
6. Add the following lines:
   ```bash
   boot.kernelPackages = pkgs.linuxPackages_latest;
   boot.kernelParams = ["amdgpu.sg_display=0"];
   ```
7. Rebuild with `sudo nixos-rebuild switch` and reboot after it's finished
8. Pick the newest generation
9. Now you should be able to boot into your display manager and log into your desktop environment

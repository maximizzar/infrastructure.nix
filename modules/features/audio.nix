# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  flake.nixosModules.audio = { lib, pkgs, ... }: {
    services.pulseaudio.enable = lib.mkDefault false;
    security.rtkit.enable = lib.mkDefault true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      configPackages = [ pkgs.deepfilternet ];
      extraLadspaPackages = [ pkgs.deepfilternet ];

      extraConfig = {
        pipewire = {
          "90-defaults" = {
            "context.properties" = {
              "clock.power-of-two-quantum" = true;
              "core.daemon" = true;
              "core.name" = "pipewire-0";
              "link.max-buffers" = 16;
              "settings.check-quantum" = true;

              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [
                44100
                48000
                88200
                96000
                192000
              ];
              "default.clock.quantum" = 256;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 4096;
            };
            "stream.properties" = {
              "resample.quality" = 10;
            };
          };

          "90-disable-bell" = {
            "context.properties" = {
              "module.x11.bell" = false;
            };
          };
        };

        pipewire-pulse = {
          "90-defaults" = {
            "context.spa-libs" = {
              "audio.convert.*" = "audioconvert/libspa-audioconvert";
              "support.*" = "support/libspa-support";
            };

            "stream.properties" = {
              "resample.quality" = 10;
            };

            "pulse.properties" = {
              "server.address" = [ "unix:native" ];
            };
          };
        };

        pipewire."99-input-denoising" = {
          "context.modules" = [
            {
              "name" = "libpipewire-module-filter-chain";
              "args" = {
                "node.description" = "DeepFilter Noise Cancelling Source";
                "media.name" = "DeepFilter Noise Cancelling Source";
                "filter.graph" = {
                  "nodes" = [
                    {
                      "type" = "ladspa";
                      "name" = "DeepFilter Mono";
                      "plugin" = "libdeep_filter_ladspa";
                      "label" = "deep_filter_mono";
                      "control" = {
                        "Attenuation Limit (dB)" = 100;
                      };
                    }
                  ];
                };
                "audio.rate" = 48000;
                "capture.props" = {
                  "node.name" = "deep_filter_mono_input";
                  "node.passive" = true;
                };
                "playback.props" = {
                  "node.name" = "deep_filter_mono_output";
                  "media.class" = "Audio/Source";
                };
              };
            }
          ];
        };
      };

    };

  };
}

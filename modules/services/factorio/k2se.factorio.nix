# SPDX-FileCopyrightText: 2026 maximizzar <mail@maximizzar.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ config, pkgs, lib, ... }

{
  services.factorio = {
    description = "maximizzar's K2Se v1.100 Server.";
    enable = true;
    game-name = "K2Se Factorio";
    lan = false;
    loadLatestSave = true;

    package = {
      pkgs.factorio-headless.overrideAttrs (old: {
        version = "1.1.110";
      };
    };

    mods = [
      "base",
      "aai-containers",
      "aai-industry",
      "aai-loaders",
      "aai-signal-transmission",
      "aai-vehicles-ironclad",
      "AbandonedRuins",
      "AbandonedRuins-Krastorio2",
      "Advanced-Electric-Revamped-v16",
      "alien-biomes",
      "alien-biomes-hr-terrain",
      "AutoDeconstruct",
      "bobinserters",
      "bullet-trails",
      "camedo-snapmine",
      "CleanedConcrete",
      "combat-mechanics-overhaul",
      "Concretexture",
      "CursorEnhancements",
      "EditorExtensions",
      "equipment-gantry",
      "even-distribution",
      "fast_trans",
      "fireproof-bots",
      "flib",
      "GhostWarnings",
      "grappling-gun",
      "InfiniteTech",
      "informatron",
      "inventory-repair",
      "jetpack",
      "Krastorio2",
      "Krastorio2Assets",
      "LightedPolesPlus",
      "LogisticRequestManager",
      "Milestones",
      "missing-circuit",
      "ModuleInserterSimplified",
      "OreEraser",
      "PipeVisualizer",
      "qol_research",
      "QueueToFrontNG",
      "RateCalculator",
      "RecipeBook",
      "reverse-factory",
      "robot_attrition",
      "rocket-log",
      "se-portable-booster-tank",
      "shield-projector",
      "show-max-underground-distance",
      "simhelper",
      "solar-calc",
      "space-exploration",
      "space-exploration-graphics",
      "space-exploration-graphics-2",
      "space-exploration-graphics-3",
      "space-exploration-graphics-4",
      "space-exploration-graphics-5",
      "space-exploration-menu-simulations",
      "space-exploration-official-modpack",
      "space-exploration-postprocess",
      "Squeak Through",
      "StatsGui",
      "stdlib",
      "textplates",
      "void",
      "Waterfill_v17"
    ];

    nonBlockingSaving = true;
    openFirewall = true;
    saveName = "world";
    stateDirName = "factorio/k2se";
    username = "maximizzar";
  };
}

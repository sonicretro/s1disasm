{
  description = "Sonic 1 disassembly";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
      ];
      forAllSystems = lib.genAttrs systems;

      systemToToolsDir = {
        "x86_64-linux" = "Linux-x86_64";
        "aarch64-linux" = "Linux-aarch64";
        "i686-linux" = "Linux-x86";
      };

      src = builtins.path {
        path = ./.;
        name = "s1disasm-source";
        filter =
          path: type:
          let
            parentDir = builtins.baseNameOf (builtins.dirOf path);
            dirName = builtins.baseNameOf path;
          in
          !(parentDir == "build_tools" && type == "directory" && dirName != "lua");
      };

      # repo ships prebuilt ELF binaries for `asl` and `p2bin` dynamically linked
      # against /lib64/ld-linux-x86-64.so.2; needs to use the Nix glibc loader.
      patchedBuildTools =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          toolDir = systemToToolsDir.${system};
        in
        pkgs.runCommand "patched-build-tools"
          {
            nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          }
          ''
            mkdir -p $out/${toolDir}
            cp ${./build_tools}/${toolDir}/asl         $out/${toolDir}/asl
            cp ${./build_tools}/${toolDir}/p2bin       $out/${toolDir}/p2bin
            chmod +w $out/${toolDir}/*
            autoPatchelf $out/${toolDir}
          '';

      buildROM =
        system: script: outputName:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.stdenv.mkDerivation {
          name = outputName;
          inherit src;
          nativeBuildInputs = [ pkgs.lua5_4 ];
          buildPhase = ''
            export BUILD_TOOLS_DIR=${patchedBuildTools system}
            lua ${script}
          '';
          installPhase = ''
            install -Dm644 ${outputName}.bin $out/${outputName}.bin
          '';
        };
    in
    {
      packages = forAllSystems (system: {
        s1-rom = buildROM system "build.lua" "s1built";
        default = self.packages.${system}.s1-rom;
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.lua5_4
            ];
            shellHook = ''
              export BUILD_TOOLS_DIR=${patchedBuildTools system}
            '';
          };
        }
      );
    };
}

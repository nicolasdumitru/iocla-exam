{
  description = "IOCLA";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pwndbg.url = "github:pwndbg/pwndbg";
  };
  outputs =
    {
      nixpkgs,
      pwndbg,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      ida-free-unwrapped = pkgs.ida-free.overrideAttrs (finalAttrs: _: {
        version = "9.3sp1";
        src = pkgs.requireFile {
          name = "ida-free-pc_${pkgs.lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}_x64linux.run";
          url = "https://my.hex-rays.com/dashboard/download-center/installers/release/${finalAttrs.version}/ida-free";
          hash = "sha256-6fyW1ToWBK9BEBA9bVjduHl2TSqqzfKG17MmkjhynsM=";
        };
      });
      ida-free = pkgs.symlinkJoin {
        name = "${ida-free-unwrapped.name}-jemalloc";
        paths = [ ida-free-unwrapped ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/ida \
            --set LD_PRELOAD ${pkgs.jemalloc}/lib/libjemalloc.so
        '';
      };
    in
    {
      # Need multistdenv for 32 bit support; clang
      devShell."${system}" = pkgs.mkShell.override { stdenv = pkgs.gccMultiStdenv; } {
        # devShell."${system}" = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
        # devShell."${system}" = pkgs.mkShell.override { stdenv = pkgs.multiStdenv; } {
        packages = with pkgs; [
          # WARNING: Do NOT add gcc, clang, gligc, libcxx, etc.
          # They will break the environment, leading to compilation or LSP errors.

          clang-tools
          meson
          ninja

          nasm
          nasmfmt
          gnumake

          gdb
          pwndbg.packages."${system}".default
          valgrind
          # Note: Objdump is packaged with the GCC/Clang toolchain
          # If necessary, try adding binutils.
          # binutils

          ida-free
          jdk25

          file

          (python3.withPackages (
            ps: with ps; [
              python-lsp-server
            ]
          ))
          pyrefly
          black

          nil
          nixd
          nixfmt
          nixfmt-tree

          bc
        ];
      };
    };
}

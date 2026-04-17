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
      pkgs = nixpkgs.legacyPackages."${system}";
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

          ghidra
          jdk25

          file

          (python3.withPackages (
            ps: with ps; [
              python-lsp-server
            ]
          ))
          pyright
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

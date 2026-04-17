{
  description = "IOCLA";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."${system}";
    in
    {
      devShell."${system}" = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
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
          valgrind

          # ghidra

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

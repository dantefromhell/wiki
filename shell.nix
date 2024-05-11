{
  mkShellNoCC,
  nixfmt-rfc-style,
  ...
}:
mkShellNoCC {
  packages = [
    nixfmt-rfc-style
  ];
}

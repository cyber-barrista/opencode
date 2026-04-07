# Pins bun to the version declared in package.json.
# When bumping bun, update the hashes in hashes.json.
{
  bun,
  fetchurl,
  bunVersion,
}:
let
  hashes = (builtins.fromJSON (builtins.readFile ./hashes.json)).bun;
  urls = {
    "aarch64-darwin" = {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${bunVersion}/bun-darwin-aarch64.zip";
      hash = hashes."aarch64-darwin";
    };
    "aarch64-linux" = {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${bunVersion}/bun-linux-aarch64.zip";
      hash = hashes."aarch64-linux";
    };
    "x86_64-darwin" = {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${bunVersion}/bun-darwin-x64-baseline.zip";
      hash = hashes."x86_64-darwin";
    };
    "x86_64-linux" = {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${bunVersion}/bun-linux-x64.zip";
      hash = hashes."x86_64-linux";
    };
  };
in
bun.overrideAttrs (old: {
  version = bunVersion;
  src = fetchurl urls.${bun.stdenv.hostPlatform.system};
  passthru = old.passthru // {
    sources = builtins.mapAttrs (_: fetchurl) urls;
  };
})

class Dv4lua < Formula
  desc "a lua-based command line tool that provides abstract user (device) interoperability"
  homepage "https://blog.101248.xyz/zh/dv4lua/"
  version "0.1.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/km0e/dv4lua/releases/download/v0.1.6/dv4lua-aarch64-apple-darwin.tar.xz"
    sha256 "094ae8e05d28536afed82f1d66d78a6b90e3a75f450b97439a6fb3f8af967907"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/km0e/dv4lua/releases/download/v0.1.6/dv4lua-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e6424fbf8b01bb6b08661c5eada85555dd60420a2652c041a5b05ad3bf44dd19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/km0e/dv4lua/releases/download/v0.1.6/dv4lua-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c4b28d67fbbb7de3f2ff8ab2cb71c464409b9a683d3fa289a4ad1a6d092ef44"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dv4lua" if OS.mac? && Hardware::CPU.arm?
    bin.install "dv4lua" if OS.linux? && Hardware::CPU.arm?
    bin.install "dv4lua" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

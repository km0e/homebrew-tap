class Dv4lua < Formula
  desc "a lua-based command line tool that provides abstract user (device) interoperability"
  homepage "https://blog.101248.xyz/zh/dv4lua/"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/km0e/dv4lua/releases/download/v0.1.2/dv4lua-aarch64-apple-darwin.tar.xz"
    sha256 "3dda7fd2f11f64e8421569ebd3f18a543ac4de23fed30edf98a6376adc4c4244"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/km0e/dv4lua/releases/download/v0.1.2/dv4lua-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a468d3f1e6f156f707491f2cb0f21922da9309d5578be364fffb35abc733b795"
    end
    if Hardware::CPU.intel?
      url "https://github.com/km0e/dv4lua/releases/download/v0.1.2/dv4lua-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "68057565080f43de4d9843eeaef2c2e6da558d23c9dd6a5af1101137d7dea1a8"
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

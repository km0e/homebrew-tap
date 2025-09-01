class Dv4lua < Formula
  desc "a lua-based command line tool that provides abstract user (device) interoperability"
  homepage "https://blog.101248.xyz/zh/dv4lua/"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/km0e/dv4lua/releases/download/v0.1.4/dv4lua-aarch64-apple-darwin.tar.xz"
    sha256 "9c79267a585281157fcc13927c1a89c8cc0c6047c6e559ba19c0b6150855db4b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/km0e/dv4lua/releases/download/v0.1.4/dv4lua-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d0d787e8bbdd06a7418324702c5a5eb76409f249f97dcf691ad9ee0d43ecf918"
    end
    if Hardware::CPU.intel?
      url "https://github.com/km0e/dv4lua/releases/download/v0.1.4/dv4lua-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dd5ec280e0a89074a95bc75ab7eca71dc85f9608cb6019eb8a17e5bc846cec15"
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

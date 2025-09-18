class Dv4lua < Formula
  desc "a lua-based command line tool that provides abstract user (device) interoperability"
  homepage "https://blog.101248.xyz/dv4lua/"
  version "0.1.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/km0e/dv4lua/releases/download/v0.1.7/dv4lua-aarch64-apple-darwin.tar.xz"
    sha256 "db3ce1b2b76d626c45eb96a77bde6171bc1e57e8f2ca9e75e7c199b7b377221a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/km0e/dv4lua/releases/download/v0.1.7/dv4lua-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "786246e58e02ae8872a29b17e6b664c753c44d74c6b95bab329ac27448c3fe25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/km0e/dv4lua/releases/download/v0.1.7/dv4lua-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb695e35b0107e88202770c926617ca693be2bec16ca2ee1695fd5bfb025287d"
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

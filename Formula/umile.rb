class Umile < Formula
  desc "a command-line tool for merging and converting music files"
  homepage "https://github.com/km0e/umile.git"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/km0e/umile/releases/download/v0.1.0/umile-aarch64-apple-darwin.tar.xz"
      sha256 "4538bfa6a3b4e72c0a45b73c8e787f037ef3af49ca68af01e7b569ecfb86a026"
    end
    if Hardware::CPU.intel?
      url "https://github.com/km0e/umile/releases/download/v0.1.0/umile-x86_64-apple-darwin.tar.xz"
      sha256 "72d4d4d95c0519f1aafde75a61f899d66af4ad5e3afbe943689ce58f077bed87"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/km0e/umile/releases/download/v0.1.0/umile-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "59abcdaef213f4a2e7a80819aa705853a23e7ad5af7e55b8696017b5a9276ab1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/km0e/umile/releases/download/v0.1.0/umile-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "32ac18c300a6faa1fd06fabab4b3da8fd3402c3527ac260036c3957ad594f9ac"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
    bin.install "umile" if OS.mac? && Hardware::CPU.arm?
    bin.install "umile" if OS.mac? && Hardware::CPU.intel?
    bin.install "umile" if OS.linux? && Hardware::CPU.arm?
    bin.install "umile" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

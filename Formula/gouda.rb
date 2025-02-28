class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1740749968"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1740749968/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "1eb804ff6142b13f73ff23ca9c7a395ec112231d846b12b91f85fc843a051baa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1740749968/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "d1afd07150f4ab7fb66b429d37e2bd11c9d0cc24218c0b937cdba4515eb96329"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1740749968/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "142e4d0c7d234249c5e03a4140a757ea45f955d28cd603204a2caf169113bff7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1740749968/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "61f6c0f550a511a03f81fc0b3f350267b6c64cd759e6f801c1aaa44b48dbc92e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "gouda" if OS.mac? && Hardware::CPU.arm?
    bin.install "gouda" if OS.mac? && Hardware::CPU.intel?
    bin.install "gouda" if OS.linux? && Hardware::CPU.arm?
    bin.install "gouda" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

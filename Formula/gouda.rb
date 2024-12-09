class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1733756488"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1733756488/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "044d5410acfd682b8a9e74e435d5675ec5048a582bf67fb59cd0a5d745f217fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1733756488/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "796fb6508792fa0053f9da43ae7b8b8cb8b79d231a7ee3f92c09e61188019a47"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1733756488/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ca2f50347c75379d795787adca698ecb5ad3fbdc3343a9d30fa1d774ef70fb5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1733756488/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a1002f51b0488cc151e01995aad5758d761200d706752cf48958710161ec3108"
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

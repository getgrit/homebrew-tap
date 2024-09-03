class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1725391111"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725391111/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "13436aafc9f4fc1577760f7fca73caf44124315de6b977bfbaeb458f2093d499"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725391111/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "e9246c0c8b239f57c657acde08af3b5f97e71fbf8fb581a877be13e97be80042"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725391111/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "06a4b3ff36ae93b6f92263b85be02e72a80bf7c78afad1ee58c802003eaf9dfa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725391111/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "673e079f3b27c525b94bcb7b083ca9c1d8fe7af2e4c977c85d512a3649307f32"
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

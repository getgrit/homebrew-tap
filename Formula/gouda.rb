class Gouda < Formula
  desc "The server cli for grit"
  homepage "https://docs.grit.io"
  version "0.1.0-alpha.1723691536"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723691536/gouda-aarch64-apple-darwin.tar.gz"
      sha256 "c38d4bad4dcbb2a1c959860a4f66636667d76284a835f234eed7b80aaa4d79a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723691536/gouda-x86_64-apple-darwin.tar.gz"
      sha256 "571e71aadee8be93d8cad9347a23d5ed612f5b653414a0aa2222677bb4368bf2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723691536/gouda-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9f4cce71f8070754b1f81eb7ad0d943f4f3bcc15dfe8570190821f8c63ad1d1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723691536/gouda-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "de7a4d1991681204278a1f63f9fd95720e031af3fef1ba1e7d306a8708cbe2ad"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-unknown-linux-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gouda"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gouda"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gouda"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gouda"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

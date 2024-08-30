class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1724988485"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724988485/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "7a2622bca917c047c6d6a0dcef0742f8223c0f13823fb4d53d424a752e6a0d6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724988485/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "adf1639bdfca4a5254c1163980f9dcb413c5b58aedfdf36ed594c19f856c265f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1724988485/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "1033d28ae8d18525c5fe734cead1d283e76f1af3fc13b3ad676c7aa232054cf1"
  end
  license "UNLICENSED"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "workflow-runner" if OS.mac? && Hardware::CPU.arm?
    bin.install "workflow-runner" if OS.mac? && Hardware::CPU.intel?
    bin.install "workflow-runner" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

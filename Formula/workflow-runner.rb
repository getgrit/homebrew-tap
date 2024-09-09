class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1725862236"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725862236/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "c68872d06c8dcdbb16c33cc417a75927c93dc536ef9361cb1c4a6a5bc42b1bc4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725862236/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "ddec9a2a4ee949bc820dc244aae52e59a8ad1d16a63c5358dbdc691b03d430f4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725862236/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "e43918f08d904bfbcaf58438f70501a2625e00a5e30f86b39bb491d8705cb086"
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

class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1738053820"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1738053820/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "9feb953eacfe12b3f574c0f6b77ca73f238da7b1dbc717c4ff00d0fb2a2dd584"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1738053820/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "e04a2e6f906cb28453f6430155e79dc1f9417e8031796bc29844142461a5454f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1738053820/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "23951505686db3a00693a39c3e0001c3a1dd6443df19303f34df3c9705c190d7"
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

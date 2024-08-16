class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1723765810"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723765810/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "a6e09df0c8a687a03273009aa5a063605bb7be2c20df5d86f3f51d27e6d50857"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723765810/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "b456b0fbd12465c08a35ba9764a465ea8bd0736e859e17cfe86de741b07d05c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723765810/workflow-runner-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "28e0c969cfd4397bae06645998c81b649ac51e222c54abc1aad0dbc6792b6cf8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723765810/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3af5855a2737e68aa7ce103c68fc8df80e307287ac669f00018a16d535d86457"
    end
  end
  license "UNLICENSED"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-unknown-linux-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "workflow-runner"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "workflow-runner"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "workflow-runner"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "workflow-runner"
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

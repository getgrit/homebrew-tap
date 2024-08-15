class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1723707346"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723707346/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "e4e75abb0f0755867dc255dd47fa8ea64743dddd8f41618160d8b3385f5fb57a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723707346/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "b16f6f1c830b9b6347f2f62d497c3e515d9ad91db0e1597da8daaf80c781e366"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723707346/workflow-runner-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "93fa2c754942261c0dad4b97d3b907fd1893d2a7fe73782d39ac59a24d21cc35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1723707346/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ef1c34b59a89809f7554383281a96b49c4bea861efd3b6867fef4139f766529e"
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

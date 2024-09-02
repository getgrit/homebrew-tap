class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1725234130"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725234130/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "d15bf793ad6e98f3ea91fc568e2ba9c4f2e111c6d29b9dbba264c4015d9fc620"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725234130/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "b294a4c594b11ca4210cc07b3e15aeae5aa27d65280cd363de8b8d32d7700965"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1725234130/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "cc6656d6bf504d0dd4164aaa4365acb371d58c7d47613b295a6551b4cc24f6eb"
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

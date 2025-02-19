class WorkflowRunner < Formula
  desc "This is the CLI-based workflow executor for Grit."
  homepage "https://docs.grit.io/language/overview"
  version "0.1.0-alpha.1739997027"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1739997027/workflow-runner-aarch64-apple-darwin.tar.gz"
      sha256 "e6d6d66b126a9ce4c49e6e321743c9fe8ee707059c57a6082a072afa2186e239"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1739997027/workflow-runner-x86_64-apple-darwin.tar.gz"
      sha256 "362939526091d361cbecd652a38cc85b307da0a4e96506905047fc4b865ec0a0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getgrit/gritql/releases/download/v0.1.0-alpha.1739997027/workflow-runner-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "c615c237b38346cf579d28b9ea96f3114378ffb911d7002d637ce3b844bbc8e7"
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

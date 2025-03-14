function install_node() {
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
	asdf install nodejs latest
	asdf set -u nodejs latest
}
function install_ruby() {
	asdf plugin add ruby
	install_ruby_dependencies
	RUBY_CONFIGURE_OPTS="--disable-install-doc" asdf install ruby latest
	asdf set -u ruby latest
}
function install_ruby_dependencies() {
	if is_mac; then
		brew install openssl@3 readline libyaml gmp autoconf
	else
		sudo apt -y install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
	fi
}
function install_python() {
	asdf plugin add python
	install_python_dependencies
	asdf install python latest
	asdf set -u python latest
}
function install_python_dependencies() {
	if is_mac; then
		brew install openssl readline sqlite3 xz zlib tcl-tk@8 libb2
	else
		sudo apt -y install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	fi
}
function install_java() {
	asdf plugin add java
	asdf install java latest
	asdf set -u java latest
}
function install_rust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
}
function install_sdkman() {
	curl -s 'https://get.sdkman.io?rcupdate=false' | bash
}
function install_go() {
	local os
	os=$(get_goos)
	local arch
	arch=$(get_goarch)
	local version
	version=$(get_latest_goversion)
	local file
	file="${version}.${os}-${arch}.tar.gz"
	local url
	url="https://golang.org/dl/${file}"
	curl -L -o /tmp/${file} ${url}
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf /tmp/${file}
	rm /tmp/${file}
}
function get_goos() {
	local os
	os=$(uname -s | tr '[:upper:]' '[:lower:]')
	echo $os
}
function get_goarch() {
	local arch
	arch=$(uname -m)
	if [ "$arch" = "x86_64" ]; then
		arch="amd64"
	fi
	echo $arch
}
function get_latest_goversion() {
	curl -s 'https://go.dev/dl/?mode=json' | jq -r '.[0].version'
}
function is_mac() {
	if [ "$(uname)" = "Darwin" ]; then
		return 0
	else
		return 1
	fi
}

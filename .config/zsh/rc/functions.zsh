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
	# failed to install poetry with python latest
	asdf install python 3.13.1
	asdf set -u python 3.13.1
}
function install_python_dependencies() {
	if is_mac; then
		brew install openssl readline sqlite3 xz zlib tcl-tk@8 libb2
	else
		sudo apt -y install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	fi
}
function install_poetry() {
	curl -sSL https://install.python-poetry.org | python3 -
	"${HOME}/.local/bin/poetry" config virtualenvs.in-project true
}
function install_rust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
}
function install_sdkman() {
	curl -s 'https://get.sdkman.io?rcupdate=false' | bash
	source "${HOME}/.sdkman/bin/sdkman-init.sh"
}
function install_java() {
	sdk install java
}
function install_gradle() {
	sdk install gradle
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
function install_docker() {
	if is_mac; then
		brew install --cask docker
	else
		# https://docs.docker.com/engine/install/ubuntu/
		sudo apt-get update
		sudo apt-get install ca-certificates curl
		sudo install -m 0755 -d /etc/apt/keyrings
		sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
		sudo chmod a+r /etc/apt/keyrings/docker.asc
		echo \
			"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
			sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
		sudo apt-get update
		sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	fi
}
function install_terraform() {
	asdf plugin add terraform https://github.com/asdf-community/asdf-hashicorp.git
	asdf install terraform latest
	asdf set -u terraform latest
}
function install_awscli() {
	asdf plugin add awscli
	asdf install awscli latest
	asdf set -u awscli latest
}

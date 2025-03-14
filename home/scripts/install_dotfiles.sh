#!/usr/bin/env bash
set -eu

echo_task() {
	printf "\033[0;34m--> %s\033[0m\n" "$@"
}

error() {
	printf "\033[0;31m%s\033[0m\n" "$*" >&2
	exit 1
}

get_default_branch() {
	local path=$1
	git -C "${path}" remote show origin | grep 'HEAD branch' | cut -d' ' -f5
}

git_clean() {
	local path
	path=$(realpath "${1}")
	local branch
	branch=$(get_default_branch "${path}")
	echo_task "Cleaning ${path} with branch ${branch}"
	local git="git -C ${path}"
	$git checkout "${branch}"
	$git fetch origin "${branch}"
	$git reset --hard FETCH_HEAD
	$git clean -fdx
}

DOTFILES_USER=${DOTFILES_USER:-olebo}
DOTFILES_REPO="https://github.com/$DOTFILES_USER/dotfiles"
DOTFILES_BRANCH=${DOTFILES_BRANCH:-main}
DOTFILES_DIR="${HOME}/.dotfiles"

if [ ! "$(command -v git)" ]; then
	error "Git does not seems to be installed"
fi

if [ -d "${DOTFILES_DIR}" ]; then
	git_clean "${DOTFILES_DIR}"
else
	echo_task "Cloning ${DOTFILES_REPO} on branch ${DOTFILES_BRANCH} to ${DOTFILES_DIR}"
	git clone -b "${DOTFILES_BRANCH}" "${DOTFILES_REPO}" "${DOTFILES_DIR}"
fi

INSTALL_BIN="${DOTFILES_DIR}/install"
echo_task "Running ${INSTALL_BIN}"
exec ${INSTALL_BIN}

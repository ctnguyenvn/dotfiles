#!/usr/bin/bash

#===============================================================================
# check and install some tools for sublime text plugins
#===============================================================================

ERROR=$'\e[1;31m'
WARNING=$'\e[1;33m'
SUCCESS=$'\e[1;32m'
NORMAL=$'\e[0m'
SUDO_USER="${SUDO_USER:-${USER}}"

## check privileges
if [[ $EUID -ne 0 ]]; then
	printf "${ERROR}[x] ${NORMAL}%s\n" "This script must be run as root"
	exit -1
fi

## Check sublime text 3 installed #############
if [[ -x "$(command -v subl3)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "Sublime text: $(subl3 --version)"
elif [[ -x "$(command -v subl)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "Sublime text: $(subl --version)"
else
	printf "${ERROR}[x] ${NORMAL}%s\n" "Sublime text is not installed"
	printf "${WARNING}==> Installing Sublime text ${NORMAL}\n"

	sudo -u $SUDO_USER yay -S sublime-text-3 --noconfirm
	install_status=$?
	if [[ $install_status -ne 0 ]]; then
		printf "${ERROR}[x] ${NORMAL}%s\n" "Install sublime text failed"
		exit -1
	else
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "Sublime text 3 has been installed successfully"
	fi

fi

## download Package control ####################
PKFILE="/home/$SUDO_USER/.config/sublime-text-3/Installed Packages/Package Control.sublime-package"
if [[ -f "$PKFILE" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "Package Control installed"
else
	wget "https://packagecontrol.io/Package%20Control.sublime-package" -P "/home/$SUDO_USER/.config/sublime-text-3/Installed Packages/"
	download_status=$?

	if [[ $download_status -ne 0 ]]; then
		printf "${ERROR}[x] ${NORMAL}%s\n" "Download Package Control failed"
		printf "${WARNING}==> ${NORMAL}%s\n" "Please open: Tools -> Install Package Control"
		sleep 3
	else
		sudo chown -R $SUDO_USER:$SUDO_USER "/home/$SUDO_USER/.config/sublime-text-3"
	fi
fi

## install tools for plugins ##################
# nodejs for SublimeLinter plugin
if [[ -x "$(command -v node)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "nodejs: $(node --version)"
else
	printf "${ERROR}[x] ${NORMAL}%s\n" "Nodejs is not installed"
	printf "${WARNING}==> Installing node ${NORMAL}\n"

	sudo pacman -S nodejs --noconfirm
	install_status=$?
	if [[ $install_status -ne 0 ]]; then
		printf "${ERROR}[x] %s${NORMAL}\n" "Install Nodejs Failed..."
	else
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install Nodejs successfully..."
	fi
fi

# shfmt for pretty shell plugin
if [[ -x "$(command -v shfmt)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "shfmt: $(shfmt --version)"
else
	printf "${ERROR}[x] ${NORMAL}%s\n" "shfmt is not installed"
	printf "${WARNING}==> Installing shfmt ${NORMAL}\n"

	sudo pacman -S shfmt --noconfirm
	install_status=$?
	if [[ $install_status -ne 0 ]]; then
		printf "${ERROR}[x] %s${NORMAL}\n" "Install shfmt Failed..."
	else
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install shfmt successfully..."
	fi
fi

# php-codescniffer (package on arch AUR include phpcs and phpcbf) for phpcs plugin
# gpg --keyserver keys.gnupg.net --recv-keys 31C7E470E2138192
# gpg --keyserver pool.sks-keyservers.net --recv-keys A972B9ABB95D0B760B51442231C7E470E2138192
if [[ -x "$(command -v phpcs)" ]] || [[ -x "$(command -v phpcbf)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "phpcs: $(phpcs --version)"
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "phpcbf: $(phpcbf --version)"
else
	#gpg --keyserver keys.gnupg.net --recv-keys 31C7E470E2138192
	sudo -u $SUDO_USER gpg --keyserver pool.sks-keyservers.net --recv-keys A972B9ABB95D0B760B51442231C7E470E2138192
	addkey_status=$?
	if [[ $addkey_status -ne 0 ]]; then
		printf "${WARNING}==> %s${NORMAL}\n" "add key failed"
	else
		printf "${SUCCESS}=> ${NORMAL}%s\n" "add key successfully"
		printf "${ERROR}[x] ${NORMAL}%s\n" "php-codescniffer is not installed"
		printf "${WARNING}==> Installing php-codescniffer (Include phpcs and phpcbf) ${NORMAL}\n"

		sudo -u $SUDO_USER yay -S php-codesniffer --noconfirm
		install_status=$?
		if [[ $install_status -ne 0 ]]; then
			printf "${ERROR}[x] %s${NORMAL}\n" "Install php-codesniffer Failed..."
		else
			printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install php-codesniffer successfully..."
		fi
	fi
fi

# phpmd for phpcs plugin
if [[ -x "$(command -v phpmd)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "phpmd: $(phpmd --version)"
else
	printf "${ERROR}[x] ${NORMAL}%s\n" "phpmd is not installed"
	printf "${WARNING}==> Installing phpmd ${NORMAL}\n"

	sudo -u $SUDO_USER yay -S phpmd --noconfirm
	install_status=$?
	if [[ $install_status -ne 0 ]]; then
		printf "${ERROR}[x] %s${NORMAL}\n" "Install phpmd Failed..."
	else
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install phpmd successfully..."
	fi
fi

# php-cs-fixer for phpcs plugin
if [[ -x "$(command -v php-cs-fixer)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "php-cs-fixer: $(php-cs-fixer --version)"
else
	printf "${ERROR}[x] ${NORMAL}%s\n" "php-cs-fixer is not installed"
	printf "${WARNING}==> Installing php-cs-fixer ${NORMAL}\n"

	# sudo -u $SUDO_USER yay -S php-cs-fixer --noconfirm
	# install_status=$?
	# if [[ $install_status -ne 0 ]]; then
	# 	printf "${ERROR}[x] ${NORMAL}%s\n" "Install php-cs-fixer Failed..."
	# else
	# 	printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install php-cs-fixer successfully..."
	# fi
	wget https://cs.symfony.com/download/php-cs-fixer-v2.phar -O php-cs-fixer
	download_status=$?

	if [[ $download_status -ne 0 ]]; then
		printf "${ERROR}[x] %s${NORMAL}\n" "Download php-cs-fixer failed"
		sleep 3
	else
		sudo chmod a+x php-cs-fixer
		sudo mv -v "php-cs-fixer" "/usr/local/bin/php-cs-fixer"
	fi
fi

# eslint for sublimeLinter-eslint
if [[ -x "$(command -v npm)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "npm: $(npm --version)"
	if [[ -x $(command -v eslint) ]]; then
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "$(eslint --version)"

	else
		printf "${ERROR}[x] ${NORMAL}%s\n" "eslint is not installed"
		printf "${WARNING}==> Installing eslint ${NORMAL}\n"

		npm install eslint -g
		install_status=$?
		if [[ $install_status -ne 0 ]]; then
			printf "${ERROR}[x] %s${NORMAL}\n" "Install eslint Failed..."
		else
			printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install eslint successfully..."
		fi
	fi
else
	printf "${WARNING}==> Installing npm ${NORMAL}\n"

	sudo pacman -S npm --noconfirm
	install_status=$?

	if [[ $install_status -ne 0 ]]; then
		printf "${ERROR}[x] %s${NORMAL}\n" "Install npm Failed..."
	else
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install npm successfully..."
		if [[ $(npm list | grep -c "eslint") -ne 0 ]]; then
			printf "${SUCCESS}[+] ${NORMAL}%s\n" "eslint: $(eslint --version)"
		else
			printf "${ERROR}[x] ${NORMAL}%s\n" "eslint is not installed"
			printf "${WARNING}==> Installing eslint ${NORMAL}\n"

			npm install eslint -g
			install_status=$?
			if [[ $install_status -ne 0 ]]; then
				printf "${ERROR}[x] %s${NORMAL}\n" "Install eslint Failed..."
			else
				printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install eslint successfully..."
			fi
		fi
	fi
fi

# python-pylint for anaconda
if [[ -x "$(command -v pip)" ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "pip: $(pip --version)"
	if [[ "$(pip list | grep -c "pylint")" -ne 0 ]]; then
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "$(pip show pylint)"
	else
		printf "${ERROR}[x] ${NORMAL}%s\n" "pylint is not installed"
		printf "${WARNING}==> Installing pylint ${NORMAL}\n"

		pip install pylint
		install_status=$?

		if [[ $install_status -ne 0 ]]; then
			printf "${ERROR}[x] %s${NORMAL}\n" "Install pylint Failed..."
		else
			printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install pylint successfully..."
		fi
	fi
else
	printf "${WARNING}==> Installing python-pip ${NORMAL}\n"

	sudo pacman -S python-pip --noconfirm
	install_status=$?
	if [[ $install_status -ne 0 ]]; then
		printf "${ERROR}[x] %s${NORMAL}\n" "Install python-pip Failed..."
	else
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install python-pip successfully..."
		if [[ $(pip list | grep -c "pylint") -ne 0 ]]; then
			printf "${SUCCESS}[+] ${NORMAL}%s\n" "$(pip show pylint | grep -iE "name|version")"
		else
			printf "${ERROR}[x] ${NORMAL}%s\n" "pylint is not installed"
			printf "${WARNING}==> Installing pylint ${NORMAL}\n"

			pip install pylint
			install_status=$?

			if [[ $install_status -ne 0 ]]; then
				printf "${ERROR}[x] %s${NORMAL}\n" "Install pylint Failed..."
			else
				printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install pylint successfully..."
			fi
		fi
	fi
fi

# autopep8 for anaconda
if [[ -x $(command -v autopep8) ]]; then
	printf "${SUCCESS}[+] ${NORMAL}%s\n" "autopep8: $(autopep8 --version)"
else
	printf "${WARNING}==> Installing autopep8 ${NORMAL}\n"

	sudo pacman -S autopep8 --noconfirm
	install_status=$?

	if [[ $install_status -ne 0 ]]; then
		printf "${ERROR}[x] %s${NORMAL}\n" "Install autopep8 Failed..."
	else
		printf "${SUCCESS}[+] ${NORMAL}%s\n" "Install autopep8 successfully..."
	fi
fi

echo """
|=====================================================================================
|	----------- WARNING -----------                                                  |
|=====================================================================================
| 1. Please Open Sublime Text 

| 2. Install Setting Sync Plugin 

| 3. Restart Sublime Text and Press Ctrl+Shift+P -> Sync Setting: Edit User Settings

| 4. Add json with "gist_id": "9cf1d36df1ae4046fc17e78eb50a51d6",

| 5. Press Ctrl+Shift+P -> Sync Setting: Download

| Waiting and Enjoy....
=======================================================================================
"""

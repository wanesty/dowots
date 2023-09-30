#!/bin/bash
#
#                   ▄
#                  █▀█
#                 ▄▀           █▀
#                 █      ▄▄▄▄ ▄▀
#                █           ██▄     ▄
#         ▄▄█▄  █     ▄▄     █  ▀▀   ▀█
#        ▄▀  ▀ ▄█   ▄▀▀▀█   ▀▄       ▄█▀█
#        █     ▀█  ▄▀   █    █     ▄▀▀   █
#        ▀▄  ▄▄▀▀▄ ▀█▄▄▀      █▄      ▄  █▀
#          ▀▀    ▀              ▀▀    ▀▀▀▀
#
#------------------------------------------------------------

if (( $EUID != 0 )); then
    echo -e "\e[31;1m wait ! you must run it as root ! x3\e[0m"
    exit 1
fi

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
print_help() {
	echo -e "\e[34;1mUsage: $0 [OPTIONS]\e[0m"
	echo
	echo -e "\e[34;1m	-i,  --install\e[0m"
	echo -e "\e[34;1m	-un, --uninstall\e[0m"
}

install() {
	echo ᓚᘏᗢ 
	echo -e "\e[34;1m copying DefaultSyntax script to sublime-text configs \e[0m"
		mkdir -p /home/"${SUDO_USER}"/.config/sublime-text/Packages/User/
		cp -v "${dir}"/DefaultSyntaxToGenericConfig-Subl.py /home/"${SUDO_USER}"/.config/sublime-text/Packages/User/DefaultSyntaxToGenericConfig-Subl.py
	
	echo -e "\e[34;1m copying systemd automount files \e[0m"
		cp -v "${dir}"/permnt-data.mount /etc/systemd/system/permnt-data.mount
#		cp -v "${dir}"/permnt-data.automount /etc/systemd/system/permnt-data.automount
		cp -v "${dir}"/permnt-ssdata.mount /etc/systemd/system/permnt-ssdata.mount
	echo -e "\e[34;1m making mount directories :3 \e[0m"
		mkdir -p /permnt/data/
	echo -e "\e[34;1m starting mount services uwu \e[0m"
		systemctl daemon-reload
		wait
		systemctl enable permnt-data.mount --now
#		systemctl enable permnt-data.automount --now
		systemctl enable permnt-ssdata.mount --now

	echo -e "\e[34;1m font x3 \e[0m"

		if [ "$(sha256sum "${dir}"/cartograph-cf-v2.rar | awk '{ print $1 }')" == "df3a34139ae3ea761910046b0e2ead87820c57b75f9edb6476eeb3fbb4926841" ]; then
			echo -e "\e[34;1m file alredy exist \o/ \e[0m"
		else
			echo -e "\e[34;1m dowonloading the font ! \e[0m"
			curl https://ifonts.xyz/wp-content/uploads/2020/04/cartograph-cf-v2.rar -O "${dir}"/
			wait
		fi
	echo -e "\e[34;1m extracting CartographCF \e[0m"
		mkdir -p /usr/local/share/fonts/c &> /dev/null
		bsdtar -C /usr/local/share/fonts/c/ -xf "${dir}"/cartograph-cf-v2.rar "*.otf"
}

uninstall() {
	echo ᓚᘏᗢ
	echo -e "\e[34;1m Remeowing DefaultSyntax\e[0m"
		rm /home/"${SUDO_USER}"/.config/sublime-text/Packages/User/DefaultSyntaxToGenericConfig-Subl.py

	echo -e "\e[34;1m Stopping systemd automount \e[0m"
		systemctl disable permnt-data.mount
#		systemctl disable permnt-data.automount
		systemctl disable permnt-ssdata.mount

	echo -e "\e[34;1m Remeowing systemd automount files\e[0m"
		rm /etc/systemd/system/permnt-*

	echo -e "\e[34;1m Remeowing CartographCF\e[0m"
		rm /usr/local/share/fonts/c/CartographCF*

	systemctl daemon-reload
}


if [[ "$1" == "-i" || "$1" == "i" || "$1" == "--install" || "$1" == "install" ]]; then
    install
    exit


elif [[ "$1" == "-un" ||  "$1" == "un" || "$1" == "--uninstall" || "$1" == "uninstall" ]]; then
    uninstall
    exit

else
	print_help
	exit
fi

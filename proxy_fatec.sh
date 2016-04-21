#!/bin/bash

# BOF

case "$1" in
	-e)
		export http_proxy="http://189.8.69.36:80/"
		export https_proxy="https://189.8.69.36:80/"
		export ftp_proxy="ftp://189.8.69.36:80/"
	;;

	-u)
		unset http_proxy
		unset https_proxy
		unset ftp_proxy
	;;

	*)
		echo "Invalid option. Use: -e to set proxy or -u to unset"
esac

exit 0

# EOF

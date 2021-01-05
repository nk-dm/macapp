#!/bin/sh
# Copyright (c) 2021 Nikita Demidov
# Licensed under the MIT License
# The produced files/folders belong to the user

next=';'
editinfo='n'
override='n'
name=""
short_name=""
out=""
bin=""
ico=""
inf=""
res=""
ver=""
appid=""

usage="usage: macapp -bin binary [-out Out.app] [-ico ico.icns] [-inf info.plist] [-res resource folder] [-name Myapp] [-appid com.eg.Myapp] [-ver 1.2.3a4] [--edit-info] [--override]"

# get arguments
for arg in $@; do
	# flags
	if [ "$arg" = "--0" ]; then
		next=';'
	elif [ "$arg" = "--help" ]; then
		echo $usage
	elif [ "$arg" = "-name" ]; then
		next='n'
	elif [ "$arg" = "-out" ]; then
		next='o'
	elif [ "$arg" = "-bin" ]; then
		next='b'
	elif [ "$arg" = "-ico" ]; then
		next='i'
	elif [ "$arg" = "-inf" ]; then
		next='f'
	elif [ "$arg" = "-res" ]; then
		next='r'
	elif [ "$arg" = "-ver" ]; then
		next='v'
	elif [ "$arg" = "-appid" ]; then
		next='a'
	elif [ "$arg" = "--edit-info" ]; then
		next=';'
		editinfo='y'
	elif [ "$arg" = "--override" ]; then
		next=';'
		override='y'
	# arguments:
	elif [ $next = 'n' ]; then
		name=$arg
		next=';'
	elif [ $next = 'o' ]; then
		out=$arg
		next=';'
	elif [ $next = 'b' ]; then
		bin=$arg
		next=';'
	elif [ $next = 'i' ]; then
		ico=$arg
		next=';'
	elif [ $next = 'f' ]; then
		inf=$arg
		next=';'
	elif [ $next = 'r' ]; then
		res=$arg
		next=';'
	elif [ $next = 'v' ]; then
		ver=$arg
		next=';'
	elif [ $next = 'a' ]; then
		appid=$arg
		next=';'
	else
		echo "ERROR: unknown argument \" $arg \""
		echo "$usage"
		exit 1
	fi
done

# check arguments
if [ ! -f "$bin" ] || [ "$bin" = "" ]; then
	echo "ERROR: mandatory argument bin=\" $bin \" is not a file"
	echo "$usage"
	exit 1
fi

if [ "$out" = "" ]; then
	out="${bin}.app"
elif [ ! `echo $out | sed 's/.*\(....\)/\1/'` = ".app" ]; then
	echo "ERROR: optional argument out=\" $out \" does not have an .app extension"
	exit 1
fi

do_override='n'
if [ -e "$out" ]; then
	if [ $override = 'y' ]; then
		do_override='y'
	else
		echo "ERROR:\" $out \" alredy exsists. Use --override to override it"
		exit 1
	fi
fi

if [ ! -f "$ico" ] && [ ! "$ico" = "" ] || [ ! $(echo $ico | sed 's/.*\(.....\)/\1/') = ".icns" ]; then
	echo "ERROR: optional argument ico=\" $ico \" does not have an .icns extension"
	exit 1
fi

if [ ! -f "$inf" ] && [ ! "$inf" = "" ]; then
	echo "ERROR: optional argument inf=\" $inf \" is not a file"
	exit 1
fi

if [ ! -e "$res" ] && [ ! $res = "" ]; then
	echo "ERROR: optional argument res=\" $res \" is not a directory"
	exit 1
fi

if [ "$name" = "" ]; then
	name=$bin
fi
short_name=`echo $name | cut -c1-16`

if [ $do_override = 'y' ]; then
	rm -rf "$out"
fi

# create .app and parent directories
mkdir -p "$out/Contents/MacOS"

cp "$bin" "$out/Contents/MacOS"

if [ ! "$res" = "" ]; then
	cp -r "$res" "$out/Contents/Resources"
else
	mkdir "$out/Contents/Resources"
fi

if [ ! "$ico" = "" ]; then
	cp "$ico" "$out/Contents/Resources/${name}.icns"
fi

if [ ! "$inf" = "" ]; then
	cp "$inf" "$out/Contents/Info.plist"
	if [ ! "$appid" = "" ]; then
		echo "Warning: appid=\" $appid \" is unused as inf=\" $inf \" is provided"
	fi
	if [ ! "$ver" = "" ]; then
		echo "Warning: ver=\" $ver \" is unused as inf=\" $inf \" is provided"
	fi
else
	# write default Info.plist
	infopath="$out/Contents/Info.plist"
	touch "$infopath"
	echo "<?xml version="1.0" encoding=\"UTF-8\"?>" >>"$infopath"
	echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >>"$infopath"
	echo "<plist version=\"1.0\">" >>"$infopath"
	echo "<dict>" >>"$infopath"
	echo "\t<key>CFBundleExecutable</key>" >>"$infopath"
	echo "\t<string>$name</string>" >>"$infopath"
	echo "\t<key>CFBundleIconFile</key>" >>"$infopath"
	echo "\t<string>$name</string>" >>"$infopath"
	echo "\t<key>CFBundleName</key>" >>"$infopath"
	echo "\t<string>$short_name</string>" >>"$infopath"
	echo "\t<key>NSPrincipalClass</key>" >>"$infopath"
	echo "\t<string>NSApplication</string>" >>"$infopath"
	if [ ! "$appid" = "" ]; then
		echo "\t<key>CFBundleIdentifier</key>" >>"$infopath"
		echo "\t<string>$appid</string>" >>"$infopath"
	else
		echo "Warning: optional argument appid is not set. This may cause problems"
	fi
	if [ ! "$ver" = "" ]; then
		echo "\t<key>CFBundleVersion</key>" >>"$infopath"
		echo "\t<string>$ver</string>" >>"$infopath"
	fi
	echo "</dict>" >>"$infopath"
	echo "</plist>" >>"$infopath"
fi

if [ $editinfo = 'y' ]; then
	open "$out/Contents/Info.plist"
fi
exit 0

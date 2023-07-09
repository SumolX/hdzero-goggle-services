#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: ./generate.sh [BUILD_PATH] [SOURCE_PATH]"
	exit 1
fi

ROOT=$2
OUTPUT="$ROOT/scripts/busybox_startup.sh"
BUSYBOX="/mnt/app/services/busybox/busybox"
BIN_SYM=$(find $1/_install/bin -type l | sort -h)
SBIN_SYM=$(find $1/_install/sbin -type l | sort -h)
USR_BIN_SYM=$(find $1/_install/usr/bin -type l | sort -h)
USR_SBIN_SYM=$(find $1/_install/usr/sbin -type l | sort -h)

create_script()
{
	mkdir -p $ROOT/scripts
	echo "#!/bin/sh" > $OUTPUT
	echo "" >> $OUTPUT
}

update_script()
{
	list=$1
	path=$2
	match=$3
	for sym in $list;
	do
		cmd=$(basename $sym)
		echo "if [ -z \"\$(readlink $path/$cmd | grep \"$match\")\" ]; then" >> $OUTPUT
		echo "    ln -sfn $BUSYBOX $path/$cmd" >> $OUTPUT
		echo "fi" >> $OUTPUT

	done
}

finalize_script()
{
	echo "" >> $OUTPUT
	chmod +x $OUTPUT
}

create_script
update_script "$BIN_SYM" "/bin" "busybox"
update_script "$SBIN_SYM" "/sbin" "bin/busybox"
update_script "$USR_BIN_SYM" "/usr/bin" "bin/busybox"
update_script "$USR_SBIN_SYM" "/usr/sbin" "bin/busybox"
finalize_script


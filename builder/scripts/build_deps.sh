#!/usr/bin/env bash

###
#
# Build dependencies
# - compile musl lib for a specific architecture
# - strip static libraries
# - copy some static libraries from the musl-cc tree
# - copy musl-gcc wrapper & specs
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }
source "${script_dir}/../env/qjs"

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([deps-dir],[d],[directory containing dependencies],[$script_dir/../../deps])
# ARG_OPTIONAL_SINGLE([arch],[a],[target architecture],[x86_64])
# ARG_OPTIONAL_BOOLEAN([force],[f],[force rebuild],[off])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[enable verbose mode],[off])
# ARG_TYPE_GROUP_SET([arch],[type string],[arch],[x86_64,i686,armv7l,aarch64])
# ARG_HELP([Build dependencies needed to build a static version of QuickJS])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}

# validators

arch()
{
	local _allowed=("x86_64" "i686" "armv7l" "aarch64") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'x86_64', 'i686', 'armv7l' and 'aarch64'" 4
}


begins_with_short_option()
{
	local first_option all_short_options='dafvh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_deps_dir="$script_dir/../../deps"
_arg_arch="x86_64"
_arg_force="off"
_arg_verbose="off"


print_help()
{
	printf '%s\n' "Build dependencies needed to build a static version of QuickJS"
	printf 'Usage: %s [-d|--deps-dir <arg>] [-a|--arch <type string>] [-f|--(no-)force] [-v|--(no-)verbose] [-h|--help]\n' "$0"
	printf '\t%s\n' "-d, --deps-dir: directory containing dependencies (default: '$script_dir/../../deps')"
	printf '\t%s\n' "-a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')"
	printf '\t%s\n' "-f, --force, --no-force: force rebuild (off by default)"
	printf '\t%s\n' "-v, --verbose, --no-verbose: enable verbose mode (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-d|--deps-dir)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_deps_dir="$2"
				shift
				;;
			--deps-dir=*)
				_arg_deps_dir="${_key##--deps-dir=}"
				;;
			-d*)
				_arg_deps_dir="${_key##-d}"
				;;
			-a|--arch)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_arch="$(arch "$2" "arch")" || exit 1
				shift
				;;
			--arch=*)
				_arg_arch="$(arch "${_key##--arch=}" "arch")" || exit 1
				;;
			-a*)
				_arg_arch="$(arch "${_key##-a}" "arch")" || exit 1
				;;
			-f|--no-force|--force)
				_arg_force="on"
				test "${1:0:5}" = "--no-" && _arg_force="off"
				;;
			-f*)
				_arg_force="on"
				_next="${_key##-f}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-f" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-v|--no-verbose|--verbose)
				_arg_verbose="on"
				test "${1:0:5}" = "--no-" && _arg_verbose="off"
				;;
			-v*)
				_arg_verbose="on"
				_next="${_key##-v}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-v" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash
# Validation of values


### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# vvv  PLACE YOUR CODE HERE  vvv

source "${script_dir}/../env/deps"

# build 'musl lib'
build_musl_lib()
{
    [ $_arg_verbose == "on" ] && echo "Building 'musl lib' for '${_arg_arch}'..."

    declare -n _cfg="cfg_musl_lib"

    # directory containing 'musl' sources
    _archive_dir="${deps_dir}/${_cfg["archive_dir_symlink"]}"
    # directory where built library will be installed
    _build_dir="${_archive_dir}/BUILD-${_arg_arch}"
    # used to keep track of whether or not library was built
    _built_marker="${_archive_dir}/.built-${_arg_arch}"
    # compiler binary
    _cc="${deps_dir}/musl_cc-${_arg_arch}/cc"
    # library which will be copied from 'musl_cc' directory (required for 'armv7l' compilation)
    _libatomic="${deps_dir}/musl_cc-${_arg_arch}/libatomic.a"
     # library which will be copied from 'musl_cc' directory (to avoid linking error 'cannot find -lssp_nonshared' on alpine)
    _libssp_nonshared="${deps_dir}/musl_cc-${_arg_arch}/libssp_nonshared.a"
    # use 'strip' binary from cross compiler
   _strip="${deps_dir}/musl_cc-${_arg_arch}/strip"
    # directory containing custom files which will be copied after build
    _custom_dir="${custom_dir}/musl"

    # ensure all dependencies exist
    if ! [ -d ${_archive_dir} ] || ! [ -f ${_cc} ]
    then
        echo "Missing dependencies. Run 'fetch_deps.sh' script first" 1>&2
        return 1
    fi

    # already built
    if [ -f ${_built_marker} ] && [ $_arg_force == "off" ]
    then
        [ $_arg_verbose == "on" ] && echo "No need to build 'musl lib' for '${_arg_arch}'"
    else
        # build
        (rm -f ${_built_marker} && \
            rm -fr ${_build_dir} && \
            cd ${_archive_dir} && \
            make clean && \
            CC=${_cc} LDFLAGS=-s ./configure --disable-shared \
                --prefix=/ \
                --syslibdir=/lib \
                --exec-prefix=/ \
                --enable-wrapper=no && \
            DESTDIR=${_build_dir} make install) || return 1
        [ $_arg_verbose == "on" ] && echo "Successfully built 'musl lib' for '${_arg_arch}'"
    fi

    # copy script & specs
    cp -R ${_custom_dir}/* ${_build_dir} || return 1

    # copy 'libatomic' from musl-cc
    cp -L ${_libatomic} ${_build_dir}/lib || return 1

    # copy 'libssp_nonshared' from musl-cc
    cp -L ${_libssp_nonshared} ${_build_dir}/lib || return 1

    # strip all static libraries
    for _file in $(find "${_build_dir}/" -type f -name '*.a')
    do
        ${_strip} -d ${_file} || return 1
    done

    # create build marker
    touch ${_built_marker} || return 1

    return 0
}

# build all dependencies
build_deps()
{
    [ $_arg_verbose == "on" ] && echo "Building dependencies for '${_arg_arch}'..."

    build_musl_lib || return 1

    [ $_arg_verbose == "on" ] && echo "Dependencies for '${_arg_arch}' successfully built"

    return 0
}

_PRINT_HELP=no
deps_dir=$_arg_deps_dir
custom_dir="${script_dir}/../custom"

build_deps || die "Could not build dependencies for '${_arg_arch}'"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash

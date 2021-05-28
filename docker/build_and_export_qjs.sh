#!/usr/bin/env bash

###
#
# Build a static version of QuickJS (interpreter & compiler)
# Export a portable package which can be used to generate static binaries
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }
source "${script_dir}/../builder/env/qjs"

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([packages-dir],[p],[directory where package will be exported],[$script_dir/../packages])
# ARG_OPTIONAL_SINGLE([arch],[a],[target architecture],[x86_64])
# ARG_OPTIONAL_BOOLEAN([ext-lib],[],[add QuickJS extension library],[off])
# ARG_OPTIONAL_SINGLE([ext-lib-version],[],[QuickJS extension library version],[$default_qjs_ext_lib_version])
# ARG_OPTIONAL_REPEATED([extra-dir],[e],[extra directory to add into package],[])
# ARG_OPTIONAL_BOOLEAN([force-build-image],[],[force rebuilding docker image],[off])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[enable verbose mode],[off])
# ARG_POSITIONAL_SINGLE([qjs-version],[QuickJS version (ex: 2020-09-06)],[$default_qjs_version])
# ARG_TYPE_GROUP_SET([arch],[type string],[arch],[x86_64,i686,armv7l,aarch64])
# ARG_HELP([Build a static version of QuickJS (interpreter & compiler)])
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
	local first_option all_short_options='paevh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_qjs_version="$default_qjs_version"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_packages_dir="$script_dir/../packages"
_arg_arch="x86_64"
_arg_ext_lib="off"
_arg_ext_lib_version="$default_qjs_ext_lib_version"
_arg_extra_dir=()
_arg_force_build_image="off"
_arg_verbose="off"


print_help()
{
	printf '%s\n' "Build a static version of QuickJS (interpreter & compiler)"
	printf 'Usage: %s [-p|--packages-dir <arg>] [-a|--arch <type string>] [--(no-)ext-lib] [--ext-lib-version <arg>] [-e|--extra-dir <arg>] [--(no-)force-build-image] [-v|--(no-)verbose] [-h|--help] [<qjs-version>]\n' "$0"
	printf '\t%s\n' "<qjs-version>: QuickJS version (ex: 2020-09-06) (default: '$default_qjs_version')"
	printf '\t%s\n' "-p, --packages-dir: directory where package will be exported (default: '$script_dir/../packages')"
	printf '\t%s\n' "-a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')"
	printf '\t%s\n' "--ext-lib, --no-ext-lib: add QuickJS extension library (off by default)"
	printf '\t%s\n' "--ext-lib-version: QuickJS extension library version (default: '$default_qjs_ext_lib_version')"
	printf '\t%s\n' "-e, --extra-dir: extra directory to add into package (empty by default)"
	printf '\t%s\n' "--force-build-image, --no-force-build-image: force rebuilding docker image (off by default)"
	printf '\t%s\n' "-v, --verbose, --no-verbose: enable verbose mode (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-p|--packages-dir)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_packages_dir="$2"
				shift
				;;
			--packages-dir=*)
				_arg_packages_dir="${_key##--packages-dir=}"
				;;
			-p*)
				_arg_packages_dir="${_key##-p}"
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
			--no-ext-lib|--ext-lib)
				_arg_ext_lib="on"
				test "${1:0:5}" = "--no-" && _arg_ext_lib="off"
				;;
			--ext-lib-version)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_ext_lib_version="$2"
				shift
				;;
			--ext-lib-version=*)
				_arg_ext_lib_version="${_key##--ext-lib-version=}"
				;;
			-e|--extra-dir)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_extra_dir+=("$2")
				shift
				;;
			--extra-dir=*)
				_arg_extra_dir+=("${_key##--extra-dir=}")
				;;
			-e*)
				_arg_extra_dir+=("${_key##-e}")
				;;
			--no-force-build-image|--force-build-image)
				_arg_force_build_image="on"
				test "${1:0:5}" = "--no-" && _arg_force_build_image="off"
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
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 0 and 1, but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_qjs_version "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash
# Validation of values


### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# vvv  PLACE YOUR CODE HERE  vvv

# ensure version exist
qjs_commit="${qjs_commits[$_arg_qjs_version]}"
if [ -z ${qjs_commit} ]
then
    _PRINT_HELP=yes die "QuickJS version '$_arg_qjs_version' is not supported"
fi

_PRINT_HELP=no

build_docker_image()
{
    _flag_verbose=""
    [ $_arg_verbose == "on" ] && _flag_verbose="-v"
    _flag_force_build_image=""
    [ $_arg_force_build_image == "on" ] && _flag_force_build_image="-f"

    ${script_dir}/scripts/build_docker_image.sh ${_flag_verbose} -a ${_arg_arch} ${_flag_force_build_image} || return 1

    return 0
}

build_and_export_package()
{
    _image_name="quickjs-cross-compiler:${_arg_arch}"

    _flag_verbose=""
    [ $_arg_verbose == "on" ] && _flag_verbose="-v"
    args_qjs_ext_lib=""
    if [ $_arg_ext_lib == "on" ]
    then
        args_qjs_ext_lib="--ext-lib --ext-lib-version $_arg_ext_lib_version"
    fi
    args_extra_dir=""
    for a in ${_arg_extra_dir[@]}
    do
        args_extra_dir="${args_extra_dir} -e ${a}"
    done

    _docker_cmd="./build_and_export_qjs.sh ${_flag_verbose} -a ${_arg_arch} ${args_qjs_ext_lib} ${args_extra_dir}"

    (mkdir -p ${_arg_packages_dir} && \
        docker run --rm \
            --mount type=bind,source="${script_dir}/../builder",target="/usr/local/src/quickjs-cross-compiler/builder" \
            --mount type=bind,source="${_arg_packages_dir}",target="/usr/local/src/quickjs-cross-compiler/packages" \
            ${_image_name} ${_docker_cmd}) || return 1
    return 0
}

build_docker_image || exit 1
build_and_export_package || exit 1

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash

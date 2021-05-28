#!/usr/bin/env bash

###
#
# Compile QuickJS
# - compile interpreter & compiler statically
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }
source "${script_dir}/../env/qjs"

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([deps-dir],[d],[directory containing dependencies],[$script_dir/../../deps])
# ARG_OPTIONAL_SINGLE([arch],[a],[target architecture],[x86_64])
# ARG_OPTIONAL_BOOLEAN([force],[f],[force rebuild],[off])
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
	local first_option all_short_options='dafvh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_qjs_version="$default_qjs_version"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_deps_dir="$script_dir/../../deps"
_arg_arch="x86_64"
_arg_force="off"
_arg_verbose="off"


print_help()
{
	printf '%s\n' "Build a static version of QuickJS (interpreter & compiler)"
	printf 'Usage: %s [-d|--deps-dir <arg>] [-a|--arch <type string>] [-f|--(no-)force] [-v|--(no-)verbose] [-h|--help] [<qjs-version>]\n' "$0"
	printf '\t%s\n' "<qjs-version>: QuickJS version (ex: 2020-09-06) (default: '$default_qjs_version')"
	printf '\t%s\n' "-d, --deps-dir: directory containing dependencies (default: '$script_dir/../../deps')"
	printf '\t%s\n' "-a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')"
	printf '\t%s\n' "-f, --force, --no-force: force rebuild (off by default)"
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

source "${script_dir}/../env/qjs"

# ensure version exist
qjs_commit="${qjs_commits[$_arg_qjs_version]}"
if [ -z ${qjs_commit} ]
then
    _PRINT_HELP=yes die "QuickJS version '$_arg_qjs_version' is not supported"
fi

# build QuickJS
build_qjs()
{
    [ $_arg_verbose == "on" ] && echo "Building 'QuickJS' version '${_arg_qjs_version}'..."

    # compiler binary
    _cc="${deps_dir}/musl_cc-${_arg_arch}/cc"

    # ensure cross compiler exists
    if ! [ -f ${_cc} ]
    then
        echo "Missing dependencies. Run 'fetch_deps.sh' script first" 1>&2
        return 1
    fi

    # ensure repository exists
    if ! [ -d ${repo_dir} ]
    then
        echo "Local repository does not exist. Run 'checkout_qjs.sh' script first" 1>&2
        return 1
    fi

    # If target architecture is not 'x86_64', ensure 'qjsc-x86_64' exists
    # since we will need its 'qjsc' binary to generate c files
    # It is supposed to be copied by 'checkout_qjs' script
    _qjsc_binary="${repo_dir}/qjsc"
    if [ ${_arg_arch} != "x86_64" ]
    then
        _qjsc_binary="${repo_dir}/qjsc-x86_64"
        if ! [ -f ${_qjsc_binary} ]
        then
            echo "File '${_qjsc_binary}' does not exist. Run 'prepare_qjs.sh' script first" 1>&2
            return 1
        fi
    fi

    # ensure expected commit is checked out
    cd ${repo_dir} && \
        current_commit="$(git rev-parse HEAD)"
    if [ ${current_commit} != ${qjs_commit} ]
    then
        echo "Current commit (${current_commit}) does not match expected one (${qjs_commit}). Run 'checkout_qjs.sh' script first" 1>&2
        return 1
    fi

    # directory where QuickJS will be installed after being built
    _build_dir="${repo_dir}/BUILD-${_arg_qjs_version}-${_arg_arch}"
    # used to keep track of whether or not repo was patched
    _patched_marker="${repo_dir}/.patched-${_arg_qjs_version}"
    # used to keep track of whether or not QuickJS was already built
    _built_marker="${repo_dir}/.built-${_arg_qjs_version}-${_arg_arch}"
    # symlink in the repository, referencing the directory containing 'musl' build
    _musl_dir_symlink="${repo_dir}/musl-${_arg_arch}"

    # ensure patches were applied
    if ! [ -f ${_patched_marker} ]
    then
        echo "Local repository not patched. Run 'prepare_qjs.sh' script first" 1>&2
        return 1
    fi

    # ensure link to 'musl lib' exists
    if ! [ -d ${_musl_dir_symlink} ]
    then
        echo "'musl lib' symlink not found. Run 'prepare_qjs.sh' script first" 1>&2
        return 1
    fi

    # QuickJS was already built
    if [ -f ${_built_marker} ] && [ $_arg_force == "off" ]
    then
        [ $_arg_verbose == "on" ] && echo "No need to build 'QuickJS' version '${_arg_qjs_version}' for '${_arg_arch}'"
    else
        # build
        (rm -f ${_built_marker} && \
            rm -f ${_commit_marker} && \
            rm -fr ${_build_dir} && \
            cd ${repo_dir} && \
            make clean && \
            qjs_cc=${_cc} musl_arch=${_arg_arch} qjsc_binary=${_qjsc_binary} make && \
            DESTDIR=${_build_dir} make install) || return 1
        [ $_arg_verbose == "on" ] && echo "'QuickJS' version '${_arg_qjs_version}' successfully built for '${_arg_arch}'"
    fi

    # create build marker
    echo ${qjs_commit} >${_built_marker} || return 1

    return 0
}

_PRINT_HELP=no
deps_dir=$_arg_deps_dir
repo_dir="${script_dir}/../../quickjs-repo"

build_qjs || die "Could not build 'QuickJS' version '${_arg_qjs_version}' for '${_arg_arch}'"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash

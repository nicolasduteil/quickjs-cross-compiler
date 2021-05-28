#!/usr/bin/env bash

###
#
# Prepare QuickJS repository
# - apply some patches (Makefile, qjsc.c ...)
# - create a symlink to the directory containing the musl lib build
# - copy the qjsc_x86_64 binary which will be needed to generate .c file during cross-compilation
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }
source "${script_dir}/../env/qjs"

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([deps-dir],[d],[directory containing dependencies],[$script_dir/../../deps])
# ARG_OPTIONAL_SINGLE([arch],[a],[target architecture],[x86_64])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[enable verbose mode],[off])
# ARG_POSITIONAL_SINGLE([qjs-version],[QuickJS version (ex: 2020-09-06)],[$default_qjs_version])
# ARG_TYPE_GROUP_SET([arch],[type string],[arch],[x86_64,i686,armv7l,aarch64])
# ARG_HELP([Patch QuickJS sources & create symlink to static musl lib])
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
	local first_option all_short_options='davh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_qjs_version="$default_qjs_version"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_deps_dir="$script_dir/../../deps"
_arg_arch="x86_64"
_arg_verbose="off"


print_help()
{
	printf '%s\n' "Patch QuickJS sources & create symlink to static musl lib"
	printf 'Usage: %s [-d|--deps-dir <arg>] [-a|--arch <type string>] [-v|--(no-)verbose] [-h|--help] [<qjs-version>]\n' "$0"
	printf '\t%s\n' "<qjs-version>: QuickJS version (ex: 2020-09-06) (default: '$default_qjs_version')"
	printf '\t%s\n' "-d, --deps-dir: directory containing dependencies (default: '$script_dir/../../deps')"
	printf '\t%s\n' "-a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')"
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

# patch QuickJS source files
patch_qjs()
{
    [ $_arg_verbose == "on" ] && echo "Patching 'QuickJS' sources..."

    # ensure repository exists
    if ! [ -d ${repo_dir} ]
    then
        echo "Local repository does not exist. Run 'checkout_qjs.sh' script first" 1>&2
        return 1
    fi

    # ensure expected commit is checked out
    cd ${repo_dir} && \
        current_commit="$(git rev-parse HEAD)"
    if [ ${current_commit} != ${qjs_commit} ]
    then
        echo "Current commit (${current_commit}) does not match expected one (${qjs_commit}). Run 'checkout_qjs.sh' script first" 1>&2
        return 1
    fi

    _patch_dir="${custom_dir}/qjs/patches/$_arg_qjs_version"
    _need_patch=0
    # used to keep track of whether or not repo was patched
    _patched_marker="${repo_dir}/.patched-${_arg_qjs_version}"

    # patches have already been applied
    if ! [ -f ${_patched_marker} ]
    then
        cd ${repo_dir}

        for file in $(ls $_patch_dir/*.patch)
        do
            # check if patch has already been applied
            patch -Rp1 -s -f --dry-run <$file >/dev/null 2>&1
            if [ $? -ne 0 ]
            then
                _need_patch=1
                patch -Np1 <$file || return 1
            fi
        done
        # create marker
        touch ${_patched_marker}
    fi

    if [ ${_need_patch} -eq 0 ]
    then
        [ $_arg_verbose == "on" ] && echo "'QuickJS' sources already patched"
    else
        [ $_arg_verbose == "on" ] && echo "Successfully patched 'QuickJS' sources"
    fi

    return 0
}

# create symlink to static musl lib
create_musl_symlink()
{
    [ $_arg_verbose == "on" ] && echo "Creating symlink to 'musl lib' for '${_arg_arch}'..."

    # used to keep track of whether or not musl lib was built
    _musl_built_marker="${deps_dir}/musl/.built-${_arg_arch}"
    # directory where musl was build
    _musl_dir="${deps_dir}/musl/BUILD-${_arg_arch}"
    # symlink in the repository, referencing the directory containing 'musl' build
    _musl_dir_symlink="${repo_dir}/musl-${_arg_arch}"

    # ensure musl was built
    if ! [ -f ${_musl_built_marker} ]
    then
        echo "'musl lib' was not built for '${_arg_arch}'. Run 'build_deps.sh' script first" 1>&2
        return 1
    fi

    (rm -f ${_musl_dir_symlink} && \
        ln -s ${_musl_dir} ${_musl_dir_symlink}) || return 1

    [ $_arg_verbose == "on" ] && echo "Successfully created symlink to 'musl lib' for '${_arg_arch}'"

    return 0
}

_PRINT_HELP=no
deps_dir=$_arg_deps_dir
repo_dir="${script_dir}/../../quickjs-repo"
# directory containing custom files such as patches to apply
custom_dir="${script_dir}/../custom"

patch_qjs || die "Could not patch 'QuickJS'"
# 'x86_64' version of the binary is needed to generate c files when doing cross-compilation
cp ${custom_dir}/qjs/qjsc-x86_64 ${repo_dir} || die "Could not copy 'qjsc-x86_64' to repository"
# copy extra source files
cp -R ${custom_dir}/qjs/files/* ${repo_dir} || die "Could not copy extra source files to repository"
create_musl_symlink || die "Could not create symlink to 'musl lib'"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash

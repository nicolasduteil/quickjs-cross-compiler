#!/usr/bin/env bash

###
#
# Export a portable package which can be used to generate static binaries
# - strip binaries & static libraries
# - add extra directories (optional)
# - generate an archive compressed with xz
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }
source "${script_dir}/../env/qjs"

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([deps-dir],[d],[directory containing dependencies],[$script_dir/../../deps])
# ARG_OPTIONAL_SINGLE([packages-dir],[p],[directory where package will be exported],[$script_dir/../../packages])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[enable verbose mode],[off])
# ARG_OPTIONAL_SINGLE([arch],[a],[target architecture],[x86_64])
# ARG_OPTIONAL_BOOLEAN([ext-lib],[],[add QuickJS extension library],[off])
# ARG_OPTIONAL_SINGLE([ext-lib-version],[],[QuickJS extension library version],[$default_qjs_ext_lib_version])
# ARG_OPTIONAL_REPEATED([extra-dir],[e],[extra directory to add into package],[])
# ARG_POSITIONAL_SINGLE([qjs-version],[QuickJS version (ex: 2020-09-06)],[$default_qjs_version])
# ARG_TYPE_GROUP_SET([arch],[type string],[arch],[x86_64,i686,armv7l])
# ARG_HELP([Export a tarball containing a static version of QuickJS and a static version of musl library])
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
	local _allowed=("x86_64" "i686" "armv7l") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'x86_64', 'i686' and 'armv7l'" 4
}


begins_with_short_option()
{
	local first_option all_short_options='dpvaeh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_qjs_version="$default_qjs_version"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_deps_dir="$script_dir/../../deps"
_arg_packages_dir="$script_dir/../../packages"
_arg_verbose="off"
_arg_arch="x86_64"
_arg_ext_lib="off"
_arg_ext_lib_version="$default_qjs_ext_lib_version"
_arg_extra_dir=()


print_help()
{
	printf '%s\n' "Export a tarball containing a static version of QuickJS and a static version of musl library"
	printf 'Usage: %s [-d|--deps-dir <arg>] [-p|--packages-dir <arg>] [-v|--(no-)verbose] [-a|--arch <type string>] [--(no-)ext-lib] [--ext-lib-version <arg>] [-e|--extra-dir <arg>] [-h|--help] [<qjs-version>]\n' "$0"
	printf '\t%s\n' "<qjs-version>: QuickJS version (ex: 2020-09-06) (default: '$default_qjs_version')"
	printf '\t%s\n' "-d, --deps-dir: directory containing dependencies (default: '$script_dir/../../deps')"
	printf '\t%s\n' "-p, --packages-dir: directory where package will be exported (default: '$script_dir/../../packages')"
	printf '\t%s\n' "-v, --verbose, --no-verbose: enable verbose mode (off by default)"
	printf '\t%s\n' "-a, --arch: target architecture. Can be one of: 'x86_64', 'i686' and 'armv7l' (default: 'x86_64')"
	printf '\t%s\n' "--ext-lib, --no-ext-lib: add QuickJS extension library (off by default)"
	printf '\t%s\n' "--ext-lib-version: QuickJS extension library version (default: '$default_qjs_ext_lib_version')"
	printf '\t%s\n' "-e, --extra-dir: extra directory to add into package (empty by default)"
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

# ensure version exists
qjs_commit="${qjs_commits[$_arg_qjs_version]}"
if [ -z ${qjs_commit} ]
then
    _PRINT_HELP=yes die "QuickJS version '$_arg_qjs_version' is not supported (commit unknown)"
fi

# ensure package name exists
qjs_package="${qjs_packages[$_arg_qjs_version]}"
if [ -z ${qjs_package} ]
then
    _PRINT_HELP=yes die "QuickJS version '$_arg_qjs_version' is not supported (package unknown)"
fi

package_type=core
if ! [ -z $_arg_extra_dir ] || [ $_arg_ext_lib == "on" ]
then
    # we have been given directories to add to package
    package_type=ext
fi

# export QuickJS
export_qjs()
{
    [ $_arg_verbose == "on" ] && echo "Exporting 'QuickJS' version '${_arg_qjs_version}' (${package_type}) for '${_arg_arch}'..."

    if ! [ -d ${repo_dir} ]
    then
        echo "Local repository does not exist. Run 'checkout_qjs.sh' script first" 1>&2
        return 1
    fi

    # directory where QuickJS was installed afte being built
    _build_dir="${repo_dir}/BUILD-${_arg_qjs_version}-${_arg_arch}"
    # used to keep track of whether or not QuickJS was already built
    _built_marker="${repo_dir}/.built-${_arg_qjs_version}-${_arg_arch}"

    # ensure version was built
    if ! [ -f ${_built_marker} ]
    then
        echo "QuickJS version '${_arg_qjs_version}' was not built. Run 'build_qjs.sh' script first" 1>&2
        return 1
    fi

    # ensure version was built with expected commit
    _build_commit=$(head -1 ${_built_marker})
    if [ ${_build_commit} != ${qjs_commit} ]
    then
        echo "QuickJS version '${_arg_qjs_version}' was built using commit (${_build_commit}) instead of expected one (${qjs_commit}). Run 'checkout_qjs.sh' script first" 1>&2
        return 1
    fi

    # name of the package which will be exported
    _package_name="quickjs.${package_type}.${qjs_package}.${_arg_arch}"
    # add qjs ext lib to the name if it has been added
    if [ $_arg_ext_lib == "on" ]
    then
        _package_name="quickjs.${package_type}.${qjs_package}.ext-lib-$_arg_ext_lib_version.${_arg_arch}"
    fi
    # directory where package will be exported
    _package_dir="${packages_dir}/${_package_name}"
    # name of the exported tarball
    _package_tarball_filename="${_package_name}.tar.xz"
    # location of the final tarball
    _package_tarball="${packages_dir}/${_package_tarball_filename}"
    # symlink in the repository, referencing the directory containing 'musl' build
    _musl_dir_symlink="${repo_dir}/musl-${_arg_arch}"
    # list of files which need to be copied from the directory where QuickJS was installed
    _qjs_export_list="bin/qjs bin/qjsc lib/quickjs/libquickjs.a include/quickjs/quickjs-libc.h include/quickjs/quickjs.h"
    # list of QuickJS files which need to be stripped
    _qjs_strip_list="qjs qjsc libquickjs.a"
    # list of qjs examples/tests files to copy
    _qjs_examples="examples/fib_module.js examples/hello.js examples/hello_module.js examples/pi_bigdecimal.js examples/pi_bigfloat.js examples/pi_bigint.js tests/microbench.js"
    # use 'strip' binary from cross compiler
   _strip="${deps_dir}/musl_cc-${_arg_arch}/strip"

    # create package directory
    (rm -fr ${_package_dir} && \
        mkdir -p ${_package_dir}) || return 1

    # copy QuickJS files
    for _e in ${_qjs_export_list}
    do
        _file="${_build_dir}/${_e}"
        cp ${_file} ${_package_dir} || return 1
    done

    # strip QuickJS binaries & lib
    for _e in ${_qjs_strip_list}
    do
        _file="${_package_dir}/${_e}"
        if [ "$(basename ${_e} .a)" !=  "$(basename ${_e})" ]
        then
            # this is a static library
            ${_strip} -d ${_file} || return 1
        else
            # this is a binary
            ${_strip} ${_file} || return 1
        fi
    done

    # copy musl directory
    cp -RL ${_musl_dir_symlink} ${_package_dir} || return 1

    # copy examples & tests
    mkdir -p ${_package_dir}/examples || return 1
    for _filename in ${_qjs_examples}
    do
        _file="${repo_dir}/${_filename}"
        ! [ -f ${_file} ] && continue
        cp ${_file} ${_package_dir}/examples || return 1
    done

    # copy ext lib
    if [ $_arg_ext_lib == "on" ]
    then
        _ext_lib_tmp_dir=${_package_dir}/.ext_lib
        rm -fr ${_ext_lib_tmp_dir} && \
            git clone ${qjs_ext_lib_repository} ${_ext_lib_tmp_dir}
        if [ $? -ne 0 ]
        then
            echo "Could not retrieve QuickJS extension library '${_arg_ext_lib_version}'" 1>&2
            return 1
        fi
        if [ ${_arg_ext_lib_version} != "master" ]
        then
            cd ${_ext_lib_tmp_dir} && git checkout tags/${_arg_ext_lib_version}
            if [ $? -ne 0 ]
            then
                echo "Could not retrieve QuickJS extension library '${_arg_ext_lib_version}'" 1>&2
                return 1
            fi
        fi
        # copy src files
        mkdir -p ${_package_dir}/ext && \
            cp -R ${_ext_lib_tmp_dir}/src/* ${_package_dir}/ext && \
            rm -fr ${_ext_lib_tmp_dir}
    fi

    # copy extra directories
    for _dir in ${_arg_extra_dir[@]}
    do
        # it might have been passed using format src:dest
        _src=$(echo ${_dir} | cut -d ':' -f1)
        _dest=$(echo ${_dir} | cut -d ':' -f2)
        # no destination was given
        if [ -z ${_dest} ] || [ ${_src} == ${_dest} ]
        then
            # copy directory
            cp -R ${_src} ${_package_dir} || return 1
        else
            _dirname=$(basename ${_dest})
            # copy directory content
            mkdir -p ${_package_dir}/${_dirname} || return 1
            cp -R ${_src}/* ${_package_dir}/${_dirname} || return 1
        fi
    done

    # copy all scripts from 'custom' directory
    cp -R ${custom_dir}/qjs/scripts/* ${_package_dir} || return 1

    # copy ext lib examples
    if [ $_arg_ext_lib == "on" ]
    then
        cp -R ${custom_dir}/qjs/examples/ext-lib ${_package_dir}/examples || return 1
    fi

    # copy README
    cp -R ${custom_dir}/README.md ${_package_dir} || return 1

    # compress directory
    (cd ${packages_dir} &&
        tar -C ${packages_dir} -cJf ${_package_tarball_filename} ${_package_name} && \
        rm -fr ${_package_dir}) || return 1

    [ $_arg_verbose == "on" ] && echo "'QuickJS' version '${_arg_qjs_version}' (${package_type}) successfully exported for '${_arg_arch}' to '${_arg_packages_dir}/${_package_tarball_filename}'"

    return 0
}

# ensure all extra directories which should be copied exist
for _dir in ${_arg_extra_dir[@]}
do
    # it might have been passed using format src:dest
    _src=$(echo ${_dir} | cut -d ':' -f 1)
    ([ -z ${_src} ] || ! [ -d ${_src} ]) && die "Extra directory '${_src}' does not exist"
done

_PRINT_HELP=no
repo_dir="${script_dir}/../../quickjs-repo"
deps_dir=$_arg_deps_dir
packages_dir=$_arg_packages_dir
custom_dir="${script_dir}/../custom"

mkdir -p ${packages_dir}

export_qjs || die "Could not export 'QuickJS' version '${_arg_qjs_version}' for '${_arg_arch}'"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash

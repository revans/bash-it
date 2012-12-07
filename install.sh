#!/usr/bin/env bash

BASH_IT=$(cd ${0%/*} && echo ${PWD})
cd "${OLDPWD}"

[[ "${BASH_IT}" != "${HOME}/.bash_it" ]] && cp -Rf "${BASH_IT}" "${HOME}/.bash_it"

BASH_PROFILE_BAK="${HOME}/.bash_profile.bak"
if [ -f "${BASH_PROFILE_BAK}" ]; then
  list=($(ls "${BASH_PROFILE_BAK}"*))
  BASH_PROFILE_BAK="${BASH_PROFILE_BAK}.${#list[@]}"
fi

[[ -f "${HOME}/.bash_profile" ]] \
    && cp "${HOME}/.bash_profile" "${BASH_PROFILE_BAK}" \
    && echo "Your original .bash_profile has been backed up to ${BASH_PROFILE_BAK##*/}" \
    || echo "No original .bash_profile file found so we have nothing to back up"

cp "${BASH_IT}/template/bash_profile.template.bash" "${HOME}/.bash_profile"

echo "Copied the template .bash_profile into ~/.bash_profile, edit this file to customize bash-it"

while true; do
  read -n 1 -p "Do you use Jekyll? (If you don't know what Jekyll is, answer 'n') [Y/N] " RESP
  case ${RESP} in
    [yY])
      cp "${BASH_IT}/template/jekyllconfig.template.bash" "${HOME}/.jekyllconfig"
      echo "Copied the template .jekyllconfig into your home directory." \
          "Edit this file to customize bash-it for using the Jekyll plugins"
      break
    ;;
    [nN])
      break
    ;;
    *)
      echo "Please enter Y or N"
  esac
done

function load_all() {
  file_type="${1}"
  [ ! -d "${BASH_IT}/${file_type}/enabled" ] && mkdir "${BASH_IT}/${file_type}/enabled"
  for src in "${BASH_IT}/${file_type}/available/"*; do
    filename="${src##*/}"
    [ "${filename:0:1}" = "_" ] && continue
    dest="${BASH_IT}/${file_type}/enabled/${filename}"
    if [ ! -e "${dest}" ]; then
      ln -s "${src}" "${dest}"
    else
      echo "File ${dest} exists, skipping"
    fi
  done
}

function load_some() {
  file_type="${1}"
  for path in $(ls "${BASH_IT}/${file_type}/available/"[^_]*); do
    if [ ! -d "${BASH_IT}/${file_type}/enabled" ]; then
      mkdir "${BASH_IT}/${file_type}/enabled"
    fi
    file_name="${path##*/}"
    while true; do
      read -p "Would you like to enable the ${file_name%%.*}${file_type}? [Y/N] " RESP
      case ${RESP} in
        [yY])
          ln -s "${path}" "${BASH_IT}/${file_type}/enabled"
          break
        ;;
        [nN])
          break
        ;;
        *)
          echo "Please choose y or n."
        ;;
      esac
    done
  done
}

for type in "aliases" "plugins" "completion"; do
  while true; do
    prompt=("Enable ${type}: Would you like to enable all, some, or" \
        "no ${type}? Some of these may make bash slower to start up" \
        "(especially completion).")
    read -p "${prompt[*]} [all/some/none] " RESP
    case ${RESP} in
      some)
        load_some "${type}"
        break
      ;;
      all)
        load_all "${type}"
        break
      ;;
      none)
        break
      ;;
      *)
        echo "Unknown choice. Please enter some, all, or none"
        continue
      ;;
    esac
  done
done

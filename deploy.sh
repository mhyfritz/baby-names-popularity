#! /usr/bin/env sh

set -e

npm run build
cd dist

if [ -n "${ACTIONS_DEPLOY_KEY}" ]; then
    SSH_DIR="${HOME}/.ssh"
    mkdir "${SSH_DIR}"
    ssh-keyscan -t rsa github.com > "${SSH_DIR}/known_hosts"
    echo "${ACTIONS_DEPLOY_KEY}" > "${SSH_DIR}/id_rsa"
    chmod 400 "${SSH_DIR}/id_rsa"

    git config --global user.name "${GITHUB_ACTOR}"
    git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
fi

git init
git add -A
git commit -m 'deploy'

git push -f git@github.com:mhyfritz/baby-names-popularity.git master:gh-pages
#!/bin/bash
set -e
cd "$(dirname $0)";

rm -rf dist
yarn build

if [[ $TRAVIS ]]; then
  SSH_KEY=deploy_key.pem
  chmod 600 $SSH_KEY
  eval `ssh-agent -s`
  ssh-add $SSH_KEY
  git config --global user.name "$(git --no-pager show -s --format='%an')"
  git config --global user.email "$(git --no-pager show -s --format='%ae')"
fi

REPO=$(git config remote.origin.url)
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
REPO_DIR=$(mktemp -d /tmp/deploy.XXXXXX)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
REV=$(git rev-parse HEAD)
TARGET_DIR="$REPO_DIR/branches/$BRANCH/"

git clone --branch gh-pages ${REPO} ${REPO_DIR}

if [ ! "$BRANCH" = "master" ]; then
  exit 0
fi

rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR
cp -r ./dist/* $TARGET_DIR

echo $SSH_REPO
cd $REPO_DIR
git add -A .
git commit --allow-empty -m "Built for $BRANCH ($REV)"
git push $SSH_REPO gh-pages

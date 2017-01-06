#!/bin/bash
set -e
cd "$(dirname $0)";
KEY="deploy_key.pem"
PUBLIC_KEY="$KEY.pub"
# rm "$KEY" "$PUBLIC_KEY"
ssh-keygen -f "$KEY" -P "" -t rsa -b 4096 -C "$(git config user.email)" > /dev/null
travis encrypt-file "$KEY" --add
echo "Add This key to the github repository:"
cat "$PUBLIC_KEY"
rm "$KEY" "$PUBLIC_KEY"
git add "$KEY.enc"
git add .travis.yml
git commit -m "Setup Travis deploy_key"
git push origin

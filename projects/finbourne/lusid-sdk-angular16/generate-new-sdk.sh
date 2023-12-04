#!/bin/bash -e

root=$(cd `dirname $0`/../../.. && pwd)
echo "root: $root"

ngVersion=16
project_folder=finbourne/lusid-sdk-angular16
project_name=@$project_folder
service=api

pushd src/lib
echo "generating files"
$root/api-clients/lusid/generate-lusid-client.sh $service $ngVersion
popd

echo "removing old files"
echo "  rm -rf $root/dist/$project_folder/ " && rm -rf $root/dist/$project_folder/

pushd $root
echo "Building libaray: npm ci && npm run build -- $project_name" && npm ci && npm run build -- $project_name
echo
pushd dist/$project_folder
echo "packaging and pushing the generated code"
npm publish . --access public
popd

popd

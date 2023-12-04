#!/bin/bash 

service=$1
ngVersion=$2
useLocalCli="false"

baseUrl="https://www.lusid.com"
swaggerUrl=$baseUrl/$service/swagger/v0/swagger.json
generatorVersion=6.6.0
scriptDir=$(pwd)
outputDir=.generated

echo "About to generate a client for '$service' from $swaggerUrl for Angular version $ngVersion"
echo "    using generator version $generatorVersion"
echo "    code will be created in $scriptDir/$outputDir"

# remove any existing generated code
rm -rf $scriptDir/$outputDir

# generate the code
if [ $useLocalCli = "true" ]
then
  echo "Generating using local openapi-generator-cli"
  openapi-generator-cli version-manager set $generatorVersion
  openapi-generator-cli generate \
        -g typescript-angular \
        -o $scriptDir/$outputDir \
        -i $swaggerUrl \
        --type-mappings object=any \
        --type-mappings Object=any \
        --type-mappings=DateTime=string \
        --additional-properties supportsES6=true \
        --additional-properties ngVersion=$ngVersion
else
  echo "Generating using docker hosted openapi-generator-cli"
  MSYS_NO_PATHCONV=1 docker run --rm -v $scriptDir:/local \
      openapitools/openapi-generator-cli:v$generatorVersion generate \
        -g typescript-angular \
        -o /local/$outputDir \
        -i $swaggerUrl \
        --type-mappings object=any \
        --type-mappings Object=any \
        --type-mappings=DateTime=string \
        --additional-properties supportsES6=true \
        --additional-properties ngVersion=$ngVersion
fi
echo "Files generated"
echo

# set the version number
pushd $scriptDir/
package_json=../../package.json
openapi_version=$(cat .generated/api/portfolios.service.ts | grep "\* The version of the OpenAPI document: " | sed 's/\* The version of the OpenAPI document: //' | xargs)
echo "Updating version in package.json to '$openapi_version'"
cat $package_json | jq -r --arg SDK_VERSION "$openapi_version" '.version |= $SDK_VERSION' > temp && mv temp $package_json
popd

# Handle the issue with the generated model/params.ts exporting a DataType class, which we also generate
if [ -f $scriptDir/$outputDir/index.ts ]; then
  echo "Aliasing the export of generated param.ts from $scriptDir/$outputDir/index.ts (otherwise DataType is declared in 2 places)"
  sed -i "s@export \* from './param'@export \* as OpenApi from './param'@" $scriptDir/$outputDir/index.ts
  echo
fi

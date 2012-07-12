#!/bin/bash

if [ $# -ne 1 ] || ( [ "$1" != "Debug" ] && [ "$1" != "Release" ] ); then
    echo -e "Copy this script in the RestKit source code folder and call it with"
    echo -e "\t $ ./pack_restkit_as_framework.sh [Debug|Release]"
    exit 1
fi

# Sets the target folders and the final framework product.
FMK_NAME=RestKit
FMK_VERSION=A
FMK_CONFIG=$1
BASEDIR=`pwd`

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${BASEDIR}/Build/${FMK_NAME}.framework

LIBDIR="${BASEDIR}/Build/Products/${FMK_CONFIG}-iphoneos"
SIMULATORDIR="${BASEDIR}/Build/Products/${FMK_CONFIG}-iphonesimulator"

# Build both architectures.
xcodebuild -configuration "${FMK_CONFIG}" -target "${FMK_NAME}" -sdk iphoneos
xcodebuild -configuration "${FMK_CONFIG}" -target "${FMK_NAME}" -sdk iphonesimulator

# Cleaning the oldest framework.
if [ -d "${INSTALL_DIR}" ]; then rm -rf "${INSTALL_DIR}"; fi

# Create and renew the framework folder.
mkdir -p "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}/Versions"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Libraries"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers"
ln -s "${FMK_VERSION}" "${INSTALL_DIR}/Versions/Current"
ln -s "Versions/Current/Headers" "${INSTALL_DIR}/Headers"
ln -s "Versions/Current/Resources" "${INSTALL_DIR}/Resources"
ln -s "Versions/Current/Libraries" "${INSTALL_DIR}/Libraries"
#ln -s "Versions/Current/${FMK_NAME}" "${INSTALL_DIR}/${FMK_NAME}"

# Copy the headers and resources files to the framework folder.
# We choose to use the iphoneos build, the 2 dirs should contain the same files
ditto "${BASEDIR}/Build/Headers/RestKit/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers/"

# Copy the resources bundle
cp -R "${BASEDIR}/RestKitResources.bundle" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/"

# We choose to iterate over the iphoneos, the 2 dirs should contain the same files
cd ${LIBDIR}
for part1 in `find . -name lib\*.a` ; do
  part2="`echo $part1 | sed 's/^\./${SIMULATORDIR}/g'`";
  part3="`echo $part1 | sed 's/^\./${INSTALL_DIR}\/Libraries/g'`";
  eval lipo -create "$part1" "$part2" -output "$part3";
done

exit 0

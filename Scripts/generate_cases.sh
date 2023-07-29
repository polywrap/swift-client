#!/bin/bash

set -euo pipefail

REPO_NAME="wrap-test-harness"
TAG="0.2.0"
SOURCE_FOLDER="../Tests/Cases"
TMP_FOLDER="${SOURCE_FOLDER}/tmp"
CASES_ZIP="${TMP_FOLDER}/cases.zip"

# Ensure Cases directory exists
if [[ ! -d "${SOURCE_FOLDER}" ]]; then
    echo "Creating Cases directory at ${SOURCE_FOLDER}"
    mkdir -p "${SOURCE_FOLDER}"
fi

# Create temporary folder
if [[ ! -d "${TMP_FOLDER}" ]]; then
    echo "Creating temporary directory at ${TMP_FOLDER}"
    mkdir -p "${TMP_FOLDER}"
fi

# Download the zip file
URL="https://github.com/polywrap/${REPO_NAME}/releases/download/${TAG}/wrappers"
echo "Fetching wrappers from ${URL}"
if ! curl -L "${URL}" --output "${CASES_ZIP}"; then
    echo "Failed to download wrappers from ${URL}"
    exit 1
fi

# Unzip and delete the zip file
echo "Unzipping wrappers"
if ! unzip -o "${CASES_ZIP}" -d "${SOURCE_FOLDER}"; then
    echo "Failed to unzip wrappers"
    exit 1
fi

# Clean up
echo "Cleaning up temporary files"
rm -rf "${TMP_FOLDER}"

echo "Wrappers folder fetch successful"

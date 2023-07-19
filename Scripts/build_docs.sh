set -e # Helps to give error info

cd ../

# xcodebuild docbuild -scheme PolywrapClient -derivedDataPath ./DocsTemp -destination 'platform=macOS'

# echo "Copying DocC archives to doc_archives..."

# mkdir -p doc_archives

# cp -R `find DocsTemp -type d -name "*.doccarchive"` doc_archives

# mkdir -p docs

# for ARCHIVE in doc_archives/*.doccarchive; do
#     cmd() {
#         echo "$ARCHIVE" | awk -F'.' '{print $1}' | awk -F'/' '{print tolower($2)}'
#     }
#     ARCHIVE_NAME="$(cmd)"
#     echo "Processing Archive: $ARCHIVE"
#     echo "Archive name: $ARCHIVE_NAME"
# done
$(xcrun --find docc) process-archive transform-for-static-hosting doc_archives/PolywrapClient.doccarchive --hosting-base-path polywrapclient --output-path docs/polywrapclient
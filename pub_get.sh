#!/bin/bash

dart_projects=($(find . -type f -name "pubspec.yaml"))

for project in "${dart_projects[@]}"
do
  dir=`dirname "$project"`
  echo "Running pub get in $dir"
  (cd "$dir"; dart pub get)
  echo ""
done

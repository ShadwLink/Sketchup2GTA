#!/bin/bash
mkdir ./build
cd src
zip -r ../build/shadowlink_gta_exporter.rbz ./shadowlink_gta_exporter ./shadowlink_gta_exporter.rb
cd -

# Copy script to output dir if defined
if [ ! -z "$1" ];
then
  mv ./build/shadowlink_gta_exporter.rbz "$1"
fi
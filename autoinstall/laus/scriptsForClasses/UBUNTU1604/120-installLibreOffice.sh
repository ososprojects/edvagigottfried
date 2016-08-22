#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

## LibreOffice full Package

apt-get -y install libreoffice libreoffice-report-builder libreoffice-writer2latex writer2latex libreoffice-help-de

## LibreOffice German Languagepackage
## LibreOffice German Dictionary
## additional Libreoffice - Packages
## Vorschau von Libreoffice - Documenten im Firefox - Browser

apt-get -y install libreoffice-l10n-de hyphen-de mythes-de hunspell hunspell-de-at libreoffice-pdfimport 
# browser-plugin-libreoffice

# Repair broken HSQL - dependency in deb package
apt-get -y install libhsqldb-java



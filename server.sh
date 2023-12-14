#!/bin/bash

source .env
bundle exec rackup -s puma -p ${PUMA_PORT:-9292}

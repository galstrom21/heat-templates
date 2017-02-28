#!/bin/bash
set -eux

pip install os-collect-config os-apply-config os-refresh-config dib-utils heat-cfntools wrapt netaddr rfc3986 pytz positional funcsigs pyparsing

cfn-create-aws-symlinks

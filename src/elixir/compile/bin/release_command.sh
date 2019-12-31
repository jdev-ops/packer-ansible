#!/usr/bin/env bash

rm -Rf deps
rm -Rf _build


ssh-agent

mix local.rebar --force
mix local.hex --force

make release


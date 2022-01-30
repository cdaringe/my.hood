import type { Task, Tasks } from "https://deno.land/x/rad/src/mod.ts";

const buildS: string = `dune build @fmt --auto-promote`;
const build: Task = buildS;
const watch: Task = `${build} -w`;
const test: Task = `dune test`;
// OSX & openssl are grumpy together, as osx ships some old version, but ocaml libs need the good stuff
// PKG_CONFIG_PATH="$(brew --prefix openssl)/lib/pkgconfig:$PKG_CONFIG_PATH"
const install: Task = `opam install dune && opam install . -y --deps-only --with-doc --with-test --locked && dune build && opam install . --deps-only`;
const exportSwitch: Task = `opam switch export ./switch`;
const format: Task = `opam exec -- dune build @fmt --auto-promote`;
const site: Task = `npx concurrently --raw "npx parcel serve src/bin/site/index.html" "dune build -w"`;
const opam = {
  ...{ build, b: build },
  ...{ format, f: format },
  exportSwitch,
  i: install,
  install,
  watch,
  ...{ s: site, site },
  t: test,
  test,
  w: watch,
};

export const tasks: Tasks = {
  ...opam,
};

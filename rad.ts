import type { Task, Tasks } from "https://deno.land/x/rad/src/mod.ts";

const buildS: string = `dune build @fmt --auto-promote`;
const build: Task = buildS;
const watch: Task = `${build} -w`;
const test: Task = `dune test`;
const install: Task = `opam install dune && opam install . --deps-only --locked && dune build && opam install . --deps-only`;
const exportSwitch: Task = `opam switch export ./switch`;
const opam = {
  b: build,
  build,
  exportSwitch,
  i: install,
  install,
  watch,
  t: test,
  test,
  w: watch,
};

export const tasks: Tasks = {
  ...opam,
};

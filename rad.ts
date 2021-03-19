import type { Task, Tasks } from "https://deno.land/x/rad/src/mod.ts";

const buildS: string = `dune build @fmt --auto-promote`;
const build: Task = buildS;
const watch: Task = `${build} -w`;
const test: Task = `dune test`;
const exportSwitch: Task = `opam switch export ./switch`;
const opam = { b: build, build, exportSwitch, watch, t: test, test, w: watch };

export const tasks: Tasks = {
  ...opam,
};

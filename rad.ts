import type { Task, Tasks } from "https://deno.land/x/rad/src/mod.ts";

// const createSwitch: Task = `opam switch create . 4.12.0`;
const watch: Task = `dune build @fmt --auto-promote -w`;
const createSwitch: Task = `echo wee`;
const importSwitch: Task = {
  dependsOn: [
    /*createSwitch*/
  ],
  fn: ({ sh }) =>
    sh(`opam switch --description my.hood import ./switch --switch .`),
};
const exportSwitch: Task = `opam switch export ./switch`;
const opam = { createSwitch, importSwitch, exportSwitch, watch, w: watch };

export const tasks: Tasks = {
  ...opam,
  init: importSwitch,
  precommit: {
    dependsOn: [opam.exportSwitch],
  },
};

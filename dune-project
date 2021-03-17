(lang dune 2.7)
(generate_opam_files true)
(source (github cdaringe/my.hood))
(license ISC)
(authors "cdaringe")
(maintainers "cdaringe")

(package
 (name hood)
 (synopsis "a fun game")
 (description "best game")
 (depends
  (alcotest (and :dev (= 1.3.0)))
  (dune (and :dev (> 1.5)))
  (ocaml (>= 4.11.0))
  (ocaml-lsp-server (and :dev (> 1.5) (< 2.0)))
 )
)

|%
+$  build-state
  $:  =bowl:gall
      repo-info
      =build-cache
      cycle=(set seen-file)
  ==
+$  build-cache  (map @ux vase)
+$  seen-file
  $%  [%build =path]
  ==
+$  repo-info
  $:  repo-host=@p
      repo-name=@tas
      branch-name=@tas
      commit-hash=(unit @ux)
      files=(set path)
  ==
--

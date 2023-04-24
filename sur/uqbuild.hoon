|%
+$  state-0
  $:  %0
      =build-cache
  ==
::
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
  ==
::
+$  action
  $%  $:  %build
          =poke-src
          repo-host=@p
          repo-name=@tas
          branch-name=@tas
          commit-hash=(unit @ux)
          file-path=path
      ==
  ==
+$  update
  $%  [%build result=(each vase @t)]
  ==
+$  poke-src
  $@  ~
  $%  [%app p=@tas]
      [%ted p=@tatid]
  ==
--

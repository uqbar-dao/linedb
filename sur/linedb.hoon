|%
::
::  linedb structures
::
+$  line  @ud
+$  hash  @ux
+$  file  wain :: ((mop line cord) lth) - doesn't help unless we rewrite clay to be mop based instead of wain based
+$  diff  (urge:clay cord)
+$  snap  (map path file) :: maybe use $axal and +of
+$  commit
  $:  =hash
      parent=hash
      author=@p
      time=@da
      =snap
  ==
+$  branch
  $:  head=hash
      commits=(list commit) :: TODO ((mop @da commit) gth)
      :: TODO label-index=(map label commit)
      hash-index=(map hash commit)
  ==
++  sss-paths  ,[@tas @tas ~] :: /repo/branch
::
::  uqbuild structures
::
+$  build-cache  (map @ux vase)
::
+$  seen-file
  $%  [%build =path]
  ==
::
+$  poke-src
  $@  ~
  $%  [%app p=@tas]
      [%ted p=@tatid]
  ==
::
+$  build-state
  $:  =build-cache
      cycle=(set seen-file)
  ==
::
+$  action
  $%  ::  %linedb actions
      ::
      [%commit repo=@tas branch=@tas =snap]
      [%delete repo=@tas branch=@tas]
      [%reset repo=@tas branch=@tas =hash]
      [%merge from=@p repo=@tas branch=@tas incoming=@tas]
      [%branch from=@p repo=@tas branch=@tas name=@tas]
      [%fetch from=@p repo=@tas branch=@tas]
      ::  %uqbuild action
      ::
      $:  %build 
          =poke-src
          repo-host=@p
          repo-name=@tas
          branch-name=@tas
          commit-hash=(unit @ux)
          file-path=path
      ==
  ==
--

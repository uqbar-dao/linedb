|%
::
::  linedb structures
::
+$  hash  @ux
+$  file  wain :: ((mop line cord) lth) - doesn't help unless we rewrite clay to be mop based instead of wain based
+$  diff  (urge:clay cord)
+$  snap  (map path file) :: maybe use $axal and +of
+$  ceta
  $:  =hash
      parent=hash
      author=@p
      time=@da
  ==
+$  commit
  $:  =ceta
      =snap
  ==
+$  branch
  $:  log=(list ceta)
      commits=(map hash commit)
  ==
++  sss-paths  ,[@tas @tas ~] :: /repo/branch
::
::  uqbuild structures
::
+$  poke-src
  $@  ~
  $%  [%app p=@tas]
      [%ted p=@tatid]
  ==
::
+$  build-state
  $:  =snap
      cache=(map @ux vase)
      cycle=(set path)
  ==
::
+$  action
  $%  ::  %linedb actions
      ::
      [%commit repo=@tas branch=@tas =snap]
      [%merge from=@p repo=@tas branch=@tas incoming=@tas]
      [%squash from=@p repo=@tas branch=@tas =hash]
      [%delete repo=@tas branch=@tas]
      [%reset repo=@tas branch=@tas =hash]
      [%branch from=@p repo=@tas branch=@tas name=@tas]
      [%fetch from=@p repo=@tas branch=@tas]
      ::  %uqbuild action
      ::
      [%install from=@p repo=@tas branch=@tas bill=(list dude:gall)] :: put into clay
      $:  %build 
          from=@p
          repo=@tas
          branch=@tas
          file=path
          =poke-src
          :: commit-hash=(unit @ux)
      ==

  ==
+$  update
  $%  [%build result=(each vase @t)]
==
--

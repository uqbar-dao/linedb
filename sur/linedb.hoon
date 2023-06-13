|%
::
::  linedb structures
::
+$  hash  @ux
+$  file  wain :: ((mop line cord) lth) - doesn't help unless we rewrite clay to be mop based instead of wain based
+$  diff  (urge:clay cord)
+$  snap  (map path file) :: maybe use $axal and +of
+$  meta
  $:  =hash
      parent=hash
      author=@p
      time=@da
  ==
+$  commit
  $:  =meta
      =snap
  ==
+$  branch
  $:  log=(list meta)
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
+$  pile-imports
  $:  sur=(list taut:clay)
      lib=(list taut:clay)
      raw=(list [face=term =path])
      bar=(list [face=term =mark =path])
  ==
+$  build-state
  $:  =snap
      cache=build-cache
      cycle=(set path)
      today=@da
  ==
+$  build-cache
  $+  linedb-build-cache
  (pair (map @ux vase) (jug @da @ux))
::
+$  action
  $+  linedb-action
  $%  ::  %linedb actions
      ::
      [%commit repo=@tas branch=@tas =snap]
      [%merge repo=@tas branch=@tas host=@p incoming=@tas]
      [%squash from=@p repo=@tas branch=@tas =hash]
      [%delete repo=@tas branch=@tas]
      [%reset repo=@tas branch=@tas =hash]
      [%branch from=@p repo=@tas branch=@tas name=@tas]
      [%fetch from=@p repo=@tas branch=@tas]
      [%fork repo=@tas branch=@tas new-repo=@tas]
      ::  %uqbuild action
      ::
      [%install from=@p repo=@tas branch=@tas hash=(unit hash)] :: put into clay
      [%make-install-args from=@p repo=@tas branch=@tas hash=(unit hash) =poke-src]
      $:  %build 
          from=@p
          repo=@tas
          branch=@tas
          hash=(unit hash)
          file=path
          =poke-src
      ==
      [%clear-cache before=@da]
  ==
+$  update
  $+  linedb-update
  $@  ~
  $%  [%build result=(each vase tang)]
      [%make-install-args result=(each [@tas yoki:clay rang:clay] @t)]
      [%new-data =path]
==
--

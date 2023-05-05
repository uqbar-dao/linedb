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
::::::
::
::  uqbuild structures
::
+$  leak                                               ::  cache key
  ::  This includes all build inputs, transitives included
  $~  [*path ~]
  $:  =path
      deps=(set leak)
  ==
::
::  $flue: per-branch cache
::     TODO not sure if we actually need the flue
::
+$  flue  [spill=(set leak) sprig=(map path [=leak =vase])]
+$  flow  (map leak [refs=@ud =vase])                  ::  global cache
+$  pour  (each vase tang)                             ::  build result
::
::::::
+$  poke-src
  $@  ~
  $%  [%app p=@tas]
      [%ted p=@tatid]
  ==
::
+$  action
  $%  ::  %linedb actions
      ::
      [%commit repo=@tas branch=@tas =snap]
      [%merge from=@p repo=@tas branch=@tas host=@p incoming=@tas]
      [%squash from=@p repo=@tas branch=@tas =hash]
      [%delete repo=@tas branch=@tas]
      [%reset repo=@tas branch=@tas =hash]
      [%branch from=@p repo=@tas branch=@tas name=@tas]
      [%fetch from=@p repo=@tas branch=@tas]
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
  ==
+$  update
  $@  ~
  $%  [%build result=(each vase tang)]
      [%make-install-args result=(each [@tas yoki:clay rang:clay] @t)]
      [%new-data =path]
==
--

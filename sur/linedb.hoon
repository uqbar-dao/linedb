|%
+$  line  @ud
+$  hash  @uvH
+$  file  wain :: ((mop line cord) lth) - doesn't help unless we rewrite clay to be mop based instead of wain based
+$  diff  (urge:clay cord)
+$  snap  (map path file) :: maybe use $axal and +of 
+$  commit
  $:  =hash
      parent=hash
      author=ship
      time=@da
      =snap
  ==
+$  branch
  $:  head=hash
      commits=(list commit)
      hash-index=(map hash commit)
  ==
::
+$  repo-metadata
  $:  upstream=ship
      active=@tas
  ==
+$  repo  (pair repo-metadata (map @tas branch))
::
+$  action
  $%  [%create name=@tas]
      [%commit repo=@tas =snap]
      [%branch repo=@tas name=@tas]
      [%delete repo=@tas name=@tas]
      [%focus repo=@tas branch=@tas]
      [%merge repo=@tas branch=@tas]
      [%reset repo=@tas =hash]
  ==
--

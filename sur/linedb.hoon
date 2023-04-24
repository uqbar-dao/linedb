|%
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
::
+$  action
  $%  [%commit repo=@tas branch=@tas =snap]
      [%delete repo=@tas branch=@tas]
      [%reset repo=@tas branch=@tas =hash]
      [%merge from=@p repo=@tas branch=@tas incoming=@tas]
      [%branch from=@p repo=@tas branch=@tas name=@tas]
      [%fetch from=@p repo=@tas branch=@tas]
      [%park from=@p repo=@tas branch=@tas]  :: TODO get more than just head
  ==
::
++  sss-paths  ,[@tas @tas ~] :: /repo/branch
--

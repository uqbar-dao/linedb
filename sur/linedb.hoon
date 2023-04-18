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
+$  action
  $%  [%commit repo=@tas branch=@tas =snap]
      [%delete repo=@tas branch=@tas]
      [%reset repo=@tas branch=@tas =hash]
      [%merge repo=@tas branch=@tas from=@p incoming=@tas]
      [%branch who=@p repo=@tas from=@tas name=@tas]
      [%fetch who=@p repo=@tas branch=@tas]
  ==
::
++  sss-paths  ,[@tas @tas ~] :: /repo/branch
--

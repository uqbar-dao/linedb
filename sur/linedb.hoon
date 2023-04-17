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
  $%  ::[%reset branch=sss-paths =hash]
      [%commit branch=sss-paths =snap]
      :: [%branch branch=sss-paths name=sss-paths]
      [%delete branch=sss-paths]
      :: [%merge branch=sss-paths branch=@tas]
      [%fork branch=sss-paths]
  ==
::
+$  sss-paths  ,[@tas @tas ~]  :: /repo/branch
--

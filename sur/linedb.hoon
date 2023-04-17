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
      :: [%branch repo=@tas from=@tas name=@tas]
      :: [%merge repo=@tas branch=@tas bob=@tas]
  ==
:: TODO idk why this has to live at the top of /app/linedb/hoon instead of here
:: +$  sss-paths  ,[@tas @tas ~]  :: /repo/branch :: actually this should probably just be anything goes
--

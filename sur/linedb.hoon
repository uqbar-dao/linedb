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
      :: [%branch repo=@tas from=@tas name=@tas]
      [%delete repo=@tas branch=@tas] :: NOTE this doesn't actually delete it bc referential transparency
      [%merge repo=@tas branch=@tas bob=@tas]
      :: [%reset repo=@tas branch=@tas =hash] :: resets aren't possible due to ref transparency
  ==
:: TODO idk why this has to live at the top of /app/linedb/hoon instead of here
:: +$  sss-paths  ,[@tas @tas ~]  :: /repo/branch :: actually this should probably just be anything goes
--

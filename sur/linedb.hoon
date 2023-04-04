|%
::  snaps are full document sets with all lines
::
::  a branch is an ordered history of snaps.
::
::  to add a commit to a branch, simply call +add-commit:branch
::  with your files
::
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
+$  repo-metadata
  $:  upstream=ship
      active-branch=@tas
  ==
+$  repo  (pair repo-metadata (map @tas branch))
::
+$  action
  $%  [%new-repo name=@tas]
      [%commit repo=@tas =snap]
      [%branch repo=@tas name=@tas]
      [%delete-branch repo=@tas name=@tas]
      [%checkout repo=@tas branch=@tas]
      [%merge repo=@tas branch=@tas]
      [%reset repo=@tas branch=@tas =hash]
  ==
::
+$  fetch
  $%  [%ask who=ship repo=@tas]
      [%request repo=@tas]
      [%response name=@tas =repo]
      :: [%deny ~] :: TODO add permissions
  ==
::
:: ++  file-on  ((on line cord) lth)
::
:: ++  file-to-wain  |=(=file `wain`(turn (tap:file-on file) tail))
:: ++  file-to-cord  |=(=file (of-wain:format (file-to-wain file)))
:: ++  cord-to-wain  to-wain:format
:: ++  cord-to-file  |=(=cord (wain-to-file (cord-to-wain cord)))
:: ++  wain-to-file
::   |=  =wain
::   %+  gas:file-on  *file
::   p:(spin wain 0 |=([t=@t i=@] [[i t] +(i)]))
--

|%
::  snapshots are full document sets with all lines
::  structural sharing makes this efficient?
::
::  a branch is an ordered history of snapshots.
::  make a new branch by selecting an existing one to go off
::
::  to add a commit to a branch, simply call +add-commit:branch
::  with your files
::
+$  index     @ud
+$  line      @ud
+$  hash      @uvH
+$  file      ((mop line cord) lth)
+$  diff      (urge:clay cord)
+$  snapshot  (map path file)
+$  commit
  $:  =hash
      parent=hash
      author=ship
      time=@da
      =snapshot
      diffs=(map path diff)
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
  $%  [%commit repo=@tas =snapshot]
      [%branch repo=@tas name=@tas]
      [%checkout repo=@tas branch=@tas]
      [%merge repo=@tas branch=@tas]
      :: [%fetch =ship repo=@tas branch=_%master]
  ==
::
++  file-on  ((on line cord) lth)
::
++  file-to-wain  |=(=file `wain`(turn (tap:file-on file) tail))
++  file-to-cord  |=(=file (of-wain:format (file-to-wain file)))
++  cord-to-wain  to-wain:format
++  cord-to-file  |=(=cord (wain-to-file (cord-to-wain cord)))
++  wain-to-file
  |=  =wain
  %+  gas:file-on  *file
  p:(spin wain 0 |=([t=@t i=@] [[i t] +(i)]))
--

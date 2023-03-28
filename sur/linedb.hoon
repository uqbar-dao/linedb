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
+$  file      (mop line cord)
+$  diff      (urge:clay cord)
+$  snapshot  (map path file)
+$  commit
  $:  hash=@ux
      author=ship
      message=@t
      time=@da
      =snapshot
      diffs=(map path diff)
  ==
+$  branch
  $:  commits=(list commit)
      hash-index=(map hash commit)
      head=hash
  ==
::
++  snap-on  ((on index commit) lth)
++  file-on  ((on line cord) lth)
::
++  mop-to-wain  |=(=file `wain`(turn (tap:file-on file) tail))
--

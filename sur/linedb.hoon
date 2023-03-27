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
+$  index      @ud
+$  line       @ud
+$  file       wain :: TODO ordered map gives you more structural sharing
+$  diff       (urge:clay cord)
+$  snapshot   (map path file)
+$  commit
  $:  author=ship
      =snapshot
      diffs=(map path diff)
  ==
+$  branch
  $:  snaps=((mop index commit) lth)
      head=index
  ==
::
++  snap-on  ((on index commit) lth)
--

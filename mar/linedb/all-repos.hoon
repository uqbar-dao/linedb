/+  linedb
::
|_  repos=(list [ship path])
++  grab
  |%
  ++  noun  (list [ship path])
  --
::
++  grow
  |%
  ++  noun  repos
  ++  json  (all-repos:enjs:linedb repos)
  --
::
++  grad  %noun
--

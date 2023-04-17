/-  *linedb
|%
++  name  %branch
+$  rock  branch
+$  wave  commit
++  wash
  :: TOOD: a git reset needs a delete function here 
  |=  [=rock =wave]
  %=  rock
    head        hash.wave
    commits     [wave commits.rock]
    hash-index  (~(put by hash-index.rock) hash.wave wave)
  ==
--
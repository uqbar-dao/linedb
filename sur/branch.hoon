/-  *linedb
|%
++  name  %branch
+$  rock  branch
+$  wave  commit
++  wash
  |=  [=rock =wave]
  %=  rock
    head        hash.wave
    commits     [wave commits.rock]
    hash-index  (~(put by hash-index.rock) wave)
  ==
--
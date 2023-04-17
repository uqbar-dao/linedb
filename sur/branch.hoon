/-  *linedb
|%
++  name  %branch
+$  rock  branch
+$  wave
  $%  [%commit =commit]
      [%reset =hash]
      [%delete ~]
  ==
++  wash
  |=  [=rock =wave]
  ^+  rock
  ?-    -.wave
      %commit
    %=  rock
      head        hash.commit.wave
      commits     [+.wave commits.rock]
      hash-index  (~(put by hash-index.rock) [hash.commit commit]:wave)
    ==
  ::
      %reset
    ?.  (~(has by hash-index.rock) hash.wave)  !! :: TODO error message
    |-
    ?~  commits.rock  !!  ::  should never happen
    ?:  =(hash.i.commits.rock hash.wave)
      =.  head.rock  hash.wave
      rock
    =.  hash-index.rock
      (~(del by hash-index.rock) hash.i.commits.rock)
    $(commits.rock t.commits.rock)
  ::
      %delete  *branch
  ::
  ==
--
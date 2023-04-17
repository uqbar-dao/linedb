/-  *linedb
|%
++  name  %branch
+$  rock  branch
+$  wave
  $%  [%commit our=ship now=@da =snap]
      [%squash from=hash to=hash]
      [%reset =hash]
      [%delete ~]
  ==
++  wash
  |=  [=rock =wave]
  ^+  rock
  ?-    -.wave
  ::
      %commit
    =/  com=commit
      :*  (sham snap.wave)
          head.rock
          our.wave
          now.wave
          snap.wave
      ==
    %=  rock
      head        hash.com
      commits     [com commits.rock]
      hash-index  (~(put by hash-index.rock) hash.com com)
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
      %squash
    ^+  rock
    =|  edited=(list commit)
    =|  base=(unit commit)
    =|  continue=?
    =/  commits  (flop commits.rock)
    |-
    ?~  commits
      =.  commits.rock  edited
      rock
    ?:  =(from.wave hash.i.commits)
      $(commits t.commits, base `i.commits)
    ?:  =(to.wave hash.i.commits)
      ?~  base
        ~|("%linedb: squash: out of order, no changes made" !!)
      %=  $
        continue  %.n
        commits   t.commits
        edited    [i.commits(parent ?^(edited hash.i.edited *hash)) edited]
      ==
    ?:  &(?=(^ base) continue)
      $(commits t.commits)
    $(commits t.commits, edited [i.commits edited])
  ::
  ==
--

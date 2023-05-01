/-  *linedb
|%
++  name  %branch
+$  rock  branch
+$  wave
  $%  [%commit our=ship now=@da =snap]
      [%squash from=hash to=hash]
      [%reset =hash]
      [%delete ~] :: TODO unclear if this is good
  ==
++  wash
  |=  [=rock =wave]
  ^+  rock
  ?-    -.wave
  ::
      %commit
    =/  =ceta
      :+  `@ux`(sham snap.wave)
        ?@(log.rock *hash hash.i.log.rock)
      [our now]:wave
    %=  rock
      log      [ceta log.rock]
      commits  (~(put by commits.rock) hash.ceta [ceta snap.wave])
    ==
  ::
      %reset
    ?.  (~(has by commits.rock) hash.wave)  rock
    =+  rok=rock
    |-
    ?~  log.rock  rok  ::  should never happen
    ?:  =(hash.i.log.rock hash.wave)  rock
    =.  commits.rock  (~(del by commits.rock) hash.i.log.rock)
    $(log.rock t.log.rock)
  ::
      %delete  *branch
  ::
      %squash
    ^+  rock
    =|  edited=(list ceta)
    =|  base=(unit ceta)
    =|  continue=?
    =/  log  (flop log.rock)
    |-
    ?~  log
      =.  log.rock  edited
      :: TODO also realized that you need to get rid of commits
      ::   from commits.rock...this is just a terrible function lmao
      rock
    ?:  =(from.wave hash.i.log)
      $(log t.log, base `i.log)
    ?:  =(to.wave hash.i.log)
      ?~  base
        ~|("%linedb: squash: out of order, no changes made" rock)
      %=  $
        continue  %.n
        log       t.log
        edited    [i.log(parent ?^(edited hash.i.edited *hash)) edited]
      ==
    ?:  &(?=(^ base) continue)
      $(log t.log)
    $(log t.log, edited [i.log edited])
  ::
  ==
--

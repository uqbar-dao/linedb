/-  *linedb
/+  ldb=linedb
::
|_  =branch
::
++  ba-core  .
::
::  write arms
::
++  add-commit
  |=  [author=ship time=@da =snap]
  ^+  branch
  =/  =ceta  [`@ux`(sham snap) head author time]
  %=  branch
    log      [ceta log.branch]
    commits  (~(put by commits.branch) hash.ceta [ceta snap])
  ==
::
++  squash
  |=  =hash
  ^+  branch
  =/  hed=commit  head-commit
  =.  branch  (reset:ba-core hash)
  =.  parent.ceta.hed  ~(head ba-core branch)
  (add-commit:ba-core [author.ceta time.ceta snap]:hed)
::
++  merge
  |=  [author=@p time=@da bab=^branch]
  ^+  branch
  =/  bob  ba-core(branch bab)
  =*  ali  .
  ::  TODO ugly
  =/  bas=(unit hash)
      =/  ali-hashes  hashes
      =/  bob-hashes  (silt hashes:bob)
      |-
      ?~  ali-hashes  ~
      ?:  (~(has in bob-hashes) i.ali-hashes)
        `i.ali-hashes
      $(ali-hashes t.ali-hashes)
  ?~  bas  branch
  =*  base  u.bas
  =/  ali-diffs=(map path diff)
    (diff-snaps:di:ldb (get-snap:ali base) head-snap:ali)
  =/  bob-diffs=(map path diff)
    (diff-snaps:di:ldb (get-snap:bob base) head-snap:bob)
  =/  diffs=(map path diff)
    %-  ~(urn by (~(uni by ali-diffs) bob-diffs))
    |=  [=path *]
    ^-  diff
    %+  three-way-merge:di:ldb
      [%current (~(gut by ali-diffs) path *diff)]
    [%incoming (~(gut by bob-diffs) path *diff)]
  =/  new-snap=snap
    ?~  log.branch  *snap
    %-  ~(urn by snap:(~(got by commits.branch) head:ali))
    |=  [=path =file]
    =+  dif=(~(got by diffs) path)
    (apply-diff:di:ldb file dif)
  (add-commit:ba-core author time new-snap)
::
++  reset
  |=  =hash
  ^+  branch
  ?.  (~(has by commits.branch) hash)  branch
  |-
  ?~  log.branch  branch  ::  should never happen
  ?:  =(hash.i.log.branch hash)  branch
  =.  commits.branch  (~(del by commits.branch) hash.i.log.branch)
  $(log.branch t.log.branch)
::
::  read arms
::
++  head            ?:(?=(^ log.branch) hash.i.log.branch *hash)
++  head-commit     (get-commit head)
++  head-snap       (get-snap head)
++  head-file       |=(p=path (get-file head p))
++  head-directory  |=(nedl=path (get-directory head nedl))
::
++  get-commit   |=(h=hash (~(gut by commits.branch) h *commit))
++  get-snap     |=(h=hash snap:(get-commit h))
++  get-file     |=([h=hash p=path] (of-wain:format (~(gut by (get-snap h)) p *wain)))
++  get-directory :: TODO this gets a lot more efficient with an +axal
  |=  [=hash nedl=path]
  ^-  (list [path file])
  %+  murn  ~(tap by (get-snap hash))
  |=  [hstk=path =file]
  ?.  =(`0 (find nedl hstk))  ~
  `[hstk file]
::
++  hashes  (turn log.branch |=(=ceta hash.ceta))
--

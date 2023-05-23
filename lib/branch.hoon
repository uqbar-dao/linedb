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
  |=  [author=ship time=@da diffs=(map path diff)]
  ^+  branch
  =/  =ceta
    [`@ux`(sham [snap head author time]) head author time]
  %=    branch
      log  [ceta log.branch]
      commits
    %+  ~(put by commits.branch)  hash.ceta
    :-  ceta
    %+  apply-diffs:di:ldb
      snap:(~(gut by commits.branch) parent.ceta *commit)
    diffs
  ==
::
++  squash
  |=  =hash
  ^+  branch
  =/  hed=commit  head-commit
  =.  branch  (reset:ba-core hash)
  =.  parent.ceta.hed  ~(head ba-core branch)
  %^  add-commit:ba-core  author.ceta.hed  time.ceta.hed
  (diff-snaps:di:ldb head-snap snap:hed)
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
  (add-commit:ba-core author time diffs)
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
++  get-file     |=([h=hash p=path] (of-wain:format (~(got by (get-snap h)) p)))
++  get-directory :: TODO this gets a lot more efficient with an +axal
  |=  [=hash nedl=path]
  ^-  (list [path file])
  %+  murn  ~(tap by (get-snap hash))
  |=  [hstk=path =file]
  ?.  =(`0 (find nedl hstk))  ~
  `[hstk file]
++  get-file-diff
  |=  [haz=hash hax=hash fil=path]
  ^-  diff
  %+  diff-files:di:ldb
    (~(gut by (get-snap haz)) fil *wain)
  (~(gut by (get-snap hax)) fil *wain)
++  get-snap-diff
  |=  [haz=hash hax=hash]
  ^-  (map path diff)
  (diff-snaps:di:ldb (get-snap haz) (get-snap hax))
::
++  hashes  (turn log.branch |=(=ceta hash.ceta))
--

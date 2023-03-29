/-  *linedb
::
=,  format
=,  differ
|%
++  branch
  =|  [head=hash commits=(list commit) hash-index=(map hash commit)]
  |%
  ::
  ::  write arms
  ::
  ++  add-commit
    |=  [author=ship time=@da new-snap=snapshot]
    ^+  branch
    =+  head-hash=(sham new-snap)
    =/  new-commit=commit
      :*  head-hash
          head
          author
          time
          new-snap
          (build-diff latest-snap new-snap)
      ==
    %=  +>.$
      head         head-hash
      commits     [new-commit commits]
      hash-index  (~(put by hash-index) head-hash new-commit)
    ==
  ::
  ++  set-head
    |=  =hash
    ^+  branch
    ?>  (~(has by hash-index) hash)
    %=    +>.$
        head  hash
        commits
      |-
      ?~  commits  !!  :: should never happen
      ?:  =(hash.i.commits hash)  commits
      $(commits t.commits)
    ==
  ::
  ::  read arms
  ::
  ++  get-commit     |=(h=hash (~(gut by hash-index) h *commit))
  ++  get-snap       |=(h=hash snapshot:(get-commit h))
  ++  get-diffs      |=(h=hash diffs:(get-commit h))
  ++  get-diff       |=([h=hash p=path] (~(got by (get-diffs h)) p))
  ++  get-file       |=([h=hash p=path] (file-to-wain (~(got by (get-snap h)) p)))
  ++  latest-commit  ?^(commits i.commits *commit)
  ++  latest-snap    snapshot:latest-commit
  ++  latest-diffs   diffs:latest-commit
  ++  latest-diff    |=(p=path (~(gut by latest-diffs) p *diff))
  ++  latest-file    |=(p=path (file-to-cord (~(gut by latest-snap) p *file)))
  ::
  ::  helpers
  ::
  ++  build-diff
    |=  [old=snapshot new=snapshot]
    ^-  (map path diff)
    %-  ~(urn by (~(uni by old) new))
    |=  [=path *]
    ^-  diff
    =+  a=(file-to-wain (~(gut by old) path *file))
    =+  b=(file-to-wain (~(gut by new) path *file))
    (lusk:differ a b (loss:differ a b))
  ::
  :: ++  fetch all diffs for a file - IMPORTANT
  ::
  :: for squashing commit N with commit N+1. To squash N commits you must call this N times
  :: copy +join from mar/txt/hoon (minimal edits)
  ++  squash  'todo'
  --
++  line-mapping
  ::  TODO we need a more advanced diff algo if we want individual lines edited
  |=  =diff
  ^-  (map line line)
  =|  iold=@ud
  =|  inew=@ud
  =|  new-lines=(list (pair line line))
  |-
  ?~  diff  (~(gas by *(map line line)) new-lines)
  ?-  -.i.diff
    %&  %=    $
            iold  (add iold p.i.diff)
            inew  (add inew p.i.diff)
            diff  t.diff
            new-lines
          |-
          ?:  =(0 p.i.diff)  new-lines
          %=  $
            new-lines  [[+(iold) +(inew)] new-lines]
            p.i.diff   (dec p.i.diff)
            iold       +(iold)
            inew       +(inew)
          ==
        ==
  ::
    %|  %=  $
          iold  (add iold (lent p.i.diff))
          inew  (add inew (lent q.i.diff))
          diff  t.diff
        ==
  ==
--

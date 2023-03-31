/-  *linedb
::
=,  format
=,  differ
|%
::
::  branch engine
::
++  b
  |_  =branch
  ::
  ::  write arms
  ::
  ++  add-commit
    |=  [author=ship time=@da new-snap=snapshot]
    ^+  branch
    =+  head-hash=(sham new-snap)
    =/  =commit
      :*  head-hash
          head.branch
          author
          time
          new-snap
          (diff-snaps:d head-snap new-snap)
      ==
    %=  branch
      head        head-hash
      commits     [commit commits.branch]
      hash-index  (~(put by hash-index.branch) head-hash commit)
    ==
  ::
  ++  set-head
    |=  =hash
    ^+  branch
    ?>  (~(has by hash-index.branch) hash)
    branch(head hash)
  ::
  ++  squash :: TODO this code is really ugly
    |=  [to=hash from=hash]
    ^+  branch
    =*  coms  commits.branch
    =|  newb=(list commit)
    =|  froc=(unit commit)
    =|  toc=(unit commit)
    |-
    ?~  coms  branch(commits (flop newb))
    ?:  =(to hash.i.coms)
      $(coms t.coms, toc `i.coms, newb [i.coms newb])
    ?:  =(from hash.i.coms)
      ?~  toc  ~|("hashes are out of order" !!)
      =+  new-diffs=(diff-snaps:d snapshot.u.toc snapshot.i.coms)
      $(coms t.coms, newb [i.coms(diffs new-diffs) newb], froc `i.coms)
    ?:  &(?=(^ toc) ?=(~ froc))
      $(coms t.coms)  :: skip everything
    $(coms t.coms, newb [i.coms newb])
  ::
  ::  read arms
  ::
  ++  get-commit   |=(h=hash (~(gut by hash-index.branch) h *commit))
  ++  get-snap     |=(h=hash snapshot:(get-commit h))
  ++  get-diffs    |=(h=hash diffs:(get-commit h))
  ++  get-diff     |=([h=hash p=path] (~(got by (get-diffs h)) p))
  ++  get-file     |=([h=hash p=path] (of-wain:format (~(got by (get-snap h)) p)))
  ++  head-commit  ?^(commits.branch i.commits.branch *commit)
  ++  head-snap    snapshot:head-commit
  ++  head-diffs   diffs:head-commit
  ++  head-diff    |=(p=path (~(gut by head-diffs) p *diff))
  ++  head-file    |=(p=path (of-wain:format (~(gut by head-snap) p *file)))
  ::
  ++  log          (turn commits.branch |=(=commit hash.commit))
  :: ++  detached     =(head hash.i.commits.branch)
  ::
  --
::
::  repo engine
::
++  r
  |_  =repo
  ++  active-branch  (~(got by q.repo) active-branch.p.repo)
  ++  commit-active
    |=  [author=ship time=@da new-snap=snapshot]
    ^+  repo
    =.  q.repo
      %+  ~(jab by q.repo)  active-branch.p.repo
      |=  =branch
      (~(add-commit b active-branch) author time new-snap)
    repo
  ++  checkout
    |=  branch=@tas
    repo(active-branch.p branch)
  ++  new-branch
    |=  name=@tas
    (~(put by q.repo) name active-branch)
  --
::
::  diff operations
::
++  d
  |%
  ++  diff-files
    |=  [old=file new=file]
    (lusk:differ old new (loss:differ old new))
  ::
  ++  line-mapping
    ::  TODO we need a more advanced diff algo if we want individual lines edited
    |=  =diff
    ^-  (map line line)
    =|  iold=@ud
    =|  inew=@ud
    =|  new-lines=(list (pair line line))
    |-
    ?~  diff  (~(gas by *(map line line)) new-lines)
    ?-    -.i.diff
        %&
      %=    $
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
        %|
      %=  $
        iold  (add iold (lent p.i.diff))
        inew  (add inew (lent q.i.diff))
        diff  t.diff
      ==
    ==
  ::
  ++  diff-snaps                                       ::  from two snapshots
    |=  [old=snapshot new=snapshot]
    ^-  (map path diff)
    %-  ~(urn by (~(uni by old) new))
    |=  [=path *]
    %+  diff-files
      (~(gut by old) path *file)
    (~(gut by new) path *file)
  ::
  :: ++  add                                              ::  copied from mar/txt/hoon
  ::   ::  for squashing
  ::   |=  [old=diff new=diff]
  ::   ^-  (unit diff)
  ::   |^
  ::   =.  old  (clean old)
  ::   =.  new  (clean new)
  ::   |-  ^-  (unit diff)
  ::   ?~  old  `new :: TODO this is wrong
  ::   ?~  new  `old :: TODO this is wrong
  ::   ?-    -.i.old
  ::       %&
  ::     ?-    -.i.new
  ::         %& :: good
  ::       ?:  =(p.i.old p.i.new)
  ::         %+  bind  $(old t.old, new t.new)
  ::         |=(=diff [i.old diff])
  ::       ?:  (gth p.i.old p.i.new)
  ::         %+  bind  $(p.i.old (sub p.i.old p.i.new), new t.new)
  ::         |=(=diff [i.new diff])
  ::       %+  bind  $(old t.old, p.i.new (sub p.i.new p.i.old))
  ::       |=(=diff [i.old diff])
  ::     ::
  ::         %| :: TODO
  ::       ?:  =(p.i.old (lent p.i.new))
  ::         %+  bind  $(old t.old, new t.new)
  ::         |=(=diff [i.new diff])
  ::       ?:  (gth p.i.old (lent p.i.new))
  ::         %+  bind  $(p.i.old (sub p.i.old (lent p.i.new)), new t.new)
  ::         |=(=diff [i.new diff])
  ::       ~  :: TODO this shouldn't be ~
  ::     ==
  ::   ::
  ::       %|
  ::     ?-    -.i.new
  ::         %|
  ::       ?:  =(q.i.old p.i.new)
  ::         %+  bind  $(old t.old, new t.new)
  ::         |=(=diff [[p.i.old q.i.new] diff])
  ::       ~  :: TODO
  ::       :: ?:  (gth (lent p.i.new) (lent q.i.old)) :: TODO
  ::       ::   ?~  got=(find q.i.old p.i.new)  ~ :: front of p.i.new contains all of q.i.old
  ::       ::   ?.  =(0 u.got)  ~
  ::       ::   %+  bind  $(old, new)
  ::       ::   |=(=diff [asdf diff])
  ::     ::
  ::         %&
  ::       ?:  =(p.i.new (lent q.i.old))
  ::         %+  bind  $(old t.old, new t.new)
  ::         |=(=diff [i.old diff])
  ::       ?:  (gth p.i.new (lent p.i.old))
  ::         %+  bind  $(old t.old, p.i.new (sub p.i.new (lent p.i.old)))
  ::         |=(=diff [i.old diff])
  ::       ~ :: TODO
  ::     ==
  ::   ==
  ::   ++  clean
  ::     ::  concatenates matching sections of the diff
  ::     |=  wig=diff
  ::     ^-  diff
  ::     ?~  wig  ~
  ::     ?~  t.wig  wig
  ::     ?:  ?=(%& -.i.wig)
  ::       ?:  ?=(%& -.i.t.wig)
  ::         $(wig [[%& (add p.i.wig p.i.t.wig)] t.t.wig])
  ::       [i.wig $(wig t.wig)]
  ::     ?:  ?=(%| -.i.t.wig)
  ::       $(wig [[%| (welp p.i.wig p.i.t.wig) (welp q.i.wig q.i.t.wig)] t.t.wig])
  ::     [i.wig $(wig t.wig)]
  --
--

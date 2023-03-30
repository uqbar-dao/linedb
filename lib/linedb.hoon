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
    =/  new-commit=commit
      :*  head-hash
          head.branch
          author
          time
          new-snap
          (build:d head-snap new-snap)
      ==
    %=  branch
      head        head-hash
      commits     [new-commit commits.branch]
      hash-index  (~(put by hash-index.branch) head-hash new-commit)
    ==
  ::
  ++  set-head
    |=  =hash
    ^+  branch
    ?>  (~(has by hash-index.branch) hash)
    %=    branch
        head  hash :: To see if we are in detached head, check =(head hash.i.commits)
    ==
  ::
  :: ++  squash
  ::   |=  [from=hash to=hash]
  ::   ^+  branch
    :: get sublist of from:to
    :: get all diffs from from:to
    :: +join them into a single commit

  ::
  ::  read arms
  ::
  ++  get-commit   |=(h=hash (~(gut by hash-index.branch) h *commit))
  ++  get-snap     |=(h=hash snapshot:(get-commit h))
  ++  get-diffs    |=(h=hash diffs:(get-commit h))
  ++  get-diff     |=([h=hash p=path] (~(got by (get-diffs h)) p))
  ++  get-file     |=([h=hash p=path] (file-to-wain (~(got by (get-snap h)) p)))
  ++  head-commit  ?^(commits.branch i.commits.branch *commit)
  ++  head-snap    snapshot:head-commit
  ++  head-diffs   diffs:head-commit
  ++  head-diff    |=(p=path (~(gut by head-diffs) p *diff))
  ++  head-file    |=(p=path (file-to-cord (~(gut by head-snap) p *file)))
  ::
  :: ++  fetch all diffs for a file - IMPORTANT
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
  ::
  ++  build                                            ::  from two snapshots
    |=  [old=snapshot new=snapshot]
    ^-  (map path diff)
    %-  ~(urn by (~(uni by old) new))
    |=  [=path *]
    ^-  diff
    =+  a=(file-to-wain (~(gut by old) path *file))
    =+  b=(file-to-wain (~(gut by new) path *file))
    (lusk:differ a b (loss:differ a b))
  ::
  ++  join                                             ::  copied from mar/txt/hoon
    ::  join two diffs
    |=  [ali=diff bob=diff]
    ^-  (unit diff)
    |^
    =.  ali  (clean ali)
    =.  bob  (clean bob)
    |-  ^-  (unit diff)
    ?~  ali  `bob
    ?~  bob  `ali
    ?-    -.i.ali
        %&
      ?-    -.i.bob
          %&
        ?:  =(p.i.ali p.i.bob)
          %+  bind  $(ali t.ali, bob t.bob)
          |=(cud=diff [i.ali cud])
        ?:  (gth p.i.ali p.i.bob)
          %+  bind  $(p.i.ali (sub p.i.ali p.i.bob), bob t.bob)
          |=(cud=diff [i.bob cud])
        %+  bind  $(ali t.ali, p.i.bob (sub p.i.bob p.i.ali))
        |=(cud=diff [i.ali cud])
      ::
          %|
        ?:  =(p.i.ali (lent p.i.bob))
          %+  bind  $(ali t.ali, bob t.bob)
          |=(cud=diff [i.bob cud])
        ?:  (gth p.i.ali (lent p.i.bob))
          %+  bind  $(p.i.ali (sub p.i.ali (lent p.i.bob)), bob t.bob)
          |=(cud=diff [i.bob cud])
        ~
      ==
    ::
        %|
      ?-  -.i.bob
          %|
        ?.  =(i.ali i.bob)
          ~
        %+  bind  $(ali t.ali, bob t.bob)
        |=(cud=diff [i.ali cud])
      ::
          %&
        ?:  =(p.i.bob (lent p.i.ali))
          %+  bind  $(ali t.ali, bob t.bob)
          |=(cud=diff [i.ali cud])
        ?:  (gth p.i.bob (lent p.i.ali))
          %+  bind  $(ali t.ali, p.i.bob (sub p.i.bob (lent p.i.ali)))
          |=(cud=diff [i.ali cud])
        ~
      ==
    ==
    ++  clean
      ::  concatenates matching sections of the diff
      |=  wig=diff
      ^-  diff
      ?~  wig  ~
      ?~  t.wig  wig
      ?:  ?=(%& -.i.wig)
        ?:  ?=(%& -.i.t.wig)
          $(wig [[%& (add p.i.wig p.i.t.wig)] t.t.wig])
        [i.wig $(wig t.wig)]
      ?:  ?=(%| -.i.t.wig)
        $(wig [[%| (welp p.i.wig p.i.t.wig) (welp q.i.wig q.i.t.wig)] t.t.wig])
      [i.wig $(wig t.wig)]
    --
  ::
  ++  join-many :: TODO not sure if this is actually right lmao
    |=  diffs=(list diff)
    ^-  diff
    %+  roll  diffs
    |=([a=diff b=diff] (need (join a b)))
  --
--

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
    |=  [author=ship time=@da new-snap=snap]
    ^+  branch
    =+  head-hash=(sham new-snap)
    =/  =commit
      :*  head-hash
          head.branch
          author
          time
          new-snap
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
    |=  [from=hash to=hash]
    ^+  branch
    =|  edited=(list commit)
    =|  base=(unit commit)
    =|  continue=?
    =/  commits  (flop commits.branch)
    |-
    ?~  commits  branch(commits edited)
    ?:  =(from hash.i.commits)
      $(commits t.commits, base `i.commits)
    ?:  =(to hash.i.commits)
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
  ++  reset  :: hard reset
    |=  to=hash
    ^+  branch
    ?.  (~(has by hash-index.branch) to)
      ~|("%linedb: reset: hash doesn't exist, cannot reset" !!)
    =*  commits  commits.branch
    =*  hash-index  hash-index.branch
    |-
    ?~  commits  !!
    ?:  =(hash.i.commits to)  branch(head to)
    $(commits t.commits, hash-index (~(del by hash-index) hash.i.commits))
  ::
  ::  read arms
  ::
  ++  get-commit   |=(h=hash (~(gut by hash-index.branch) h *commit))
  ++  get-snap     |=(h=hash snap:(get-commit h))
  ++  get-file     |=([h=hash p=path] (of-wain (~(got by (get-snap h)) p)))
  ++  head-commit  ?^(commits.branch i.commits.branch *commit)
  ++  head-snap    snap:head-commit
  ++  head-file    |=(p=path (of-wain (~(gut by head-snap) p *file)))
  ::
  ++  log          (turn commits.branch |=(=commit hash.commit))
  :: ++  detached     =(head hash.i.commits.branch)
  ::
  ++  most-recent-ancestor
    |=  dat=^branch
    ^-  (unit hash)
    =+  dem-hashes=(silt ~(log b dat))
    =/  our-hashes  log
    |-
    ?~  our-hashes  ~
    ?:  (~(has in dem-hashes) i.our-hashes)
      `i.our-hashes
    $(our-hashes t.our-hashes)
  --
::
::  repo engine
::
++  r
  |_  =repo
  ++  active-branch  (~(got by q.repo) active-branch.p.repo)
  ++  commit-active
    |=  [author=ship time=@da new-snap=snap]
    ^+  repo
    =.  q.repo
      %+  ~(jab by q.repo)  active-branch.p.repo
      |=  =branch
      (~(add-commit b active-branch) author time new-snap)
    repo
  ++  checkout
    |=  branch=@tas
    ^+  repo
    repo(active-branch.p branch)
  ++  new-branch
    |=  name=@tas
    ^+  repo
    =.  q.repo
      (~(put by q.repo) name active-branch)
    repo
  ::
  ++  delete-branch
    |=  name=@tas
    ^+  repo
    ?:  =(name active-branch.p.repo)
      ~&("{<name>} is active, cannot delete" repo)
    =.  q.repo  (~(del by q.repo) name)
    repo
  ::
  ++  reset-branch
    |=  [name=@tas =hash]
    ^+  repo
    =.  q.repo
      %+  ~(jab by q.repo)  name
      |=(=branch (~(reset b branch) hash))
    repo
  ::
  ++  merge
    |=  name=@tas
    ^+  repo
    =/  incoming  (~(got by q.repo) name)
    =*  active-index    hash-index:active-branch
    =*  incoming-index  hash-index.incoming
    ?~  base=(~(most-recent-ancestor b active-branch) incoming)
      ~|("%linedb: merge: no common base for {<active-branch>} and {<name>}" !!)
    =/  active-diffs=(map path diff)
      %+  diff-snaps:d
        snap:(~(got by active-index) u.base)
        snap:(~(got by active-index) head:active-branch)
    =/  incoming-diffs=(map path diff)
      %+  diff-snaps:d
        snap:(~(got by incoming-index) u.base)
        snap:(~(got by incoming-index) head.incoming)
    =/  diffs=(map path diff)
      %-  ~(urn by (~(uni by active-diffs) incoming-diffs))
      |=  [=path *]
      ^-  diff
      %+  three-way-merge:d
        [active-branch.p.repo (~(gut by active-diffs) path *diff)]
      [name (~(gut by incoming-diffs) path *diff)]
    =+  br=(~(got by q.repo) active-branch.p.repo)
    =/  new-snap=snap
      ?@  commits.br  *snap
      %-  ~(urn by snap.i.commits.br)
      |=  [=path =file]
      =+  dif=(~(got by diffs) path)
      (lurk file dif)
    (commit-active *@p *@da new-snap) :: TODO
  ::
  ::  read arms
  ::
  ++  branches  (turn ~(tap by q.repo) head)
  --
::
::  diff operations
::
++  d
  |%
  ++  diff-files
    |=  [old=file new=file]
    (lusk old new (loss old new))
  ::
  ++  line-mapping
    ::  TODO we need a more advanced diff algo if we want individual lines edited...diff could be an (urge tape)
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
  ++  diff-snaps                                       ::  from two snaps
    |=  [old=snap new=snap]
    ^-  (map path diff)
    %-  ~(urn by (~(uni by old) new))
    |=  [=path *]
    %+  diff-files
      (~(gut by old) path *file)
    (~(gut by new) path *file)
  ::
  ++  three-way-merge                                    ::  +mash in mar/txt/hoon
    |=  $:  [ald=@tas ali=diff]
            [bod=@tas bob=diff]
        ==
    ^-  diff
    |^
    =.  ali  (clean ali)
    =.  bob  (clean bob)
    |-  ^-  diff
    ?~  ali  bob
    ?~  bob  ali
    ?-    -.i.ali
        %&
      ?-    -.i.bob
          %&
        ?:  =(p.i.ali p.i.bob)
          [i.ali $(ali t.ali, bob t.bob)]
        ?:  (gth p.i.ali p.i.bob)
          [i.bob $(p.i.ali (sub p.i.ali p.i.bob), bob t.bob)]
        [i.ali $(ali t.ali, p.i.bob (sub p.i.bob p.i.ali))]
      ::
          %|
        ?:  =(p.i.ali (lent p.i.bob))
          [i.bob $(ali t.ali, bob t.bob)]
        ?:  (gth p.i.ali (lent p.i.bob))
          [i.bob $(p.i.ali (sub p.i.ali (lent p.i.bob)), bob t.bob)]
        =/  [fic=(unce:clay cord) ali=diff bob=diff]
            (resolve ali bob)
        [fic $(ali ali, bob bob)]
        ::  ~   ::  here, alice is good for a while, but not for the whole
      ==    ::  length of bob's changes
    ::
        %|
      ?-  -.i.bob
          %|
        =/  [fic=(unce:clay cord) ali=diff bob=diff]
            (resolve ali bob)
        [fic $(ali ali, bob bob)]
      ::
          %&
        ?:  =(p.i.bob (lent p.i.ali))
          [i.ali $(ali t.ali, bob t.bob)]
        ?:  (gth p.i.bob (lent p.i.ali))
          [i.ali $(ali t.ali, p.i.bob (sub p.i.bob (lent p.i.ali)))]
        =/  [fic=(unce:clay cord) ali=diff bob=diff]
            (resolve ali bob)
        [fic $(ali ali, bob bob)]
      ==
    ==
    ::
    ++  annotate                                        ::  annotate conflict
      |=  $:  ali=(list @t)
              bob=(list @t)
              bas=(list @t)
          ==
      ^-  (list @t)
      %-  zing
      ^-  (list (list @t))
      %-  flop
      ^-  (list (list @t))
      :-  :_  ~
          %^  cat  3  '<<<<<<<<<<<<'
          %^  cat  3  ' '
          %^  cat  3  '/'
          bod

      :-  bob
      :-  ~['------------']
      :-  bas
      :-  ~['++++++++++++']
      :-  ali
      :-  :_  ~
          %^  cat  3  '>>>>>>>>>>>>'
          %^  cat  3  ' '
          %^  cat  3  '/'
          ald
      ~
    ::
    ++  clean                                          ::  clean
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
    ::
    ++  resolve
      |=  [ali=diff bob=diff]
      ^-  [fic=[%| p=(list cord) q=(list cord)] ali=diff bob=diff]
      =-  [[%| bac (annotate alc boc bac)] ali bob]
      |-  ^-  $:  $:  bac=(list cord)
                      alc=(list cord)
                      boc=(list cord)
                  ==
                  ali=diff
                  bob=diff
              ==
      ?~  ali  [[~ ~ ~] ali bob]
      ?~  bob  [[~ ~ ~] ali bob]
      ?-    -.i.ali
          %&
        ?-    -.i.bob
            %&  [[~ ~ ~] ali bob]                       ::  no conflict
            %|
          =+  lob=(lent p.i.bob)
          ?:  =(lob p.i.ali)
            [[p.i.bob p.i.bob q.i.bob] t.ali t.bob]
          ?:  (lth lob p.i.ali)
            [[p.i.bob p.i.bob q.i.bob] [[%& (sub p.i.ali lob)] t.ali] t.bob]
          =+  wat=(scag (sub lob p.i.ali) p.i.bob)
          =+  ^=  res
              %=  $
                ali  t.ali
                bob  [[%| (scag (sub lob p.i.ali) p.i.bob) ~] t.bob]
              ==
          :*  :*  (welp bac.res wat)
                  (welp alc.res wat)
                  (welp boc.res q.i.bob)
              ==
              ali.res
              bob.res
          ==
        ==
      ::
          %|
        ?-    -.i.bob
            %&
          =+  loa=(lent p.i.ali)
          ?:  =(loa p.i.bob)
            [[p.i.ali q.i.ali p.i.ali] t.ali t.bob]
          ?:  (lth loa p.i.bob)
            [[p.i.ali q.i.ali p.i.ali] t.ali [[%& (sub p.i.bob loa)] t.bob]]
          =+  wat=(slag (sub loa p.i.bob) p.i.ali)
          =+  ^=  res
              %=  $
                ali  [[%| (scag (sub loa p.i.bob) p.i.ali) ~] t.ali]
                bob  t.bob
              ==
          :*  :*  (welp bac.res wat)
                  (welp alc.res q.i.ali)
                  (welp boc.res wat)
              ==
              ali.res
              bob.res
          ==
        ::
            %|
          =+  loa=(lent p.i.ali)
          =+  lob=(lent p.i.bob)
          ?:  =(loa lob)
            [[p.i.ali q.i.ali q.i.bob] t.ali t.bob]
          =+  ^=  res
              ?:  (gth loa lob)
                $(ali [[%| (scag (sub loa lob) p.i.ali) ~] t.ali], bob t.bob)
              ~&  [%scagging loa=loa pibob=p.i.bob slag=(scag loa p.i.bob)]
              $(ali t.ali, bob [[%| (scag (sub lob loa) p.i.bob) ~] t.bob])
          :*  :*  (welp bac.res ?:((gth loa lob) p.i.bob p.i.ali))
                  (welp alc.res q.i.ali)
                  (welp boc.res q.i.bob)
              ==
              ali.res
              bob.res
          ==
        ==
      ==
    --
  --
--

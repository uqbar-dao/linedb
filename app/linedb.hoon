/-  *screed, *linedb
/+  ldb=linedb
/+  default-agent, verb, dbug
::
%-  agent:dbug
%+  verb  &
^-  agent:gall
=>  |%
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          repos=(map @tas repo)
      ==
    +$  card  card:agent:gall
    --
=|  state-0
=*  state  -
=<  |_  =bowl:gall
    +*  this  .
        hc    ~(. +> bowl)
        def   ~(. (default-agent this %|) bowl)
    ++  on-init  on-init:def
    ++  on-save  !>(state)
    ++  on-load
      |=  =vase 
      ^-  (quip card _this)
      =+  !<(old=versioned-state vase)
      ?-  -.old
        %0  `this(state old)
      ==
    ::
    ++  on-poke
      |=  [=mark =vase]
      =^  cards  state
        ?+  mark  (on-poke:def mark vase)
          %linedb-action  (handle-action:hc !<(action vase))
        ==
      [cards this]
    ::
    ++  on-agent  on-agent:def
    ++  on-watch  on-watch:def
    ++  on-peek   on-peek:def
    ++  on-arvo   on-arvo:def
    ++  on-leave  on-leave:def
    ++  on-fail   on-fail:def
    --
::
::  if the helper core used any cards I would put them here as part of state
::  possibly advnatageous to refactor everything as abet instead of having
::  various helper arms. TODO...
:: 
|_  bowl=bowl:gall
++  handle-action
  |=  act=action
  ^-  (quip card _state)
  ?-  -.act
    %new-repo       re-abet:(re name.act)
    %commit         re-abet:(re-commit:(re repo.act) snap.act)
    %branch         re-abet:(re-branch:(re repo.act) name.act)
    %delete-branch  re-abet:(re-delete:(re repo.act) name.act)
    %checkout       re-abet:(re-checkout:(re repo.act) branch.act)
    %merge          re-abet:(re-merge:(re repo.act) branch.act)
    %reset          re-abet:(re-reset:(re repo.act) hash.act)
  ==
::
::  repo engine
::
++  re
  |=  rep=@tas
  =+  %+  ~(gut by repos)  rep
      ^-  repo
      :-  [our.bowl %master]
      (~(put by *(map @tas branch)) %master *branch)
  =*  repo  -
  ::
  |%
  ::
  ::  Done; install data
  ::
  ++  re-abet
    ^-  (quip card _state)
    =.  repos  (~(put by repos) rep repo)
    `state
  ::
  ::  active branch, checked-out
  ::
  ++  re-active    (~(got by q.repo) active.p.repo)
  ++  re-branches  (turn ~(tap by q.repo) head)
  ::
  ::
  ++  re-ancestor
    |=  [bar=@tas ban=@tas]
    ^-  (unit hash)
    =/  har        log:(ba bar)
    =/  han  (silt log:(ba ban))
    |-
    ?~  har  ~
    ?:  (~(has in han) i.har)
      `i.har
    $(har t.har)
  ::
  ++  re-commit
    |=  new=snap
    ^+  ..re-abet
    ba-abet:(ba-commit:(ba active.p.repo) new)
  ::
  ++  re-checkout
    |=  chek=@tas
    ^+  ..re-abet
    ..re-abet(active.p.repo chek)
  ::
  ++  re-branch
    |=  name=@tas
    ^+  ..re-abet
    =.  q.repo
      (~(put by q.repo) name re-active)
    ..re-abet
  ::
  ++  re-delete
    |=  name=@tas
    ^+  ..re-abet
    ?:  =(name active.p.repo)
      ~&("{<name>} is active, cannot delete" ..re-abet)
    =.  q.repo  (~(del by q.repo) name)
    ..re-abet
  ::
  ++  re-reset
    |=  =hash
    ^+  ..re-abet
    ba-abet:(ba-reset:(ba active.p.repo) hash)
  ::
  ++  re-merge
    |=  name=@tas
    ^+  ..re-abet
    =/  incoming  (~(got by q.repo) name)
    =*  active-index    hash-index:re-active
    =*  incoming-index  hash-index.incoming
    ?~  base=(re-ancestor active.p.repo name)
      ~|("%linedb: merge: no common base for {<re-active>} and {<name>}" !!)
    =/  active-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by active-index) u.base)
        snap:(~(got by active-index) head:re-active)
    =/  incoming-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by incoming-index) u.base)
        snap:(~(got by incoming-index) head.incoming)
    =/  diffs=(map path diff)
      %-  ~(urn by (~(uni by active-diffs) incoming-diffs))
      |=  [=path *]
      ^-  diff
      %+  three-way-merge:di:ldb
        [active.p.repo (~(gut by active-diffs) path *diff)]
      [name (~(gut by incoming-diffs) path *diff)]
    =+  br=(~(got by q.repo) active.p.repo)
    =/  new-snap=snap
      ?@  commits.br  *snap
      %-  ~(urn by snap.i.commits.br)
      |=  [=path =file]
      =+  dif=(~(got by diffs) path)
      (apply-diff:di:ldb file dif)
    (re-commit new-snap)
  ::
  ::  branch engine
  ::
  ++  ba
    |=  ban=@tas
    =+  (~(got by q.repo) ban)
    =*  branch  -
    ::
    |%
    ++  ba-core  .
    ::
    ::  Done; install data
    ::
    ++  ba-abet
      ^+  ..re-abet
      =.  q.repo  (~(put by q.repo) ban branch)
      ..re-abet
    ::
    ++  ba-commit :: TODO ugly
      |=  new=snap
      ^+  ..ba-abet
      =+  head-hash=(sham new)
      =/  blah=commit
        :*  head-hash
            head.branch
            src.bowl
            now.bowl
            new
        ==
      =.  commits.branch  [blah commits.branch]
      =.  hash-index.branch
        %+  ~(put by hash-index.branch)  head-hash
        ?>(?=(^ commits.branch) i.commits.branch)
      =.  head.branch  head-hash
      ..ba-abet
    ::
    ++  ba-squash :: TODO this code is really ugly, I think you can do it with just a nested trap
      |=  [from=hash to=hash]
      ^+  ..ba-abet
      =|  edited=(list commit)
      =|  base=(unit commit)
      =|  continue=?
      =/  commits  (flop commits.branch)
      |-
      ?~  commits
        =.  commits.branch  edited
        ..ba-abet
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
    ++  ba-reset  :: hard reset
      |=  to=hash
      ^+  ..ba-abet
      ?.  (~(has by hash-index.branch) to)
        ~|("%linedb: reset: hash doesn't exist, cannot reset" !!)
      |-
      ?~  commits.branch  !!  ::  should never happen
      ?:  =(hash.i.commits.branch to)
        =.  head.branch  to
        ..ba-abet
      =.  hash-index.branch
        (~(del by hash-index.branch) hash.i.commits.branch)
      $(commits.branch t.commits.branch)
    ::
    ::  read arms
    ::
    :: ++  get-commit   |=(h=hash (~(gut by hash-index.branch) h *commit))
    :: ++  get-snap     |=(h=hash snap:(get-commit h))
    :: ++  get-file     |=([h=hash p=path] (of-wain:format (~(got by (get-snap h)) p)))
    :: ++  head-commit  ?^(commits.branch i.commits.branch *commit)
    :: ++  head-snap    snap:head-commit
    :: ++  head-file    |=(p=path (of-wain:format (~(gut by head-snap) p *file)))
    ::
    ++  log          (turn commits.branch |=(=commit hash.commit))
    --
  --
--

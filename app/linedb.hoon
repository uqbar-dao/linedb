/-  *screed, *linedb
/+  dbug, default-agent, *mip, ldb=linedb, screed-lib=screed, verb
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
          %linedb-fetch   (handle-fetch:hc !<(fetch vase))
          %linedb-push    (handle-push:hc !<(push vase))
        ==
      [cards this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card _this)
      ~&  >  wire
      ~&  >  -.sign
      ?+    wire  (on-agent:def wire sign)
          [%fetch %ask ~]
        ?+    -.sign  (on-agent:def wire sign)
            %fact
          ~&  >  p.cage.sign
          `this
        ==
      ::
          [%fetch %req ~]
        ?+    -.sign  (on-agent:def wire sign)
            %fact
          ~&  >  p.cage.sign
          `this
        ==
      ==
    ++  on-watch  on-watch:def
    ++  on-peek   handle-scry:hc
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
  `state
  :: ?-    -.act
  ::     %new-repo
  ::   =.  repos
  ::     %+  ~(put by repos)  name.act
  ::     :-  [our.bowl %master]
  ::     (~(put by *(map @tas branch)) %master *branch)
  ::   `state
  :: ::
  ::     %commit
  ::   =.  repos
  ::     %+  ~(jab by repos)  repo.act
  ::     |=  =repo
  ::     (~(re-commit re repo) our.bowl now.bowl snap.act)
  ::   `state
  :: ::
  ::     %branch
  ::   =.  repos
  ::     %+  ~(jab by repos)  repo.act
  ::     |=(=repo (~(new-branch re repo) name.act))
  ::   `state
  :: ::
  ::     %delete-branch
  ::   =.  repos
  ::     %+  ~(jab by repos)  repo.act
  ::     |=(=repo (~(delete-branch re repo) name.act))
  ::   `state
  :: ::
  ::     %checkout
  ::   =.  repos
  ::     %+  ~(jab by repos)  repo.act
  ::     |=(=repo (~(checkout re repo) branch.act))
  ::   `state    
  :: ::
  ::     %merge
  ::   =.  repos
  ::     %+  ~(jab by repos)  repo.act
  ::     |=(=repo (~(merge re repo) branch.act))
  ::   `state
  :: ::
  ::     %reset
  ::   =.  repos
  ::     %+  ~(jab by repos)  repo.act
  ::     |=(=repo (~(reset-branch re repo) hash.act))
  ::   `state
  :: ==
::
++  handle-fetch
  |=  =fetch
  ^-  (quip card _state)
  ?-    -.fetch
      %ask
    :_  state
    =+  !>([%request repo.fetch])
    [%pass /fetch/ask %agent [who.fetch dap.bowl] %poke %linedb-fetch -]~
  ::
      %request
    =-  [%pass /fetch/req %agent [src dap]:bowl %poke %linedb-fetch -]~^state
    ?~  got=(~(get by repos) repo.fetch)  !>(~)
    !>([%response repo.fetch u.got])
  ::
      %response
    :: TODO partial checkout - just grab one branch
    `state(repos (~(put by repos) [name repo]:fetch))
  ==
::
++  handle-push
  |=  =push
  ^-  (quip card _state)
  ?-    -.push
      %ask
    :_  state
    =+  !>([%push [repo branch who]:push])
    [%pass /push/ask %agent [who.push dap.bowl] %poke %linedb-push -]~
  ::
      %push
    ~&  >  commits.push
    :: if it's a fast forward then it's fine
    :: otherwise we need to get to poke back with a notification that says they need to pull
    `state :: TODO change state
  ==
::
++  handle-scry
  |=  =path
  ^-  (unit (unit cage))
  `~
  :: ?+    path  `~
  ::     [%x %repos ~]  ``noun+!>((turn ~(tap by repos) head))
  ::     [%x %branches @ ~]
  ::   ``noun+!>(~(branches re (~(got by repos) i.t.t.path)))
  :: ::
  ::     [%x %active-branch @ ~]
  ::   ``noun+!>(active-branch.p:(~(got by repos) i.t.t.path))
  :: ==
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
  |%
  ::
  ::  Done; install data
  ::
  ++  re-abet
    ^+  ..re-abet
    =.  repos  (~(put by repos) rep repo)
    ..re-abet
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
    |=  new=^snap
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
    =/  new-snap=^snap
      ?@  commits.br  *^snap
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
      |=  new=^snap
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

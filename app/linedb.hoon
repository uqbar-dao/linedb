/-  *linedb, b=branch
/+  ldb=linedb
/+  sss
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
          subs=_(mk-subs:sss b sss-paths)
          pubs=_(mk-pubs:sss b sss-paths)
      ==
    +$  card  $+(card card:agent:gall) :: $+ makes debugging easier here
    --
=|  state-0
=*  state  -
=<  |_  =bowl:gall
    +*  this  .
        hc    ~(. +> bowl)
        def   ~(. (default-agent this %|) bowl)
        dab   =/  da  (da:sss b sss-paths)
              (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
        dub   =/  du  (du:sss b sss-paths)
              (du pubs bowl -:!>(*result:du))
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
        ?+    mark  (on-poke:def mark vase)
        ::
        ::  normal pokes
        ::
            %linedb-action  (handle-action:hc !<(action vase))
        ::
            %fetch
          =^  cards  subs  
            (surf:dab !<(@p (slot 2 vase)) dap.bowl !<(sss-paths (slot 3 vase)))
          [cards state]
        ::
        ::  permissions
        ::
            %perm-public
          =.  pubs  (public:dub !<((list sss-paths) vase))
          `state
        ::
            %perm-secret
          =.  pubs  (secret:dub !<((list sss-paths) vase))
          `state
        ::
            %perm-allow
          =.  pubs  (allow:dub !<([(list ship) (list sss-paths)] vase))
          `state
        ::
        ::  sss boilerplate
        ::
            %sss-branch
          =^  cards  subs  (apply:dab !<(into:dab (fled:sss vase)))
          [cards state]
        ::
            %sss-to-pub
          =+  msg=!<($%(into:dub) (fled:sss vase))
          =^  cards  pubs  (apply:dub msg)
          [cards state]
        ::
            %sss-surf-fail
          =/  msg  !<(fail:dab (fled:sss vase))
          ~&  >>>  "not allowed to surf on {<msg>}"
          `state
        ::
            %sss-on-rock    `state  :: a rock has updated
        ==
      [cards this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card _this)
      ?>  ?=(%poke-ack -.sign)
      ?~  p.sign  `this
      %-  (slog u.p.sign)
      =^  cards  subs
        ?+    wire  `subs
          ::  sss boilerblate
          ::
          [~ %sss %on-rock @ @ @ @tas @tas ~]      `(chit:dab |3:wire sign)
          [~ %sss %scry-request @ @ @ @tas @tas ~]  (tell:dab |3:wire sign)
        ==
      [cards this]
    ++  on-watch  on-watch:def
    ++  on-peek   on-peek:def
    ++  on-arvo
      |=  [=wire sign=sign-arvo]
      ^-  (quip card:agent:gall _this)
      ?+  wire  `this
        ::  sss boilerplate
        ::
        [~ %sss %behn @ @ @ @tas @tas ~]  [(behn:dab |3:wire) this]
      ==
    ++  on-leave  on-leave:def
    ++  on-fail   on-fail:def
    --
::
|_  =bowl:gall
+*  dab  =/  da  (da:sss b sss-paths)
         (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    dub  =/  du  (du:sss b sss-paths)
         (du pubs bowl -:!>(*result:du))
++  handle-action
  |=  act=action
  ^-  (quip card _state)
  ?-  -.act
    %commit  ba-abet:(ba-commit:(ba repo.act) snap.act)
    :: %branch  re-abet:(re-branch:(re repo.act) name.act)
    %delete  ba-abet:ba-delete:(ba repo.act)
    :: %merge   re-abet:(re-merge:(re repo.act) branch.act)
    :: %reset   re-abet:(re-reset:(re repo.act) hash.act)
  ==
::
++  pubs  read:dub
++  subs  read:dab
:: ++  both
::   ^-  (map sss-paths rock:b)
::   =/  pubs-flat
::     %-  ~(gas by *(map sss-paths rock:b))
::     %+  turn  ~(tap by pubs)
::     |=  [sss-paths * =rock:b]
::     [sss-paths rock]
::   =/  subs-flat
::     %-  ~(gas by *(map sss-paths rock:b))
::     %+  turn  ~(tap by subs)
::     |=  [[ship dude =sss-paths] [? ? =rock:b]]
::     [sss-paths rock]
::   (~(uni by pubs-flat) subs flat)
::
++  ancestor
  |=  [bar=@tas ban=@tas]
  ^-  (unit hash)
  =/  har        log:(ba [repo bar ~])
  =/  han  (silt log:(ba [repo ban ~]))
  |-
  ?~  har  ~
  ?:  (~(has in han) i.har)
    `i.har
  $(har t.har)
::
::  branch engine
::
++  ba
  |=  ban=sss-paths
  =+  ?~  pubd=(~(get by pubs) ban)  :: TODO ugly
        ?~  subd=(~(get by subs) ban)  !!
        u.subd
      u.pubd
  =*  branch  -
  ::
  |%
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
    =^  cad  pubs  (give:dub [rep ban ~] blah)
    =.  cards  (weld cad cards)
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
  ::  delete a branch - note that this doesn't actually delete
  ::
  ++  ba-delete
    ^+  ..re-abet
    =.  pubs  (kill:dub ban ~)
    =.  pubs  (wipe:dub ban ~)
    ..re-abet
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
  ::
  ++  ba-merge
    |=  name=@tas
    ^+  ..re-abet
    =/  incoming  (~(got by q.repo) name)
    =*  active-index    hash-index:branch
    =*  incoming-index  hash-index.incoming
    ?~  base=(re-ancestor active.p.repo name)
      ~|("%linedb: merge: no common base for {<branch>} and {<name>}" !!)
    =/  active-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by active-index) u.base)
        snap:(~(got by active-index) head:branch)
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
  --
--
--

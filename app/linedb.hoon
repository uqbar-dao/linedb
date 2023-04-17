/-  *linedb, b=branch
/+  ldb=linedb
/+  sss
/+  default-agent, verb, dbug
::
%-  agent:dbug
%+  verb  &
^-  agent:gall
=>  =+  sss-paths=,[@tas @tas ~]
    |%
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          repos=(map @tas repo)
          sub-branch=_(mk-subs:sss b sss-paths)
          pub-branch=_(mk-pubs:sss b sss-paths)
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
              (da sub-branch bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
        dub   =/  du  (du:sss b sss-paths)
              (du pub-branch bowl -:!>(*result:du))
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
            %linedb-action  (handle-action:hc !<(action vase))
        ::
            %fetch
          =^  cards  sub-branch  
            (surf:dab !<(@p (slot 2 vase)) dap.bowl !<(sss-paths (slot 3 vase)))
          [cards state]
        ::
            %sss-branch
          =^  cards  sub-branch  (apply:dab !<(into:dab (fled:sss vase)))
          [cards state]
        ::
            %sss-to-pub
          =+  msg=!<($%(into:dub) (fled:sss vase))
          =^  cards  pub-branch  (apply:dub msg)
          [cards state]
        ::
            %sss-surf-fail
          =/  msg  !<(fail:dab (fled:sss vase))
          ~&  >>>  "not allowed to surf on {<msg>}"
          `state
        ::
            %sss-on-rock    `state  :: a rock has updated
        ::
            %perm-public
          =.  pub-branch  (public:dub !<((list sss-paths) vase))
          `state
        ::
            %perm-secret
          =.  pub-branch  (secret:dub !<((list sss-paths) vase))
          `state
        ::
            %perm-allow
          =.  pub-branch  (allow:dub !<([(list ship) (list sss-paths)] vase))
          `state
        ==
      [cards this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card _this)
      ?>  ?=(%poke-ack -.sign)
      ?~  p.sign  `this
      %-  (slog u.p.sign)
      =^  cards  sub-branch
        ?+    wire  `sub-branch
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
        [~ %sss %behn @ @ @ @tas @tas ~]  [(behn:dab |3:wire) this]
      ==
    ++  on-leave  on-leave:def
    ++  on-fail   on-fail:def
    --
::
|_  =bowl:gall
+*  dab  =/  da  (da:sss b sss-paths)
         (da sub-branch bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    dub  =/  du  (du:sss b sss-paths)
         (du pub-branch bowl -:!>(*result:du))
++  handle-action
  |=  act=action
  ^-  (quip card _state)
  ?-  -.act
    %create  re-abet:(re name.act)
    %commit  re-abet:(re-commit:(re repo.act) [branch snap]:act)
    %branch  re-abet:(re-branch:(re repo.act) [from name]:act)
    %delete  re-abet:(re-delete:(re repo.act) name.act)
    %merge   re-abet:(re-merge:(re repo.act) [base come]:act)
    %reset   re-abet:(re-reset:(re repo.act) [branch hash]:act)
  ==
::
::  repo engine
::
++  re
  =|  cards=(list card)
  |=  rep=@tas
  =+  %+  ~(gut by repos)  rep
      ^-  repo
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
    [(flop cards) state]
  ::
  ::  active branch, checked-out
  ::
  ++  re-branches  (turn ~(tap by repo) head)
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
    |=  [branch=@tas new=snap]
    ^+  ..re-abet
    ba-abet:(ba-commit:(ba branch) new)
  ::
  ++  re-branch
    |=  [from=@tas name=@tas]
    ^+  ..re-abet
    =.  repo
      (~(put by repo) name (~(got by repo) from))
    ..re-abet
  ::
  ++  re-delete
    |=  name=@tas
    ^+  ..re-abet
    =.  repo  (~(del by repo) name)
    =.  pub-branch  (kill:dub [rep name ~]~)
    ..re-abet
  ::
  ++  re-reset
    |=  [branch=@tas =hash]
    ^+  ..re-abet
    ba-abet:(ba-reset:(ba branch) hash)
  ::
  ++  re-merge
    |=  [ali=@tas bob=@tas]
    ^+  ..re-abet
    =/  alice   (~(got by repo) ali)
    =/  robert  (~(got by repo) bob)
    =*  alice-index   hash-index:alice
    =*  robert-index  hash-index.robert
    ?~  base=(re-ancestor ali bob)
      ~|("%linedb: merge: no common base for {<ali>} and {<bob>}" !!)
    =/  alice-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by alice-index) u.base)
        snap:(~(got by alice-index) head:alice)
    =/  robert-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by robert-index) u.base)
        snap:(~(got by robert-index) head.robert)
    =/  diffs=(map path diff)
      %-  ~(urn by (~(uni by alice-diffs) robert-diffs))
      |=  [=path *]
      ^-  diff
      %+  three-way-merge:di:ldb
        [ali (~(gut by alice-diffs) path *diff)]
      [bob (~(gut by robert-diffs) path *diff)]
    =/  new-snap=snap
      ?@  commits.alice  *snap
      %-  ~(urn by snap.i.commits.alice)
      |=  [=path =file]
      =+  dif=(~(got by diffs) path)
      (apply-diff:di:ldb file dif)
    (re-commit ali new-snap)
  ::
  ::  branch engine
  ::
  ++  ba
    |=  ban=@tas
    =+  (~(got by repo) ban)
    =*  branch  -
    ::
    |%
    ::
    ::  Done; install data
    ::
    ++  ba-abet
      ^+  ..re-abet
      =.  repo  (~(put by repo) ban branch)
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
      =^  cad  pub-branch  (give:dub [rep ban ~] blah)
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

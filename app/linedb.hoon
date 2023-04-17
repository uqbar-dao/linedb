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
            %linedb-action  (handle-action:hc !<(action vase))
        ::
            %fetch
          =^  cards  subs  
            (surf:dab !<(@p (slot 2 vase)) dap.bowl !<(sss-paths (slot 3 vase)))
          [cards state]
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
         (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    dub  =/  du  (du:sss b sss-paths)
         (du pubs bowl -:!>(*result:du))
++  handle-action
  |=  act=action
  ^-  (quip card _state)
  ?-  -.act
    %commit  ba-abet:(ba-commit:(ba [repo branch ~]:act) snap.act)
    %delete  ba-abet:ba-delete:(ba repo.act branch.act ~)
    %merge   ba-abet:(ba-merge:(ba repo.act branch.act ~) [repo bob ~]:act)
    :: %branch  re-abet:(re-branch:(re repo.act) [from name]:act)
    :: %reset   re-abet:(re-reset:(re repo.act) [branch hash]:act)
  ==
::
::  branch engine
::
++  ba
  =|  cards=(list card)
  |=  ali=sss-paths
  =+  rock:(~(got by read:dub) ali)
  =*  branch  -
  ::
  |%
  ::
  ::  Done; install data
  ::
  ++  ba-abet
    ^-  (quip card _state)
    [(flop cards) state]
  ::
  ++  ba-delete
    ^+  ..ba-abet
    =.  pubs  (kill:dub ali ~)
    =.  pubs  (wipe:dub ali)
    ..ba-abet
  ::
  ++  ba-commit :: TODO ugly
    |=  new=snap
    ^+  ..ba-abet
    =+  head-hash=(sham new)
    =/  com=commit
      :*  head-hash
          head.branch
          src.bowl
          now.bowl
          new
      ==
    =.  commits.branch  [com commits.branch]
    =.  hash-index.branch
      %+  ~(put by hash-index.branch)  head-hash
      ?>(?=(^ commits.branch) i.commits.branch)
    =.  head.branch  head-hash
    =^  cad  pubs  (give:dub ali com)
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
  ++  ba-merge
    |=  bob=sss-paths
    ^+  ..ba-abet
    |^
    =/  robert  branch:(ba bob)
    =*  alice-index   hash-index:branch
    =*  robert-index  hash-index.robert
    ?~  base=(merge-base ali bob)
      ~|("%linedb: merge: no common base for {<ali>} and {<bob>}" !!)
    =/  alice-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by alice-index) u.base)
        snap:(~(got by alice-index) head:branch)
    =/  robert-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by robert-index) u.base)
        snap:(~(got by robert-index) head.robert)
    =/  diffs=(map path diff)
      %-  ~(urn by (~(uni by alice-diffs) robert-diffs))
      |=  [=path *]
      ^-  diff
      %+  three-way-merge:di:ldb
        [+<:ali (~(gut by alice-diffs) path *diff)]
      [+<:bob (~(gut by robert-diffs) path *diff)]
    =/  new-snap=snap
      ?@  commits.branch  *snap
      %-  ~(urn by snap.i.commits.branch)
      |=  [=path =file]
      =+  dif=(~(got by diffs) path)
      (apply-diff:di:ldb file dif)
    (ba-commit new-snap)
    ::
    ++  merge-base
      |=  [bar=sss-paths ali=sss-paths]
      ^-  (unit hash)
      =/  har        log:(ba bar)
      =/  han  (silt log:(ba ali))
      |-
      ?~  har  ~
      ?:  (~(has in han) i.har)
        `i.har
      $(har t.har)
    --
  ::
  :: ++  ba-reset  :: TODO need to add something to sur/sss/branch/hoon to make this actually work
  ::   |=  to=hash
  ::   ^+  ..ba-abet
  ::   ?.  (~(has by hash-index.branch) to)
  ::     ~|("%linedb: reset: hash doesn't exist, cannot reset" !!)
  ::   |-
  ::   ?~  commits.branch  !!  ::  should never happen
  ::   ?:  =(hash.i.commits.branch to)
  ::     =.  head.branch  to
  ::     ..ba-abet
  ::   =.  hash-index.branch
  ::     (~(del by hash-index.branch) hash.i.commits.branch)
  ::   $(commits.branch t.commits.branch)
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

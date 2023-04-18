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
            %linedb-action  (handle-action:hc !<(action vase))
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
            %sss-on-rock  `state  :: a rock has updated
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
  ?-    -.act
      %commit
    =^  cards  pubs
      (give:dub [repo branch ~]:act %commit our.bowl now.bowl snap.act)
    [cards state]
  ::
      %delete
    =^  cards  pubs  (give:dub [repo branch ~]:act [%delete ~])
    =.  pubs  (kill:dub [repo branch ~]:act ~)
    =.  pubs  (wipe:dub [repo branch ~]:act)
    [cards state]
  ::
      %reset
    =^  cards  pubs  (give:dub [repo branch ~]:act reset+hash.act)
    [cards state]
  ::
      %merge
    =/  alice   (ba [repo ali ~]:act)
    =/  robert  (ba [repo bob ~]:act)
    =/  base=hash
      =/  boh        log:robert
      =/  alh  (silt log:alice)
      |-
      ?~  boh
        ~|("%linedb: merge: no common base for {<ali.act>} and {<bob.act>}" !!)
      ?:  (~(has in alh) i.boh)
        i.boh
      $(boh t.boh)
    =/  alice-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by hash-index.alice) base)
        snap:(~(got by hash-index.alice) head.alice)
    =/  robert-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by hash-index.robert) base)
        snap:(~(got by hash-index.robert) head.robert)
    =/  diffs=(map path diff)
      %-  ~(urn by (~(uni by alice-diffs) robert-diffs))
      |=  [=path *]
      ^-  diff
      %+  three-way-merge:di:ldb
        [ali.act (~(gut by alice-diffs) path *diff)]
      [bob.act (~(gut by robert-diffs) path *diff)]
    =/  new-snap=snap
      ?@  commits.alice  *snap
      %-  ~(urn by snap.i.commits.alice)
      |=  [=path =file]
      =+  dif=(~(got by diffs) path)
      (apply-diff:di:ldb file dif)
    =^  cards  pubs
      (give:dub [repo ali ~]:act %commit our.bowl now.bowl new-snap)
    [cards state]
  ::
      %branch
    ?:  =(our.bowl who.act)
      =.  pubs  (fork:dub [repo from ~]:act [repo name ~]:act)
      `state
    =.  pubs  (copy:dub subs [who %linedb repo from ~]:act [repo name ~]:act)
    `state
  ::
      %fetch
    =^  cards  subs  (surf:dab who.act dap.bowl [repo branch ~]:act)
    [cards state]
  ==
::
::  branch engine
::
++  ba
  |=  ban=sss-paths
  =+  rock:(~(got by read:dub) ban)
  =*  branch  -
  ::
  |%
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

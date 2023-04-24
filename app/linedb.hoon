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
    ++  on-peek   handle-peek:hc
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
    =/  ali  (ba our.bowl [repo branch ~]:act)
    =/  bob  (ba from.act [repo incoming ~]:act)
    =/  base=hash
      =/  boh        history:bob
      =/  alh  (silt history:ali)
      |-
      ?~  boh
        ~|("%linedb: merge: no common base for {<branch.act>} and {<incoming.act>}" !!)
      ?:  (~(has in alh) i.boh)
        i.boh
      $(boh t.boh)
    =/  ali-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by hash-index.ali) base)
        snap:(~(got by hash-index.ali) head.ali)
    =/  bob-diffs=(map path diff)
      %+  diff-snaps:di:ldb
        snap:(~(got by hash-index.bob) base)
        snap:(~(got by hash-index.bob) head.bob)
    =/  diffs=(map path diff)
      %-  ~(urn by (~(uni by ali-diffs) bob-diffs))
      |=  [=path *]
      ^-  diff
      %+  three-way-merge:di:ldb
        [branch.act (~(gut by ali-diffs) path *diff)]
      [incoming.act (~(gut by bob-diffs) path *diff)]
    =/  new-snap=snap
      ?@  commits.ali  *snap
      %-  ~(urn by snap.i.commits.ali)
      |=  [=path =file]
      =+  dif=(~(got by diffs) path)
      (apply-diff:di:ldb file dif)
    =^  cards  pubs
      (give:dub [repo branch ~]:act %commit our.bowl now.bowl new-snap)
    [cards state]
  ::
      %branch
    ?:  =(our.bowl from.act)
      :: need to use +live if it has been killed
      =.  pubs  (fork:dub [repo branch ~]:act [repo name ~]:act)
      `state
    =.  pubs  (copy:dub subs [from %linedb repo from ~]:act [repo name ~]:act)
    `state
  ::
      %fetch
    =^  cards  subs  (surf:dab from.act dap.bowl [repo branch ~]:act)
    [cards state]
  ==
::
++  handle-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  ``noun+!>(~)
  ::
      [%x %log @ @tas @tas ~]                          ::  list of all meatdata
    =*  who  (slav %p i.t.t.path)
    =*  sss  t.t.t.path
    :^  ~  ~  %noun
    !>
    =/  log-result  (mule |.(log:(ba who sss)))
    ?:  ?=(%| -.log-result)  ~  p.log-result
  ::
      [%x %history @ @tas @tas ~]                      ::  list of all hashes
    =*  who  (slav %p i.t.t.path)
    =*  sss  t.t.t.path
    :^  ~  ~  %noun
    !>
    =/  history-result
      (mule |.(history:(ba who sss)))
    ?:  ?=(%| -.history-result)  ~  p.history-result
  ::
      [%x @ @tas @tas ?(%head @) ~]                    ::  get a list of files
    =*  who          (slav %p i.t.path)
    =*  repo                i.t.t.path
    =*  branch            i.t.t.t.path
    =-  ``noun+!>(-)
    =/  file-list-result
      %-  mule
      |.
      %-  turn  :_  head
      ?-  hash=i.t.t.t.t.path
        %head  ~(tap by head-snap:(ba who [repo branch ~]))
        @      ~(tap by (get-snap:(ba who [repo branch ~]) (slav %ux hash)))
      ==
    ?:  ?=(%| -.file-list-result)  ~  p.file-list-result
  ::
      [%x @ @tas @tas ?(%head @) ^]                    ::  read a file
    =*  who  (slav %p i.t.path)
    =*  repo        i.t.t.path
    =*  branch    i.t.t.t.path
    =*  file    t.t.t.t.t.path
    =-  ``noun+!>(-)
    =/  file-result
      %-  mule
      |.
      ?-  hash=i.t.t.t.t.path
        %head  (head-file:(ba who [repo branch ~]) file)
        @      (get-file:(ba who [repo branch ~]) (slav %ux hash) file)
      ==
    ?:  ?=(%| -.file-result)  ~  p.file-result
  ::
  ==
::
::  branch engine
::
++  ba
  |=  [from=@p ban=sss-paths]
  =+  ?:  =(from our.bowl)
        rock:(~(got by read:dub) ban)
      rock:(~(got by read:dab) from %linedb ban)
  =*  branch  -
  ::
  |%
  ::  read arms
  ::
  ++  get-commit   |=(h=hash (~(get by hash-index.branch) h))
  ++  get-snap     |=(h=hash snap:(need (get-commit h)))
  ++  get-file     |=([h=hash p=path] (of-wain:format (~(got by (get-snap h)) p)))
  ::
  ++  head-commit  ?>(?=(^ commits.branch) i.commits.branch)
  ++  head-snap    snap:head-commit
  ++  head-file    |=(p=path (of-wain:format (~(gut by head-snap) p *file)))
  ::
  ++  history          (turn commits.branch |=(=commit hash.commit))
  ++  log
    ^-  (list [hash hash @p @da])
    %+  turn  commits.branch
    |=(c=commit [hash parent author time]:c)
  --
--

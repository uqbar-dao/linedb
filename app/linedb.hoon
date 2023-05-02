/-  *linedb, bur=branch
/+  ldb=linedb, bil=branch, sss, default-agent, verb, dbug
::
=>  |%
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          subs=_(mk-subs:sss bur sss-paths)
          pubs=_(mk-pubs:sss bur sss-paths)
          =build-cache
      ==
    +$  card  $+(card card:agent:gall)
    --
::
=|  state-0
=*  state  -
=<  %-  agent:dbug
    %+  verb  &
    ^-  agent:gall
    |_  =bowl:gall
    +*  this  .
        hc    ~(. +> bowl)
        def   ~(. (default-agent this %|) bowl)
        dab   =/  da  (da:sss bur sss-paths)
              (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
        dub   =/  du  (du:sss bur sss-paths)
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
            %linedb-action   (handle-action:hc !<(action vase))
        ::  linedb permissions
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
    ++  on-peek
      |=  =path
      ^-  (unit (unit cage))
      =-  ``noun+!>(-)
      ?+    path  (on-peek:def path)
      ::
          [%x ~]  ~(tap by ~(key by all-rocks:hc))         ::  list all repos
      ::
          [%x @ ~]                                         ::  repos of ship
        =/  who  (slav %p i.t.path)
        %+  murn  ~(tap by all-rocks:hc)
        |=  [[=ship =sss-paths] *]
        ?:(=(ship who) `sss-paths ~)
      ::
          [%x @ @tas ~]                                    ::  branches of repo
        :: TODO this is not easy the way we have it set up with +ba
        ::   makes me think maybe we should do a refactor to make
        ::   repos "real"?
        =/  who  (slav %p i.t.path)
        =*  repo  i.t.t.path
        %+  murn  ~(tap by all-rocks:hc)
        |=  [[=ship =sss-paths] *]
        ?:(&(=(ship who) =(-.sss-paths repo)) `sss-paths ~)
      ::
          [%x @ @tas @tas ~]                               ::  log of branch
        =*  who  (slav %p i.t.path)
        =*  sss  t.t.path
        log:(~(gut by all-rocks) [who sss] *branch)
      ::
          [%x @ @tas @tas ?(%head @) ~]                    ::  get a list of files
        =*  who          (slav %p i.t.path)
        =*  repo                i.t.t.path
        =*  branch            i.t.t.t.path
        %-  turn  :_  head
        ?-  hash=i.t.t.t.t.path
          %head  ~(tap by head-snap:(ba-core:hc who [repo branch ~]))
          @      ~(tap by (get-snap:(ba-core:hc who [repo branch ~]) (slav %ux hash)))
        ==
      ::
          [%x @ @tas @tas ?(%head @) ^]                    ::  read a file
        =*  who  (slav %p i.t.path)
        =*  repo        i.t.t.path
        =*  branch    i.t.t.t.path
        =*  file    t.t.t.t.t.path
        ?-  hash=i.t.t.t.t.path
          %head  (head-file:(ba-core:hc who [repo branch ~]) file)
          @      (get-file:(ba-core:hc who [repo branch ~]) (slav %ux hash) file)
        ==
      ::
          [%x %build-result @ ~]
        =*  file-hash=@ux  (slav %ux i.t.t.path)
        :^  ~  ~  %uqbuild-update
        !>  ^-  update
        :-  %build
        ?^  build=(~(get by build-cache) file-hash)  [%& u.build]
        [%| (crip "build not found for file-hash {<file-hash>}")]
      ==
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
+*  dab  =/  da  (da:sss bur sss-paths)
         (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    dub  =/  du  (du:sss bur sss-paths)
         (du pubs bowl -:!>(*result:du))
::
++  all-rocks
  ^-  (map [ship sss-paths] rock:bur)
  %-  %~  uni  by
      ::  pubs
      %-  ~(gas by *(map [ship sss-paths] rock:bur))
      %+  turn  ~(tap by read:dub)
      |=  [=sss-paths * =rock:bur]
      [[our.bowl sss-paths] rock]
  ::  subs
  %-  ~(gas by *(map [ship sss-paths] rock:bur))
  %+  turn  ~(tap by read:dab)
  |=  [[=ship * =sss-paths] * * =rock:bur]
  [[ship sss-paths] rock]
::
::  thin wrapper around +branch
::
++  ba-core
  |=  [who=@p pax=sss-paths]
  =;  ban  (ba:bil ban)
  (~(gut by all-rocks) [who pax] *branch)
::
++  handle-action
  |=  act=action
  ^-  (quip card _state)
  ?-    -.act
      %commit
    =^  cards  pubs
      (give:dub [repo branch ~]:act %commit our.bowl now.bowl snap.act)
    [cards state]
  ::
      %merge
    =^  cards  pubs  [~ pubs]  ::  (give:dub  [repo branch ~]:act merge+branch.act) :: TODO have to finish this
    [cards state]
  ::
      %squash
    =^  cards  pubs  [~ pubs]  :: (give:dub [repo branch ~]:act squash+hash.act)
    [cards state]
  ::
      %reset
    =^  cards  pubs  (give:dub [repo branch ~]:act reset+hash.act)
    [cards state]
  ::
      %delete
    =^  cards  pubs  (give:dub [repo branch ~]:act [%delete ~])
    =.  pubs  (kill:dub [repo branch ~]:act ~)
    =.  pubs  (wipe:dub [repo branch ~]:act)
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
  ::
      %install
    =^  vases=(list [dude:gall (each vase @t)])  build-cache
      =|  res=(list [dude:gall (each vase @t)])
      |-
      ?~  bill.act  [res build-cache]
      =/  [built-file=(each vase @t) =build-state]
        %.  /app/[i.bill.act]/hoon
        %~  build-file  ub:(ba-core [from repo branch ~]:act)
        [build-cache ~]
      %=  $
        bill.act     t.bill.act
        res          [[i.bill.act built-file] res]
        build-cache  build-cache.build-state
      ==
    =/  all-files=(list [path %& page])        
      %+  murn  ~(tap by head-snap:(ba-core [from repo branch ~]:act))
      |=  [=path =file]
      ?.  =(%hoon (rear path))  ~
      `[path %& %hoon (of-wain:format file)]
    :_  state
    ?.  |- :: if anything failed then don't commit
        ?~  vases  %&
        ?:  =(%| +<.i.vases)
          ~&  build-failed+app+-.i.vases  %|
        $(vases t.vases)
      ~
    :_  ~
    :^  %pass  /  %arvo
    :-  %c
    :^  %park  repo.act
      ^-  yoki:clay
      :+  %&  ~
      %-  ~(gas by *(map path (each page lobe:clay)))
      ^-  (list [path %& page])
      %+  weld  all-files
      ^-  (list [path %& page])
      %-  zing
      %+  turn  vases
      |=  [=dude:gall vaz=(each vase @t)]
      ?>  =(%& -.vaz)
      :~  [/app/[dude]/vase %& %vase p.vaz]
          :^  /app/[dude]/hoon  %&  %hoon 
          %-  crip
          """
          /*  built  %vase  {<`path`/app/[dude]/vase>}
          !<(agent:gall built)
          """
      ==
    .^(rang:clay %cx /(scot %p our.bowl)//(scot %da now.bowl)/rang)
  ::
      %build
    =/  [built-file=(each vase @t) =build-state]
      %.  file.act
      %~  build-file  ub:(ba-core [from repo branch ~]:act)
      [build-cache ~]
    :_  state(build-cache build-cache.build-state)
    ?~  poke-src.act  ~
    :_  ~
    ?-    -.poke-src.act
        %app
      :^  %pass  /pokeback/[p.poke-src.act]  %agent
      :^  [our.bowl p.poke-src.act]  %poke  %linedb-update
      !>(`update`[%build built-file])
    ::
        %ted
      :^  %pass  /pokeback/[p.poke-src.act]  %agent
      :^  [our.bowl %spider]  %poke  %spider-input
      !>  ^-  [@tatid cage]
      :+  p.poke-src.act  %linedb-update
      !>(`update`[%build built-file])
    ==
  ==
--

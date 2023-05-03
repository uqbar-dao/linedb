/-  *linedb, bur=branch
/+  ldb=linedb, bil=branch, ub=uqbuild-2, sss, default-agent, verb, dbug
::
=>  |%
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          subs=_(mk-subs:sss bur sss-paths)
          pubs=_(mk-pubs:sss bur sss-paths)
          cache=(map @ux vase)
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
            %sss-on-rock  :: a rock has updated
          =+  !<([p=path src=@p @ ? ? *] vase)
          ?>  ?=([@ @ ~] p)  ::  TODO: is this true?
          =*  repo-path=path
            /repo-updates/(scot %p src)/[i.p]
          =*  branch-path=path  [(scot %p src) p]
          :_  state
          :_  ~
          :^  %give  %fact
            ~[repo-path [%branch-updates branch-path]]
          :-  %linedb-update
          !>(`update`[%new-data branch-path])
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
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card _this)
      ?+  path  (on-watch:def path)
        [%repo-updates @ @ ~]      `this  ::  host repo
        [%branch-updates @ @ @ ~]  `this  ::  host repo branch
      ==
    ::
    ++  on-leave
      |=  =path
      ^-  (quip card _this)
      ?+  path  (on-leave:def path)
        [%repo-updates @ @ ~]      `this  ::  host repo
        [%branch-updates @ @ @ ~]  `this  ::  host repo branch
      ==
    ::
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
        log:(~(gut by all-rocks:hc) [who sss] *branch)
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
        ?^  build=(~(get by cache) file-hash)  [%& u.build]
        %|^~[leaf+"build not found for file-hash {<file-hash>}"]
      ==
    ::
    ++  on-arvo
      |=  [=wire sign=sign-arvo]
      ^-  (quip card:agent:gall _this)
      ?+  wire  `this
        [~ %sss %behn @ @ @ @tas @tas ~]  [(behn:dab |3:wire) this]
      ==
    ++  on-fail   on-fail:def
    --
::
|_  =bowl:gall
+*  dab  =/  da  (da:sss bur sss-paths)
         (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    dub  =/  du  (du:sss bur sss-paths)
         (du pubs bowl -:!>(*result:du))
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
::  see +branch
::
++  ba-core
  |=  [who=@p pax=sss-paths]
  =;  ban  bil(branch ban)
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
    =^  cards  pubs
      %+  give:dub  [repo branch ~]:act
      :^  %merge  our.bowl  now.bowl
      (~(got by all-rocks) [host repo incoming ~]:act)
    [cards state]
  ::
      %squash
    =^  cards  pubs  (give:dub [repo branch ~]:act squash+hash.act)
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
    =/  =snap
      ?~  hash.act  head-snap:(ba-core [from repo branch ~]:act)
      (get-snap:(ba-core [from repo branch ~]:act) u.hash.act)
    =+  !<  bill=(list dude:gall)
        %+  slap  !>(~)
        %-  ream
        %-  of-wain:format
        ~|  "no desk.bill, nothing to build"
        (~(got by snap) /desk/bill)
    =^  vases=(list [dude:gall (each vase tang)])  cache
      =|  res=(list [dude:gall (each vase tang)])
      |-
      ?~  bill  [res cache]
      =/  [built-file=(each vase tang) build-state=*] :: TODO integrate state into linedb state
        %.  /app/[i.bill]/hoon
        =<  build-file
        %:  ub
          ?~  hash.act  head-snap:(ba-core [from repo branch ~]:act)
            (get-snap:(ba-core [from repo branch ~]:act) u.hash.act)
        ::
          5  ~  ~  ~
        ==
      $(bill t.bill, res [[i.bill built-file] res]) :: TODO update caches 
    =/  all-files=(list [path %& page])   
      :-  [/mar/vase/hoon %& %hoon vase-mark:ldb]     
      %+  murn  ~(tap by snap)
      |=  [=path =file]
      ?+    (rear path)  ~
          %hoon  `[path %& %hoon (of-wain:format file)]
          %ship  `[path %& %ship (slav %p (snag 0 file))]
          %bill
        :^  ~  path  %& 
        bill+!<((list dude:gall) (slap !>(~) (ream (of-wain:format file))))
      ::
          %kelvin
        `[path %& %kelvin (cord-to-waft:clay (of-wain:format file))]
      ::
        ::   %docket-0 :: TODO
        :: `[path %& %docket-0 !<(list)]
      ==
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
      |=  [=dude:gall vaz=(each vase tang)]
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
    =/  [built-file=(each vase tang) build-state=*] :: TODO incorporate ford state
      %.  file.act
      =<  build-file
      %-  ub
      :_  [5 ~ ~ ~]
      ?~  hash.act  head-snap:(ba-core [from repo branch ~]:act)
      (get-snap:(ba-core [from repo branch ~]:act) u.hash.act)
    :_  state :: TODO update cache
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

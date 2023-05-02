/-  *linedb, bur=branch
/+  ldb=linedb, bil=branch, ub=uqbuild, sss, default-agent, verb, dbug
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
        [%| (crip "build not found for file-hash {<file-hash>}")]
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
        (~(gut by snap) /desk/bill ~)
    =^  result=(each [@tas yoki:clay rang:clay] @t)  cache
      (build-park snap repo.act bill)
    :_  state
    ?:  ?=(%| -.result)  ~
    [%pass / %arvo %c %park p.result]~
  ::
      %make-install-args
    =/  =snap
      ?~  hash.act  head-snap:(ba-core [from repo branch ~]:act)
      (get-snap:(ba-core [from repo branch ~]:act) u.hash.act)
    =^  result=(each [@tas yoki:clay rang:clay] @t)  cache
      (build-park snap [repo bill]:act)
    :_  state
    ?~  poke-src.act  ~
    :_  ~
    ?-    -.poke-src.act
        %app
      :^  %pass  /pokeback/[p.poke-src.act]  %agent
      :^  [our.bowl p.poke-src.act]  %poke  %linedb-update
      !>(`update`[%make-install-args result])
    ::
        %ted
      :^  %pass  /pokeback/[p.poke-src.act]  %agent
      :^  [our.bowl %spider]  %poke  %spider-input
      !>  ^-  [@tatid cage]
      :+  p.poke-src.act  %linedb-update
      !>(`update`[%make-install-args result])
    ==
  ::
      %build
    =/  [built-file=(each vase @t) =build-state]
      %.  file.act
      %~  build-file  ub
      :_  [cache ~]
      ?~  hash.act  head-snap:(ba-core [from repo branch ~]:act)
      (get-snap:(ba-core [from repo branch ~]:act) u.hash.act)
    :_  state(cache cache.build-state)
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
::
++  build-park
  |=  $:  =snap
          desk-name=@tas
          bill=(list dude:gall)
      ==
  ^-  [(each [@tas yoki:clay rang:clay] @t) _cache]
  =^  vases=(list [dude:gall (each vase @t)])  cache
    =|  res=(list [dude:gall (each vase @t)])
    |-
    ?~  bill  [res cache]
    =/  [built-file=(each vase @t) =build-state]
      %.  /app/[i.bill]/hoon
      ~(build-file ub snap cache ~)
    %=  $
      bill   t.bill
      res    [[i.bill built-file] res]
      cache  cache.build-state
    ==
  =/  did-vase-build-succeed=(each ~ @t)
    |- :: if anything failed then don't commit
    ?~  vases  [%& ~]
    ?:  =(%| +<.i.vases)
      ~&  build-failed+app+-.i.vases  [%| -.i.vases]
    $(vases t.vases)
  ?:  ?=(%| -.did-vase-build-succeed)
    :_  cache
    :-  %|
    (cat 3 'linedb: build failed for app ' p.did-vase-build-succeed)
  =/  all-files=(list [path %& page])
    %+  welp  boilerplate-files:ldb
    %+  turn  ~(tap by snap)
    |=  [=path =file]
    ::  files are stored as `wain`s, and transformed here into atoms.
    ::   binary files are stored as a length-1 list of the atom's bytes,
    ::   which is effectively just a %mime, but without the mime-type
    ::   and file length.
    ::   here, we just read the file contents from %linedb into `%mime`s
    ::   and let clay handle the markification:
    ::   this requires that the files have marks to convert from
    ::   `%mime` to the respective type
    =*  file-atom  (of-wain:format file)
    :+  path  %&
    [%mime /application/x-urb-unknown (as-octs:mimes:html file-atom)]
  :_  cache
  :^  %&  desk-name
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
        [/app/[dude]/hoon %& %hoon (gen-app:ldb /app/[dude]/vase)]
    ==
  .^(rang:clay %cx /(scot %p our.bowl)//(scot %da now.bowl)/rang)
--

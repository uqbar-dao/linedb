/-  *linedb, b=branch
/+  ldb=linedb, sss, default-agent, verb, dbug
::
=>  |%
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          subs=_(mk-subs:sss b sss-paths)
          pubs=_(mk-pubs:sss b sss-paths)
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
          [%x %log @ @tas @tas ~]                          ::  list of all metadata
        =*  who  (slav %p i.t.t.path)
        =*  sss  t.t.t.path
        log:(ba:hc who sss)
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
        history:(ba:hc who sss)
      ::
          [%x @ @tas @tas ?(%head @) ~]                    ::  get a list of files
        =*  who          (slav %p i.t.path)
        =*  repo                i.t.t.path
        =*  branch            i.t.t.t.path
        %-  turn  :_  head
        ?-  hash=i.t.t.t.t.path
          %head  ~(tap by head-snap:(ba:hc who [repo branch ~]))
          @      ~(tap by (get-snap:(ba:hc who [repo branch ~]) (slav %ux hash)))
        ==
      ::
          [%x @ @tas @tas ?(%head @) ^]                    ::  read a file
        =*  who  (slav %p i.t.path)
        =*  repo        i.t.t.path
        =*  branch    i.t.t.t.path
        =*  file    t.t.t.t.t.path
        ?-  hash=i.t.t.t.t.path
          %head  (head-file:(ba:hc who [repo branch ~]) file)
          @      (get-file:(ba:hc who [repo branch ~]) (slav %ux hash) file)
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
+*  dab  =/  da  (da:sss b sss-paths)
         (da subs bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    dub  =/  du  (du:sss b sss-paths)
         (du pubs bowl -:!>(*result:du))
::
++  all-rocks
  ^-  (map [ship sss-paths] rock:b)
  %-  %~  uni  by
      ::  pubs
      %-  ~(gas by *(map [ship sss-paths] rock:b))
      %+  turn  ~(tap by read:dub)
      |=  [=sss-paths * =rock:b]
      [[our.bowl sss-paths] rock]
  ::  subs
  %-  ~(gas by *(map [ship sss-paths] rock:b))
  %+  turn  ~(tap by read:dab)
  |=  [[=ship * =sss-paths] * * =rock:b]
  [[ship sss-paths] rock]
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
  ::
      %install
    =^  vases=(list [dude:gall (each vase @t)])  build-cache
      =|  res=(list [dude:gall (each vase @t)])
      |-
      ?~  bill.act  [res build-cache]
      =/  [built-file=(each vase @t) =build-state]
        %.  /app/[i.bill.act]/hoon
        %~  build-file  ub:(ba [from repo branch ~]:act)
        [build-cache ~]
      %=  $
        bill.act     t.bill.act
        res          [[i.bill.act built-file] res]
        build-cache  build-cache.build-state
      ==
    =/  all-files=(list [path %& page])        
      %+  murn  ~(tap by head-snap:(ba [from repo branch ~]:act))
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
          [/app/[dude]/hoon %& %hoon (gen-app:ldb /app/[dude]/vase)]
      ==
    .^(rang:clay %cx /(scot %p our.bowl)//(scot %da now.bowl)/rang)
  ::
      %build
    =/  [built-file=(each vase @t) =build-state]
      %.  file.act
      %~  build-file  ub:(ba [from repo branch ~]:act)
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
::
::  branch engine
::
++  ba
  |=  [from=@p ban=sss-paths]
  =+  (~(gut by all-rocks) [from ban] *branch) :: not sure if +gut is good here
  =*  branch  -
  ::
  |%
  ::  read arms
  ::
  ++  get-commit   |=(h=hash (~(get by hash-index.branch) h))
  ++  get-snap     |=(h=hash snap:(need (get-commit h)))
  ++  get-file     |=([h=hash p=path] (of-wain:format (~(got by (get-snap h)) p)))
  ++  get-directory :: TODO this gets a lot more efficient with an +axal
    |=  [=hash nedl=path]
    ^-  (list [path file])
    %+  murn  ~(tap by (get-snap hash))
    |=  [hstk=path =file]
    ?.  =(`0 (find nedl hstk))  ~
    `[hstk file]
  ::
  ++  head-commit  ?>(?=(^ commits.branch) i.commits.branch)
  ++  head-snap    snap:head-commit
  ++  head-file    |=(p=path (of-wain:format (~(gut by head-snap) p *file)))
  ++  head-directory
    |=  nedl=path
    ^-  (list [path file])
    %+  murn  ~(tap by head-snap)
    |=  [hstk=path =file]
    ?.  =(`0 (find nedl hstk))  ~
    `[hstk file]
  ::
  ++  history          (turn commits.branch |=(=commit hash.commit))
  ++  log
    ^-  (list [hash hash @p @da])
    %+  turn  commits.branch
    |=(c=commit [hash parent author time]:c)
  ::
  ::  uqbuild engine
  ::
  ++  ub
    =|  build-state :: [build-cache=(map @ux vase) cycle=(set seen-file)]
    =*  build-state  -
    |%
    ++  read-file  |=(=path (head-file path))
    ++  build-dependency
      |=  dep=(each [dir=path fil=path] path)
      ^-  [(each vase @t) ^build-state]
      =/  p=path  ?:(?=(%| -.dep) p.dep fil.p.dep)
      ~&  %bd^%start^p
      ~|  %error-building^p
      ?:  (~(has in cycle) build+p)
        ~|(cycle+file+p^cycle !!)
      =.  cycle  (~(put in cycle) build+p)
      ?>  =(%hoon (rear p))
      =/  file-text=@t   (read-file p)
      =/  file-hash=@ux  (shax file-text)
      ?^  cax=(~(get by build-cache) file-hash)
        [%&^u.cax build-state]
      =/  =pile:clay  (parse-pile p (trip file-text))
      =^  subject=vase  build-state  (run-prelude pile)
      =/  build-result  (mule |.((slap subject hoon.pile)))
      ?:  ?=(%| -.build-result)
        :_  build-state
        :-  %|
        %-  of-wain:format
        %+  turn  p.build-result
        |=(=tank (crip ~(ram re tank)))
      =.  build-cache
        (~(put by build-cache) file-hash p.build-result)
      ~&  %bd^%done^p
      [%&^p.build-result build-state]
    ::
    ++  build-file
      |=  =path
      ^-  [(each vase @t) ^build-state]
      (build-dependency |+path)
    ::
    ++  parse-pile
      |=  [pax=path tex=tape]
      ^-  pile:clay
      =/  [=hair res=(unit [=pile:clay =nail])]  ((pile-rule pax) [1 1] tex)
      ?^  res  pile.u.res
      %-  mean  %-  flop
      =/  lyn  p.hair
      =/  col  q.hair
      ^-  (list tank)
      :~  leaf+"syntax error at [{<lyn>} {<col>}] in {<pax>}"
        ::
          =/  =wain  (to-wain:format (crip tex))
          ?:  (gth lyn (lent wain))
            '<<end of file>>'
          (snag (dec lyn) wain)
        ::
          leaf+(runt [(dec col) '-'] "^")
      ==
    ::
    ++  pile-rule
      |=  pax=path
      %-  full
      %+  ifix
        :_  gay
        ::  parse optional /? and ignore
        ::
        ;~(plug gay (punt ;~(plug fas wut gap dem gap)))
      |^
      ;~  plug
        %+  cook  (bake zing (list (list taut:clay)))
        %+  rune  hep
        (most ;~(plug com gaw) taut-rule)
      ::
        %+  cook  (bake zing (list (list taut:clay)))
        %+  rune  lus
        (most ;~(plug com gaw) taut-rule)
      ::
        %+  rune  tis
        ;~(plug sym ;~(pfix gap stap))
      ::
        %+  rune  sig
        ;~((glue gap) sym wyde:vast stap)
      ::
        %+  rune  cen
        ;~(plug sym ;~(pfix gap ;~(pfix cen sym)))
      ::
        %+  rune  buc
        ;~  (glue gap)
          sym
          ;~(pfix cen sym)
          ;~(pfix cen sym)
        ==
      ::
        %+  rune  tar
        ;~  (glue gap)
          sym
          ;~(pfix cen sym)
          ;~(pfix stap)
        ==
      ::
        %+  stag  %tssg
        (most gap tall:(vang & pax))
      ==
      ::
      ++  pant
        :: |*  fel=^rule
        |*  fel=rule
        ;~(pose fel (easy ~))
      ::
      ++  mast
        :: |*  [bus=^rule fel=^rule]
        |*  [bus=rule fel=rule]
        ;~(sfix (more bus fel) bus)
      ::
      ++  rune
        :: |*  [bus=^rule fel=^rule]
        |*  [bus=rule fel=rule]
        %-  pant
        %+  mast  gap
        ;~(pfix fas bus gap fel)
      --
    ::
    ++  taut-rule
      %+  cook  |=(taut:clay +<)
      ;~  pose
        (stag ~ ;~(pfix tar sym))
        ;~(plug (stag ~ sym) ;~(pfix tis sym))
        (cook |=(a=term [`a a]) sym)
      ==
    ::
    ++  run-prelude
      |=  =pile:clay
      ^-  [vase ^build-state]
      =/  sut=vase  !>(..zuse)  :: TODO: cache?
      =^  sut=vase  build-state  (run-tauts sut %sur sur.pile)
      =^  sut=vase  build-state  (run-tauts sut %lib lib.pile)
      =^  sut=vase  build-state  (run-raw sut raw.pile)
      :: =^  sut=vase  build-state  (run-raz sut raz.pile)
      :: =^  sut=vase  build-state  (run-maz sut maz.pile)
      :: =^  sut=vase  build-state  (run-caz sut caz.pile)
      =^  sut=vase  build-state  (run-bar sut bar.pile)
      [sut build-state]
    ::
    ++  run-tauts
      |=  [sut=vase wer=?(%lib %sur) taz=(list taut:clay)]
      ^-  [vase ^build-state]
      ?~  taz  [sut build-state]
      =^  pin=(each vase @t)  build-state  (build-fit wer pax.i.taz)
      ?:  ?=(%| -.pin)  ~&  'build-failed'  $(taz t.taz)
      =?  p.p.pin  ?=(^ face.i.taz)  [%face u.face.i.taz p.p.pin]
      $(sut (slop p.pin sut), taz t.taz)
    ::
    ++  run-raw
      |=  [sut=vase raw=(list [face=term =path])]
      ^-  [vase ^build-state]
      ?~  raw  [sut build-state]
      =^  pin=(each vase @t)  build-state  (build-file (snoc path.i.raw %hoon))
      ?:  ?=(%| -.pin)  ~&  'build-failed'  $(raw t.raw)
      =.  p.p.pin  [%face face.i.raw p.p.pin]
      $(sut (slop p.pin sut), raw t.raw)
    :: ::
    :: ++  run-raz
    ::   |=  [sut=vase raz=(list [face=term =spec =path])]
    ::   ^-  [vase state]
    ::   ?~  raz  [sut build-state]
    ::   =^  res=(map @ta vase)  build-state
    ::     (build-directory path.i.raz)
    ::   =;  pin=vase
    ::     =.  p.pin  [%face face.i.raz p.pin]
    ::     $(sut (slop pin sut), raz t.raz)
    ::   ::
    ::   =/  =type  (~(play ut p.sut) [%kttr spec.i.raz])
    ::   ::  ensure results nest in the specified type,
    ::   ::  and produce a homogenous map containing that type.
    ::   ::
    ::   :-  %-  ~(play ut p.sut)
    ::       [%kttr %make [%wing ~[%map]] ~[[%base %atom %ta] spec.i.raz]]
    ::   |-
    ::   ?~  res  ~
    ::   ?.  (~(nest ut type) | p.q.n.res)
    ::     ~|  [%nest-fail path.i.raz p.n.res]
    ::     !!
    ::   :-  [p.n.res q.q.n.res]
    ::   [$(res l.res) $(res r.res)]
    :: ::
    :: ++  run-maz
    ::   |=  [sut=vase maz=(list [face=term =mark])]
    ::   ^-  [vase state]
    ::   ?~  maz  [sut build-state]
    ::   =^  pin=vase  build-state  (build-nave mark.i.maz)
    ::   =.  p.pin  [%face face.i.maz p.pin]
    ::   $(sut (slop pin sut), maz t.maz)
    :: ::
    :: ++  run-caz
    ::   |=  [sut=vase caz=(list [face=term =mars:clay])]
    ::   ^-  [vase state]
    ::   ?~  caz  [sut build-state]
    ::   =^  pin=vase  build-state  (build-cast mars.i.caz)
    ::   =.  p.pin  [%face face.i.caz p.pin]
    ::   $(sut (slop pin sut), caz t.caz)
    ::
    ++  run-bar  :: TODO extremely ugly
      |=  [sut=vase bar=(list [face=term =mark =path])]
      ^-  [vase ^build-state]
      ~|  "uqbuild: cannot import {<mark>} with /*"
      ?~  bar  [sut build-state]
      ?>  =((rear path.i.bar) mark.i.bar)
      =/  =cage
        ?+  mark.i.bar  !!  :: TODO other marks
          %noun  noun+!>((read-file path.i.bar))
          %jam   jam+!>((read-file path.i.bar))
        ==
      =.  p.q.cage  [%face face.i.bar p.q.cage]
      $(sut (slop q.cage sut), bar t.bar)
    ::
    ::  +build-fit: build file at path, maybe converting '-'s to '/'s in path
    ::
    ++  build-fit
      |=  [pre=@tas pax=@tas]
      ^-  [(each vase @t) ^build-state]
      (build-file (fit-path pre pax))
    ::
    ::  +fit-path: find path, maybe converting '-'s to '/'s
    ::
    ::    Try '-' before '/', applied left-to-right through the path,
    ::    e.g. 'a-foo/bar' takes precedence over 'a/foo-bar'.
    ::
    ++  fit-path
      |=  [pre=@tas pax=@tas]
      ^-  path
      =/  paz  (segments:clay pax)
      |-  ^-  path
      ?~  paz
        ~_(leaf/"clay: no files match /{(trip pre)}/{(trip pax)}/hoon" !!)
      =/  pux=path  pre^(snoc i.paz %hoon)
      ?:  (~(has by head-snap) pux)
        pux
      $(paz t.paz)
    --
  --
--

/-  *linedb
::
|_  bus=build-state
++  read-file
  |=  =path
  (of-wain:format (~(got by snap.bus) path))
::
::  TODO: rewrite this
::  +build-dependency
::    (1) parse the imports and recursively call
::        +build-dependency on them,
::    (2) surface whether the dependencies built
::        were result of a cache hit (is-hit=%.y)
::        or not
::    (3) if =(%.n is-hit), we need to re-build here
::        as well, since dependencies changed
::    (4) else, check if we have cached build
::    (5) if have cache: return cache hit
::    (6) else: parse entire file and build
::
++  build-dependency
  |=  dep=(each [dir=path fil=path] path)
  ~&  %bd^%bus^~(wyt by snap.bus)^~(wyt by p.cache.bus)^~(wyt by cycle.bus)^?=(~ byob.bus)
  ^-  [(each [=vase is-hit=?] tang) build-state]
  =/  p=path  ?:(?=(%| -.dep) p.dep fil.p.dep)
  ~|  error-building+p
  ?:  (~(has in cycle.bus) p)
    ~&  uqbuild+cycle+file+p^cycle.bus
    :_  bus
    :+  %|  %leaf
    "encountered cyclic import: {<`path`p>} {<cycle.bus>}"
  =.  cycle.bus  (~(put in cycle.bus) p)
  ?>  =(%hoon (rear p))
  =/  file-text=@t   (read-file p)
  =/  file-hash=@ux  (shax file-text)
  =/  =build-system
    ?^  byob.bus  u.byob.bus
    [!>(build-vanilla-hoon) !>(build-vanilla-hoon-top-level)]
  =.  byob.bus
    ?~  byob.bus  byob.bus
    `[build.u.byob.bus !>(build-vanilla-hoon-top-level)]
  =.  build.build-system  build.build-system(+6.q bus)
  ::  (1) & (2)
  =/  parsed-imports=vase
    %+  slym  (slap build.build-system (ream %imports))
    [p (trip file-text)]
  =/  build-subject-result-vase=vase
    %+  slam  (slap build.build-system (ream %build-subject))
    parsed-imports
  =^    build-subject-result=(each (pair vase ?) tang)
      bus
    !<  [(each [vase ?] tang) build-state]
    build-subject-result-vase
  ?:  ?=(%| -.build-subject-result)
    =*  error-message
      %-  of-wain:format
      %+  turn  p.build-subject-result
      |=(=tank (crip ~(ram re tank)))
    ~&  bd+build-subject-fail+error-message
    [%|^p.build-subject-result bus]
  =*  subject  p.p.build-subject-result
  =*  is-hit   q.p.build-subject-result
  ::  (3) & (4)
  =/  cax  (~(get by p.cache.bus) file-hash)
  ?:  &(is-hit ?=(^ cax))
    ::  (5)
    :-  %&^u.cax^%.y
    %=  bus
        cycle  (~(del in cycle.bus) p)
        q.cache
      %.  [today.bus file-hash]
      %~  del  ju
      (~(put ju q.cache.bus) today.bus file-hash)
    ==
  ::  (6)
  =/  parsed-hoon-vase=vase
    %+  slym  (slap build.build-system (ream %hoon))
    [p (trip file-text)]
  =+  !<(parsed-hoon=hoon parsed-hoon-vase)
  :: =/  build-result  (mule |.((slap subject parsed-hoon)))
  =/  build-result
    %-  mule  |.
    !<  vase
    (slym top-level.build-system [subject parsed-hoon])
  ?:  ?=(%| -.build-result)
    =*  error-message
      %-  of-wain:format
      %+  turn  p.build-result
      |=(=tank (crip ~(ram re tank)))
    ~&  bd+slap-fail+error-message
    [%|^p.build-result bus]
  =.  cache.bus
    :-  (~(put by p.cache.bus) file-hash p.build-result)
    (~(put ju q.cache.bus) today.bus file-hash)
  [%&^p.build-result^%.n bus(cycle (~(del in cycle.bus) p))]
::
++  build-file-internal
  |=  =path
  ^-  [(each [=vase is-hit=?] tang) build-state]
  (build-dependency |+path)
::
++  build-file
  |=  =path
  ^-  [(each vase tang) build-state]
  =/  [result=(each [=vase is-hit=?] tang) bus=build-state]
    (build-dependency |+path)
  :_  bus
  ?:  ?=(%| -.result)  %|^p.result
  %&^vase.p.result
::
++  run-prelude
  |=  pile=pile-imports
  ^-  [(each [subject=vase is-hit=?] tang) build-state]
  ::  /-
  =^  hep=(each (pair vase ?) tang)  bus
    (run-tauts !>(..zuse) %sur sur.pile)
  ?:  ?=(%| -.hep)  [%|^p.hep bus]
  ::  /+
  =^  lus=(each (pair vase ?) tang)  bus
    (run-tauts p.p.hep %lib lib.pile)
  ?:  ?=(%| -.lus)  [%|^p.lus bus]
  ::  /=
  =^  tis=(each (pair vase ?) tang)  bus
    (run-tis p.p.lus raw.pile)
  ?:  ?=(%| -.tis)  [%|^p.tis bus]
  ::  /*
  =^  tar=(each (pair vase ?) tang)  bus
    (run-tar p.p.tis bar.pile)
  ?:  ?=(%| -.tar)  [%|^p.tar bus]
  [%&^p.p.tar^&(q.p.hep q.p.lus q.p.tis q.p.tar) bus]
::
++  run-tauts
  |=  [sut=vase wer=?(%lib %sur) taz=(list taut:clay)]
  ^-  [(each [vase is-hit=?] tang) build-state]
  =/  is-hit=?  %.y
  |-
  ?~  taz  [%&^sut^is-hit bus]
  =^  pin=(each (pair vase ?) tang)  bus
    (build-fit wer pax.i.taz)
  ?:  ?=(%| -.pin)  [%|^p.pin bus]
  =?  p.p.p.pin  ?=(^ face.i.taz)  [%face u.face.i.taz p.p.p.pin]
  %=  $
    sut     (slop p.p.pin sut)
    taz     t.taz
    is-hit  &(is-hit q.p.pin)
  ==
::
++  run-tis
  |=  [sut=vase raw=(list [face=term =path])]
  ^-  [(each [vase is-hit=?] tang) build-state]
  =/  is-hit=?  %.y
  |-
  ?~  raw  [%&^sut^is-hit bus]
  =^  pin=(each (pair vase ?) tang)  bus
    (build-file-internal (snoc path.i.raw %hoon))
  ?:  ?=(%| -.pin)  [%|^p.pin bus]
  =.  p.p.p.pin  [%face face.i.raw p.p.p.pin]
  %=  $
    sut     (slop p.p.pin sut)
    raw     t.raw
    is-hit  &(is-hit q.p.pin)
  ==
::
++  run-tar
  |=  [sut=vase bar=(list [face=term =mark =path])]
  ^-  [(each [vase is-hit=?] tang) build-state]
  ?~  bar  [%&^sut^%.y bus]
  ~|  "uqbuild: cannot import {<path.i.bar>} with mark {<(rear path.i.bar)>} with /*"
  ?>  =((rear path.i.bar) mark.i.bar)
  ::  TODO: support additional marks?
  ?>  |(?=(%noun mark.i.bar) ?=(%jam mark.i.bar))
  =/  file-contents=@  (read-file path.i.bar)
  =/  file-mime=vase
    !>  :+  /application/x-urb-vase  (met 3 file-contents)
        file-contents
  ~&  %uqbuild^%vase-expected-shape^?=([* * @] +.file-mime)
  =.  p.file-mime  [%face face.i.bar p.file-mime]
  $(sut (slop file-mime sut), bar t.bar)
::
::  +build-fit: build file at path, maybe converting '-'s to '/'s in path
::
++  build-fit
  |=  [pre=@tas pax=@tas]
  ^-  [(each [vase ?] tang) build-state]
  =/  path-result  (mule |.((fit-path pre pax)))
  ?:  ?=(%| -.path-result)
    :_  bus
    :-  %|
    [%leaf "no files match /{(trip pre)}/{(trip pax)}/hoon"]
  (build-file-internal p.path-result)
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
    ~&  "no files match /{(trip pre)}/{(trip pax)}/hoon"
    !!
  =/  pux=path  pre^(snoc i.paz %hoon)
  ?:  (~(has by snap.bus) pux)
    pux
  $(paz t.paz)
::
++  da-to-today
  |=  time=@da
  ^-  @da
  =/  date-form=date  (yore time)
  (year date-form(t [d.t.date-form 0 0 0 ~]))
::
++  compute-cache-size-by-day
  ^-  (map @da [number-cache-entries=@ud total-size=@ud])
  %-  ~(gas by *(map @da [@ud @ud]))
  %+  turn  ~(tap by q.cache.bus)
  |=  [day=@da entries=(set @ux)]
  :-  day
  %+  roll  ~(tap in entries)
  |=  [entry=@ux [number-cache-entries=@ud total-size=@ud]]
  :-  +(number-cache-entries)
  (add total-size (met 3 (jam (~(got by p.cache.bus) entry))))
::
++  build-vanilla-hoon-top-level
  |=  [subject=vase formula=hoon]
  ^-  vase
  (slap subject formula)
::
++  build-vanilla-hoon
  |_  bus=build-state
  ++  build-subject
    |=  imports=pile-imports
    ^-  [(each [subject=vase is-hit=?] tang) build-state]
    (run-prelude imports)
  ::
  ++  imports
    |=  [pax=path tex=tape]
    ^-  pile-imports
    =/  [=hair res=(unit [pile=pile-imports =nail])]
      ((imports-rule pax) [1 1] tex)
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
  ++  imports-rule
    |=  pax=path
    %+  ifix
      :_  gay
      ::  parse optional /? and ignore
      ::
      ;~(plug gay (punt ;~(plug fas wut gap dem gap)))
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
      %+  rune  tar
      ;~  (glue gap)
        sym
        ;~(pfix cen sym)
        ;~(pfix stap)
      ==
    ==
  ::
  ++  hoon
    |=  [pax=path tex=tape]
    ^-  ^hoon
    hoon:(full-file pax tex)
  ::
  ++  full-file
    |=  [pax=path tex=tape]
    ^-  pile:clay
    =/  [=hair res=(unit [=pile:clay =nail])]
      ((full-file-rule pax) [1 1] tex)
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
  ++  full-file-rule
    |=  pax=path
    ::  TODO I believe we can delete a lot of this since we aren't parsing
    ::    certain ford runes
    %-  full
    %+  ifix
      :_  gay
      ::  parse optional /? and ignore
      ::
      ;~(plug gay (punt ;~(plug fas wut gap dem gap)))
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
    |*  fel=rule
    ;~(pose fel (easy ~))
  ::
  ++  mast
    |*  [bus=rule fel=rule]
    ;~(sfix (more bus fel) bus)
  ::
  ++  rune
    |*  [bus=rule fel=rule]
    %-  pant
    %+  mast  gap
    ;~(pfix fas bus gap fel)
  ::
  ++  taut-rule
    %+  cook  |=(taut:clay +<)
    ;~  pose
      (stag ~ ;~(pfix tar sym))
      ;~(plug (stag ~ sym) ;~(pfix tis sym))
      (cook |=(a=term [`a a]) sym)
    ==
  --
--

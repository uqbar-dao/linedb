/-  *linedb
::
|_  bus=build-state
++  read-file
  |=  =path
  (of-wain:format (~(gut by snap.bus) path *file))
++  build-dependency
  |=  dep=(each [dir=path fil=path] path)
  ^-  [(each vase @t) build-state]
  =/  p=path  ?:(?=(%| -.dep) p.dep fil.p.dep)
  ~&  bd+star+p
  ~|  error-building+p
  ?:  (~(has in cycle.bus) p)
    ~|(cycle+file+p^cycle.bus !!)
  =.  cycle.bus  (~(put in cycle.bus) p)
  ?>  =(%hoon (rear p))
  =/  file-text=@t   (read-file p)
  =/  file-hash=@ux  (shax file-text)
  ?^  cax=(~(get by cache.bus) file-hash)
    [%&^u.cax bus]
  =/  =pile:clay  (parse-pile p (trip file-text))
  =^  subject=vase  bus  (run-prelude pile)
  =/  build-result  (mule |.((slap subject hoon.pile)))
  ?:  ?=(%| -.build-result)
    :_  bus
    :-  %|
    %-  of-wain:format
    %+  turn  p.build-result
    |=(=tank (crip ~(ram re tank)))
  =.  cache.bus
    (~(put by cache.bus) file-hash p.build-result)
  ~&  bd+done+p
  [%&^p.build-result bus]
::
++  build-file
  |=  =path
  ^-  [(each vase @t) build-state]
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
  ::  TODO I believe we can delete a lot of this since we aren't parsing
  ::    certain ford runes
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
  ^-  [vase build-state]
  =/  sut=vase  !>(..zuse)  :: TODO: cache?
  =^  sut=vase  bus  (run-tauts sut %sur sur.pile)  ::  /-
  =^  sut=vase  bus  (run-tauts sut %lib lib.pile)  ::  /+
  =^  sut=vase  bus  (run-tis sut raw.pile)         ::  /=
  =^  sut=vase  bus  (run-tar sut bar.pile)         ::  /*
  [sut bus]
::
++  run-tauts
  |=  [sut=vase wer=?(%lib %sur) taz=(list taut:clay)]
  ^-  [vase build-state]
  ?~  taz  [sut bus]
  =^  pin=(each vase @t)  bus  (build-fit wer pax.i.taz)
  ?:  ?=(%| -.pin)  ~&  'build-failed'  $(taz t.taz)
  =?  p.p.pin  ?=(^ face.i.taz)  [%face u.face.i.taz p.p.pin]
  $(sut (slop p.pin sut), taz t.taz)
::
++  run-tis
  |=  [sut=vase raw=(list [face=term =path])]
  ^-  [vase build-state]
  ?~  raw  [sut bus]
  =^  pin=(each vase @t)  bus  (build-file (snoc path.i.raw %hoon))
  ?:  ?=(%| -.pin)  ~&  'build-failed'  $(raw t.raw)
  =.  p.p.pin  [%face face.i.raw p.p.pin]
  $(sut (slop p.pin sut), raw t.raw)
::
++  run-tar  :: TODO extremely ugly
  |=  [sut=vase bar=(list [face=term =mark =path])]
  ^-  [vase build-state]
  ~|  "uqbuild: cannot import {<mark>} with /*"
  ?~  bar  [sut bus]
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
  ^-  [(each vase @t) build-state]
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
  ?:  (~(has by snap.bus) pux)
    pux
  $(paz t.paz)
--
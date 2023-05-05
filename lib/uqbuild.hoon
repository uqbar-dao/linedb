/-  *linedb
::
=>  |%
    +$  state
      $:  cache=flow
          flue
          cycle=(set path)
          stack=(list (set leak))
      ==
    +$  args
      $:  files=(map path file)
          verb=@
          cache=flow
          flue
      ==
    --
|=  args
::  nub: internal mutable state for this computation
::
=|  nub=state
=.  cache.nub  cache
=.  spill.nub  spill
=.  sprig.nub  sprig
|%
::  +read-file: retrieve marked, validated file contents at path
::
++  read-file
  |=  =path
  ^-  [vase state]
  ~|  error-validating+path
  =;  [pin=pour nob=state]
    ?>  ?=(%& -.pin)
    [p.pin nob]
  %+  gain-sprig  path  |.
  =.  stack.nub  [~ stack.nub]
  ?:  (~(has in cycle.nub) vale+path)
    ~|(cycle+path^cycle.nub !!)
  =.  cycle.nub  (~(put in cycle.nub) path)
  %+  gain-leak  path
  |=  nob=state
  ^-  [pour state]
  =.  nub  nob
  %-  (trace 1 |.("read file {(spud path)}"))
  :_  nub
  :-  %&
  !>  %-  of-wain:format
  ~|  file-not-found+path
  (~(got by files) path)
::
++  prelude
  |=  =path
  ^-  vase
  =^  vax=vase  nub  (read-file path)
  =/  tex=tape   (trip !<(@t vax))
  =/  =pile:clay  (parse-pile path tex)
  =.  hoon.pile  !,(*hoon .)
  =^  res=vase  nub  (run-prelude pile)
  res
::
++  build-file
  |=  =path
  ^-  [pour state]
  ~|  %error-building^path
  %+  gain-sprig  path  |.
  =.  stack.nub  [~ stack.nub]
  %-  (trace 1 |.("make file {(spud path)}"))
  ?:  (~(has in cycle.nub) file+path)
    ~|(cycle+file+path^cycle.nub !!)
  =.  cycle.nub  (~(put in cycle.nub) file+path)
  =^  vax=vase  nub  (read-file path)
  =/  tex=tape  (trip !<(@t vax))
  =/  =pile:clay  (parse-pile path tex)
  =^  sut=vase  nub  (run-prelude pile)
  %+  gain-leak  path
  |=  nob=state
  =.  nub  nob
  =/  pin=pour  (mule |.((slap sut hoon.pile)))
  [pin nub]
::
++  run-prelude
  |=  =pile:clay
  =/  sut=vase  !>(..zuse)
  =^  sut=vase  nub  (run-tauts sut %sur sur.pile)
  =^  sut=vase  nub  (run-tauts sut %lib lib.pile)
  =^  sut=vase  nub  (run-tis sut raw.pile)
  =^  sut=vase  nub  (run-tar sut bar.pile)
  [sut nub]
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
  ::  TODO we can stop parsing runes we don't use
  ::
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
    |*  fel=^rule
    ;~(pose fel (easy ~))
  ::
  ++  mast
    |*  [bus=^rule fel=^rule]
    ;~(sfix (more bus fel) bus)
  ::
  ++  rune
    |*  [bus=^rule fel=^rule]
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
++  run-tauts
  |=  [sut=vase wer=?(%lib %sur) taz=(list taut:clay)]
  ^-  [vase state]
  ?~  taz  [sut nub]
  =^  pin=pour  nub  (build-file (fit-path wer pax.i.taz))
  ?:  ?=(%| -.pin)  ~&  build-failed+pax.i.taz  !!
  =?  p.p.pin  ?=(^ face.i.taz)  [%face u.face.i.taz p.p.pin]
  $(sut (slop p.pin sut), taz t.taz)
::
++  run-tis
  |=  [sut=vase raw=(list [face=term =path])]
  ^-  [vase state]
  ?~  raw  [sut nub]
  =^  pin=pour  nub  (build-file (snoc path.i.raw %hoon))
  ?:  ?=(%| -.pin)  ~&  build-failed+path.i.raw  !!
  =.  p.p.pin  [%face face.i.raw p.p.pin]
  $(sut (slop p.pin sut), raw t.raw)
::
++  run-tar
  |=  [sut=vase bar=(list [face=term =mark =path])]
  ^-  [vase state]
  ?~  bar  [sut nub]
  ~|  "uqbuild: cannot import {<mark>} with /*"
  ?>  =((rear path.i.bar) mark.i.bar)
  =^  vax=vase  nub
    ?+  mark.i.bar  !!  :: TODO other marks
      %noun  (read-file path.i.bar)
      %jam   (read-file path.i.bar)
    ==
  =.  p.vax  [%face face.i.bar p.vax]
  $(sut (slop vax sut), bar t.bar)
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
  ?:  (~(has by files) pux)
    pux
  $(paz t.paz)
::
++  trace
  |=  [pri=@ print=(trap tape)]
  ?:  (lth verb pri)
    same
  (slog (crip "uqbuild: {(print)}") ~) :: TODO idk if this is correct +slogging
::
::  +gain-sprig: if path is in the sprig cache, put it on the stack, otherwise call $
::
++  gain-sprig
  |=  [=path next=(trap [pour state])]
  ^-  [pour state]
  ?~  got=(~(get by sprig.nub) path)
    $:next
  =?  stack.nub  ?=(^ stack.nub)
    stack.nub(i (~(put in i.stack.nub) leak.u.got))
  [%&^vase.u.got nub]
::
::  +gain-leak:
::    pop top off the stack to create a new leak (key)
::    delete path from cycle (why here?)
::    add this key to i.stack if it exists
::    if the key is in the spill, then put it in the cache as well
::    other wise create a new entry in the cache, remembering to bump refs of all it's dependencies
::
++  gain-leak
  |=  [=path next=$-(state [pour state])]
  ^-  [pour state]
  =^  top=(set leak)  stack.nub  stack.nub
  =/  =leak  [path top]
  =.  cycle.nub  (~(del in cycle.nub) path)
  =?  stack.nub  ?=(^ stack.nub)
    stack.nub(i (~(put in i.stack.nub) leak))
  =/  spilt  (~(has in spill.nub) leak)
  =^  =vase  nub
    ?^  got=(~(get by cache.nub) leak)
      %-  %+  trace  3  |.
          =/  refs    ?:(spilt 0 1)
          %+  welp  "cache {<path.leak>}: adding {<refs>}, "
          "giving {<(add refs refs.u.got)>}"
      =?  cache.nub  !spilt
        (~(put by cache.nub) leak [+(refs.u.got) vase.u.got])
      [vase.u.got nub]
    %-  (trace 2 |.("cache {<path.leak>}: creating"))
    =^  pin=pour  nub  (next nub)
    =/  =vase
      ?:  ?=(%& -.pin)  p.pin
      ~&  [%build-failed path.leak (turn p.pin |=(=tank ~(ram re tank)))]  !!
    =.  cache.nub  (~(put by cache.nub) leak [1 vase])
    ::  If we're creating a cache entry, add refs to our dependencies
    ::
    =/  deps  ~(tap in deps.leak)
    |-
    ?~  deps
      [vase nub]
    =/  got  (~(got by cache.nub) i.deps)
    %-  %+  trace  3  |.
        %+  welp  "cache {<path.leak>} for {<path.i.deps>}"
        ": bumping to ref {<refs.got>}"
    =.  cache.nub  (~(put by cache.nub) i.deps got(refs +(refs.got)))
    $(deps t.deps)
  ?:  spilt
    [%&^vase nub]
  %-  (trace 3 |.("spilt {<path>}"))
  =:  spill.nub  (~(put in spill.nub) leak)
      sprig.nub  (~(put by sprig.nub) path leak vase)
    ==
  [%&^vase nub]
--

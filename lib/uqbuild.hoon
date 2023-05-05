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
  ?:  (~(has in cycle.nub) path)
    ~|(cycle+path^cycle.nub !!)
  =.  cycle.nub  (~(put in cycle.nub) path)
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
    %+  rune  sig                                      ::  could delete /~
    ;~((glue gap) sym wyde:vast stap)
  ::
    %+  rune  cen                                      ::  could delete /%
    ;~(plug sym ;~(pfix gap ;~(pfix cen sym)))
  ::
    %+  rune  buc                                      ::  could delete /$
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
::  +gain-sprig: check if path is in sprig cache before building
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
::  +gain-leak
::
++  gain-leak
  |=  [=path next=$-(state [pour state])]
  ^-  [pour state]
  ::  pop a set of dependencies off the stack
  ::
  =^  top=(set leak)  stack.nub  stack.nub
  =/  =leak  [path top]
  ::  delete this from the cycle
  ::
  =.  cycle.nub  (~(del in cycle.nub) path)
  ::  add it to the next set of deps on the stack
  ::
  =?  stack.nub  ?=(^ stack.nub)
    stack.nub(i (~(put in i.stack.nub) leak))
  =/  spilt  (~(has in spill.nub) leak)
  =^  =vase  nub
    ?^  got=(~(get by cache.nub) leak)
      ::  if leak is in the cache
      ::
      %-  %+  trace  3  |.
          =/  refs    ?:(spilt 0 1)
          %+  welp  "cache {<path.leak>}: adding {<refs>}, "
          "giving {<(add refs refs.u.got)>}"
      ::  update the cache entry
      ::
      =?  cache.nub  !spilt
        (~(put by cache.nub) leak [+(refs.u.got) vase.u.got])
      [vase.u.got nub]
    ::  otherwise create the cache entry
    ::
    %-  (trace 2 |.("cache {<path.leak>}: creating"))
    ::  TODO what is in next
    ::
    =^  pin=pour  nub  (next nub)
    =/  =vase
      ?:  ?=(%& -.pin)  p.pin
      ~&  [%build-failed path.leak (turn p.pin |=(=tank ~(ram re tank)))]  !!
    ::  add the build to the cache, update refs to dependencies
    ::
    =.  cache.nub  (~(put by cache.nub) leak [1 vase])
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
  ::  if its in spill, continue
  ::
  ?:  spilt  [%&^vase nub]
  ::  otherwise, update the flue
  ::
  %-  (trace 3 |.("spilt {<path>}"))
  =:  spill.nub  (~(put in spill.nub) leak)
      sprig.nub  (~(put by sprig.nub) path leak vase)
    ==
  [%&^vase nub]
::
++  lose-leak
  |=  [verb=@ fad=flow =leak]
  ^-  flow
  ?~  got=(~(get by fad) leak)
    %-  (trace 0 |.("lose missing leak {<leak>}"))
    fad
  ?:  (lth 1 refs.u.got)
    %-  (trace 3 |.("cache {<path.leak>}: decrementing from {<refs.u.got>}"))
    =.  fad  (~(put by fad) leak u.got(refs (dec refs.u.got)))
    fad
  =+  ?.  =(0 refs.u.got)  ~
      ((trace 0 |.("lose zero leak {<leak>}")) ~)
  %-  (trace 2 |.("cache {<path.leak>}: freeing"))
  =.  fad  (~(del by fad) leak)
  =/  leaks  ~(tap in deps.leak)
  |-  ^-  flow
  ?~  leaks
    fad
  =.  fad  ^$(leak i.leaks)
  $(leaks t.leaks)
::
++  lose-leaks
  |=  [verb=@ fad=flow leaks=(set leak)]
  ^-  flow
  =/  leaks  ~(tap in leaks)
  |-
  ?~  leaks
    fad
  $(fad (lose-leak verb fad i.leaks), leaks t.leaks)
--

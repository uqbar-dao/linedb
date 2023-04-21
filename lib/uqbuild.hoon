/-  ub=uqbuild
::
:: |_  build-state:ub
=|  build-state:ub
=*  build-state  -
|%
::  $pile: preprocessed hoon source file
::
::    /-  sur-file            ::  surface imports from /sur
::    /+  lib-file            ::  library imports from /lib
::    /=  face  /path         ::  imports built hoon file at path
::    /~  face  type   /path  ::  imports built hoon files from directory
::    /%  face  %mark         ::  imports mark definition from /mar
::    /$  face  %from  %to    ::  imports mark converter from /mar
::    /*  face  %mark  /path  ::  unbuilt file imports, as mark
::
+$  pile
  $:  sur=(list taut)
      lib=(list taut)
      raw=(list [face=term =path])
      raz=(list [face=term =spec =path])
      maz=(list [face=term =mark])
      caz=(list [face=term =mars])
      bar=(list [face=term =mark =path])
      =hoon
  ==
::  $taut: file import from /lib or /sur
::  $mars: mark conversion request
+$  taut  [face=(unit term) pax=term]
+$  mars  [a=mark b=mark]
::
++  make-repo-path
  ^-  path
  =*  commit=@ta
    ?~  commit-hash  %head  (scot %ux u.commit-hash)
  /(scot %p repo-host)/[repo-name]/[branch-name]/[commit]
::
++  read-file
  |=  file-path=path
  ^-  @
  .^  @
      %gx
      ;:  weld
          /(scot %p our.bowl)/linedb/(scot %da now.bowl)
          make-repo-path
          file-path
          /noun
      ==
  ==
::
++  get-from-cache-or-run
  |=  [file-hash=@ux next=(trap [vase build-state:ub])]
  ?~  cache-result=(~(get by build-cache) file-hash)
    $:next
  [u.cache-result build-state]
::
++  build-dependency
  |=  dep=(each [dir=path fil=path] path)
  ^-  [vase build-state:ub]
  =/  p=path  ?:(?=(%| -.dep) p.dep fil.p.dep)
  ~&  %bd^%start^p
  ~|  %error-building^p  :: TODO
  :: ?:  (~(has in cycle) build+p)
  ::   ~|(cycle+file+p^cycle !!)  :: TODO
  :: =.  cycle  (~(put in cycle) build+p)
  ?>  =(%hoon (rear p))
  =/  file-text=@t  (read-file p)
  =/  file-hash=@ux  (shax file-text)
  %+  get-from-cache-or-run  file-hash
  |.  ^-  [vase build-state:ub]
  =/  =pile  (parse-pile p (trip file-text))
  =^  subject=vase  build-state  (run-prelude pile)
  =/  build-result  (mule |.((slap subject hoon.pile)))
  ?:  ?=(%| -.build-result)  ~|(p.build-result !!)  :: TODO
  =.  build-cache
    (~(put by build-cache) file-hash p.build-result)
  ~&  %bd^%done^p
  [p.build-result build-state]
::
++  build-file
  |=  =path
  (build-dependency |+path)
::
++  parse-pile
  |=  [pax=path tex=tape]
  ^-  pile
  =/  [=hair res=(unit [=pile =nail])]  ((pile-rule pax) [1 1] tex)
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
    %+  cook  (bake zing (list (list taut)))
    %+  rune  hep
    (most ;~(plug com gaw) taut-rule)
  ::
    %+  cook  (bake zing (list (list taut)))
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
  %+  cook  |=(taut +<)
  ;~  pose
    (stag ~ ;~(pfix tar sym))
    ;~(plug (stag ~ sym) ;~(pfix tis sym))
    (cook |=(a=term [`a a]) sym)
  ==
::
++  run-prelude
  |=  =pile
  ^-  [vase build-state:ub]
  =/  sut=vase  !>(..zuse)  :: TODO: cache?
  =^  sut=vase  build-state  (run-tauts sut %sur sur.pile)
  =^  sut=vase  build-state  (run-tauts sut %lib lib.pile)
  =^  sut=vase  build-state  (run-raw sut raw.pile)
  :: =^  sut=vase  build-state  (run-raz sut raz.pile)
  :: =^  sut=vase  build-state  (run-maz sut maz.pile)
  :: =^  sut=vase  build-state  (run-caz sut caz.pile)
  :: =^  sut=vase  build-state  (run-bar sut bar.pile)  :: TODO
  [sut build-state]
::
++  run-tauts
  |=  [sut=vase wer=?(%lib %sur) taz=(list taut)]
  ^-  [vase build-state:ub]
  ?~  taz  [sut build-state]
  =^  pin=vase  build-state  (build-fit wer pax.i.taz)
  =?  p.pin  ?=(^ face.i.taz)  [%face u.face.i.taz p.pin]
  $(sut (slop pin sut), taz t.taz)
::
++  run-raw
  |=  [sut=vase raw=(list [face=term =path])]
  ^-  [vase build-state:ub]
  ?~  raw  [sut build-state]
  =^  pin=vase  build-state  (build-file (snoc path.i.raw %hoon))
  =.  p.pin  [%face face.i.raw p.pin]
  $(sut (slop pin sut), raw t.raw)
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
::   |=  [sut=vase caz=(list [face=term =mars])]
::   ^-  [vase state]
::   ?~  caz  [sut build-state]
::   =^  pin=vase  build-state  (build-cast mars.i.caz)
::   =.  p.pin  [%face face.i.caz p.pin]
::   $(sut (slop pin sut), caz t.caz)
::
:: ++  run-bar  :: TODO
::   |=  [sut=vase bar=(list [face=term =mark =path])]
::   ^-  [vase build-state:ub]
::   ?~  bar  [sut build-state]
::   =^  =cage  build-state  (cast-path [path mark]:i.bar)
::   =.  p.q.cage  [%face face.i.bar p.q.cage]
::   $(sut (slop q.cage sut), bar t.bar)
::
::  +build-fit: build file at path, maybe converting '-'s to '/'s in path
::
++  build-fit
  |=  [pre=@tas pax=@tas]
  ^-  [vase build-state:ub]
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
  =/  paz  (segments pax)
  |-  ^-  path
  ?~  paz
    ~_(leaf/"clay: no files match /{(trip pre)}/{(trip pax)}/hoon" !!)
  =/  pux=path  pre^(snoc i.paz %hoon)
  ?:  (~(has in files) pux)
    pux
  $(paz t.paz)
::  +segments: compute all paths from :path-part, replacing some `/`s with `-`s
::
::    For example, when passed a :path-part of 'foo-bar-baz',
::    the product will contain:
::    ```
::    dojo> (segments 'foo-bar-baz')
::    ~[/foo-bar-baz /foo-bar/baz /foo/bar-baz /foo/bar/baz]
::    ```
::
++  segments
  |=  suffix=@tas
  ^-  (list path)
  =/  parser
    (most hep (cook crip ;~(plug ;~(pose low nud) (star ;~(pose low nud)))))
  =/  torn=(list @tas)  (fall (rush suffix parser) ~[suffix])
  %-  flop
  |-  ^-  (list (list @tas))
  ?<  ?=(~ torn)
  ?:  ?=([@ ~] torn)
    ~[torn]
  %-  zing
  %+  turn  $(torn t.torn)
  |=  s=(list @tas)
  ^-  (list (list @tas))
  ?>  ?=(^ s)
  ~[[i.torn s] [(crip "{(trip i.torn)}-{(trip i.s)}") t.s]]
--

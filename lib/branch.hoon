/-  *linedb
/+  ldb=linedb
::
|%
++  ba
  |_  =branch
  ::
  ::  write arms
  ::
  ++  add-commit
    |=  [author=ship time=@da =snap]
    ^+  branch
    =/  =ceta  [`@ux`(sham snap) head author time]
    %=  branch
      log      [ceta log.branch]
      commits  (~(put by commits.branch) hash.ceta [ceta snap])
    ==
  ::
  ++  squash
    |=  =hash
    ^+  branch
    =/  hed=commit  head-commit
    =.  branch  (reset hash)
    =.  parent.ceta.hed  head:(ba branch)
    (add-commit [author.ceta time.ceta snap]:hed)
  ::
  ++  merge
    |=  [author=@p time=@da bab=^branch]
    ^+  branch
    =/  bob  (ba bab)
    =*  ali  .
    ::  TODO ugly
    =/  bas=(unit hash)
        =/  ali-hashes  hashes
        =/  bob-hashes  (silt hashes:bob)
        |-
        ?~  ali-hashes  ~
        ?:  (~(has in bob-hashes) i.ali-hashes)
          `i.ali-hashes
        $(ali-hashes t.ali-hashes)
    ?~  bas  branch
    =*  base  u.bas
    =/  ali-diffs=(map path diff)
      (diff-snaps:di:ldb (get-snap:ali base) head-snap:ali)
    =/  bob-diffs=(map path diff)
      (diff-snaps:di:ldb (get-snap:bob base) head-snap:bob)
    =/  diffs=(map path diff)
      %-  ~(urn by (~(uni by ali-diffs) bob-diffs))
      |=  [=path *]
      ^-  diff
      %+  three-way-merge:di:ldb
        [%current (~(gut by ali-diffs) path *diff)]
      [%incoming (~(gut by bob-diffs) path *diff)]
    =/  new-snap=snap
      ?~  log.branch  *snap
      %-  ~(urn by snap:(~(got by commits.branch) head:ali))
      |=  [=path =file]
      =+  dif=(~(got by diffs) path)
      (apply-diff:di:ldb file dif)
    (add-commit author time new-snap)
  ::
  ++  reset
    |=  =hash
    ^+  branch
    ?.  (~(has by commits.branch) hash)  branch
    |-
    ?~  log.branch  branch  ::  should never happen
    ?:  =(hash.i.log.branch hash)  branch
    =.  commits.branch  (~(del by commits.branch) hash.i.log.branch)
    $(log.branch t.log.branch)
  ::
  ::  read arms
  ::
  ++  head            ?:(?=(^ log.branch) hash.i.log.branch *hash)
  ++  head-commit     (get-commit head)
  ++  head-snap       (get-snap head)
  ++  head-file       |=(p=path (get-file head p))
  ++  head-directory  |=(nedl=path (get-directory head nedl))
  ::
  ++  get-commit   |=(h=hash (~(gut by commits.branch) h *commit))
  ++  get-snap     |=(h=hash snap:(get-commit h))
  ++  get-file     |=([h=hash p=path] (of-wain:format (~(gut by (get-snap h)) p *wain)))
  ++  get-directory :: TODO this gets a lot more efficient with an +axal
    |=  [=hash nedl=path]
    ^-  (list [path file])
    %+  murn  ~(tap by (get-snap hash))
    |=  [hstk=path =file]
    ?.  =(`0 (find nedl hstk))  ~
    `[hstk file]
  ::
  ++  hashes  (turn log.branch |=(=ceta hash.ceta))
  ::
  ::  uqbuild engine
  ::
  ++  ub
    |_  =build-state :: [build-cache=(map @ux vase) cycle=(set seen-file)]
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
      ^-  [vase ^build-state]
      =/  sut=vase  !>(..zuse)  :: TODO: cache?
      =^  sut=vase  build-state  (run-tauts sut %sur sur.pile)  ::  /-
      =^  sut=vase  build-state  (run-tauts sut %lib lib.pile)  ::  /+
      =^  sut=vase  build-state  (run-tis sut raw.pile)         ::  /=
      =^  sut=vase  build-state  (run-tar sut bar.pile)         ::  /*
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
    ++  run-tis
      |=  [sut=vase raw=(list [face=term =path])]
      ^-  [vase ^build-state]
      ?~  raw  [sut build-state]
      =^  pin=(each vase @t)  build-state  (build-file (snoc path.i.raw %hoon))
      ?:  ?=(%| -.pin)  ~&  'build-failed'  $(raw t.raw)
      =.  p.p.pin  [%face face.i.raw p.p.pin]
      $(sut (slop p.pin sut), raw t.raw)
    ::
    ++  run-tar  :: TODO extremely ugly
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

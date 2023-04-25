/-  *linedb
::
=,  format
=,  differ
|%
++  noun-mark
    '''
    /?    310
    !:
    ::::  A minimal noun mark
    |_  non=*
    ++  grab  |%
              ++  noun  *
              --
    ++  grad
      |%
      ++  form  %noun
      ++  diff  |=(* +<)
      ++  pact  |=(* +<)
      ++  join  |=([* *] *(unit *))
      ++  mash  |=([[ship desk *] [ship desk *]] `*`~|(%noun-mash !!))
      --
    --
    '''
++  hoon-mark
  '''
  ::::  /hoon/hoon/mar
    ::
  /?    310
  ::
  =,  eyre
  |_  own=@t
  ::
  ++  grow                                                ::  convert to
    |%
    ++  mime  `^mime`[/text/x-hoon (as-octs:mimes:html own)] ::  convert to %mime
    ++  elem                                              ::  convert to %html
      ;div:pre(urb_codemirror "", mode "hoon"):"{(trip own)}"
      :: =+  gen-id="src-{<`@ui`(mug own)>}"
      :: ;div
      ::   ;textarea(id "{gen-id}"):"{(trip own)}"
      ::   ;script:"""
      ::           CodeMirror.fromTextArea(
      ::             window[{<gen-id>}],
      ::             \{lineNumbers:true, readOnly:true}
      ::           )
      ::           """
      :: ==
    ++  hymn
      :: ;html:(head:title:"Source" "+{elem}")
      ;html
        ;head
          ;title:"Source"
          ;script@"//cdnjs.cloudflare.com/ajax/libs/codemirror/4.3.0/codemirror.js";
          ;script@"/lib/syntax/hoon.js";
          ;link(rel "stylesheet", href "//cdnjs.cloudflare.com/ajax/libs/".
            "codemirror/4.3.0/codemirror.min.css");
          ;link/"/lib/syntax/codemirror.css"(rel "stylesheet");
        ==
        ;body
          ;textarea#src:"{(trip own)}"
          ;script:'CodeMirror.fromTextArea(src, {lineNumbers:true, readOnly:true})'
        ==
      ==
    ++  txt
      (to-wain:format own)
    --
  ++  grab
    |%                                            ::  convert from
    ++  mime  |=([p=mite q=octs] q.q)
    ++  noun  @t                                  ::  clam from %noun
    ++  txt   of-wain:format
    --
  ++  grad  %txt
  --
  '''
++  kelvin-mark
  '''
  |_  kal=waft:clay
  ++  grow
    |%
    ++  mime  `^mime`[/text/x-kelvin (as-octs:mimes:html hoon)]
    ++  noun  kal
    ++  hoon
      %+  rap  3
      %+  turn
        %+  sort
          ~(tap in (waft-to-wefts:clay kal))
        |=  [a=weft b=weft]
        ?:  =(lal.a lal.b)
          (gte num.a num.b)
        (gte lal.a lal.b)
      |=  =weft
      (rap 3 '[%' (scot %tas lal.weft) ' ' (scot %ud num.weft) ']\0a' ~)
    ::
    ++  txt   (to-wain:format hoon)
    --
  ++  grab
    |%
    ++  noun  waft:clay
    ++  mime
      |=  [=mite len=@ud tex=@]
      (cord-to-waft:clay tex)
    --
  ++  grad  %noun
  --
  '''
++  bill-mark
  '''
  |_  bil=(list dude:gall)
  ++  grow
    |%
    ++  mime  `^mime`[/text/x-bill (as-octs:mimes:html hoon)]
    ++  noun  bil
    ++  hoon
      ^-  @t
      |^  (crip (of-wall:format (wrap-lines (spit-duz bil))))
      ::
      ++  wrap-lines
        |=  taz=wall
        ^-  wall
        ?~  taz  ["~"]~
        :-  (weld ":~  " i.taz)
        %-  snoc  :_  "=="
        (turn t.taz |=(t=tape (weld "    " t)))
      ::
      ++  spit-duz
        |=  duz=(list dude:gall)
        ^-  wall
        (turn duz |=(=dude:gall ['%' (trip dude)]))
      --
    ++  txt   (to-wain:format hoon)
    --
  ++  grab
    |%
    ++  noun  (list dude:gall)
    ++  mime
      |=  [=mite len=@ud tex=@]
      ~_  tex
      !<((list dude:gall) (slap !>(~) (ream tex)))
    --
  ++  grad  %noun
  --
  '''
++  vase-mark
  '''
  /?    310
  !:
  |_  v=vase
  ++  grab  |%
            ++  noun  |=(n=* !<(vase [-:!>(*vase) n]))
            --
  ++  grow  |%
            ++  noun  v
            --
  ++  grad  %noun
  --
  '''
++  boilerplate-files
  ^-  (list [path %& page])
  :~  [/sys/kelvin %& %kelvin zuse+zuse]
      [/mar/noun/hoon %& %hoon noun-mark]
      [/mar/hoon/hoon %& %hoon hoon-mark]
      [/mar/kelvin/hoon %& %hoon kelvin-mark]
      [/mar/bill/hoon %& %hoon bill-mark]
      [/mar/vase/hoon %& %hoon vase-mark]
  ==
++  gen-app
  |=  p=path
  ^-  @t
  %-  crip
  """
  /*  built  %vase  {<`path`p>}
  !<(agent:gall built)
  """
::
::  diff operations
::
++  di
  |%
  ++  diff-files  |=([old=file new=file] (lusk old new (loss old new)))
  ++  apply-diff  |=([=file =diff] (lurk file diff))
  ::
  ++  line-mapping
    ::  TODO we need a more advanced diff algo if we want individual lines edited...diff could be an (urge tape)
    |=  =diff
    ^-  (map line line)
    =|  iold=@ud
    =|  inew=@ud
    =|  new-lines=(list (pair line line))
    |-
    ?~  diff  (~(gas by *(map line line)) new-lines)
    ?-    -.i.diff
        %&
      %=    $
          iold  (add iold p.i.diff)
          inew  (add inew p.i.diff)
          diff  t.diff
          new-lines
        |-
        ?:  =(0 p.i.diff)  new-lines
        %=  $
          new-lines  [[+(iold) +(inew)] new-lines]
          p.i.diff   (dec p.i.diff)
          iold       +(iold)
          inew       +(inew)
        ==
      ==
    ::
        %|
      %=  $
        iold  (add iold (lent p.i.diff))
        inew  (add inew (lent q.i.diff))
        diff  t.diff
      ==
    ==
  ::
  ++  diff-snaps                                       ::  from two snaps
    |=  [old=snap new=snap]
    ^-  (map path diff)
    %-  ~(urn by (~(uni by old) new))
    |=  [=path *]
    %+  diff-files
      (~(gut by old) path *file)
    (~(gut by new) path *file)
  ::
  ++  three-way-merge                                  ::  +mash in mar/txt/hoon
    |=  $:  [ald=@tas ali=diff]
            [bod=@tas bob=diff]
        ==
    ^-  diff
    |^
    =.  ali  (clean ali)
    =.  bob  (clean bob)
    |-  ^-  diff
    ?~  ali  bob
    ?~  bob  ali
    ?-    -.i.ali
        %&
      ?-    -.i.bob
          %&
        ?:  =(p.i.ali p.i.bob)
          [i.ali $(ali t.ali, bob t.bob)]
        ?:  (gth p.i.ali p.i.bob)
          [i.bob $(p.i.ali (sub p.i.ali p.i.bob), bob t.bob)]
        [i.ali $(ali t.ali, p.i.bob (sub p.i.bob p.i.ali))]
      ::
          %|
        ?:  =(p.i.ali (lent p.i.bob))
          [i.bob $(ali t.ali, bob t.bob)]
        ?:  (gth p.i.ali (lent p.i.bob))
          [i.bob $(p.i.ali (sub p.i.ali (lent p.i.bob)), bob t.bob)]
        =/  [fic=(unce:clay cord) ali=diff bob=diff]
            (resolve ali bob)
        [fic $(ali ali, bob bob)]
        ::  ~   ::  here, alice is good for a while, but not for the whole
      ==    ::  length of bob's changes
    ::
        %|
      ?-  -.i.bob
          %|
        =/  [fic=(unce:clay cord) ali=diff bob=diff]
            (resolve ali bob)
        [fic $(ali ali, bob bob)]
      ::
          %&
        ?:  =(p.i.bob (lent p.i.ali))
          [i.ali $(ali t.ali, bob t.bob)]
        ?:  (gth p.i.bob (lent p.i.ali))
          [i.ali $(ali t.ali, p.i.bob (sub p.i.bob (lent p.i.ali)))]
        =/  [fic=(unce:clay cord) ali=diff bob=diff]
            (resolve ali bob)
        [fic $(ali ali, bob bob)]
      ==
    ==
    ::
    ++  annotate                                        ::  annotate conflict
      |=  $:  ali=(list @t)
              bob=(list @t)
              bas=(list @t)
          ==
      ^-  (list @t)
      %-  zing
      ^-  (list (list @t))
      %-  flop
      ^-  (list (list @t))
      :-  :_  ~
          %^  cat  3  '<<<<<<<<<<<<'
          %^  cat  3  ' '
          %^  cat  3  '/'
          bod

      :-  bob
      :-  ~['------------']
      :-  bas
      :-  ~['++++++++++++']
      :-  ali
      :-  :_  ~
          %^  cat  3  '>>>>>>>>>>>>'
          %^  cat  3  ' '
          %^  cat  3  '/'
          ald
      ~
    ::
    ++  clean                                          ::  clean
      |=  wig=diff
      ^-  diff
      ?~  wig  ~
      ?~  t.wig  wig
      ?:  ?=(%& -.i.wig)
        ?:  ?=(%& -.i.t.wig)
          $(wig [[%& (add p.i.wig p.i.t.wig)] t.t.wig])
        [i.wig $(wig t.wig)]
      ?:  ?=(%| -.i.t.wig)
        $(wig [[%| (welp p.i.wig p.i.t.wig) (welp q.i.wig q.i.t.wig)] t.t.wig])
      [i.wig $(wig t.wig)]
    ::
    ++  resolve
      |=  [ali=diff bob=diff]
      ^-  [fic=[%| p=(list cord) q=(list cord)] ali=diff bob=diff]
      =-  [[%| bac (annotate alc boc bac)] ali bob]
      |-  ^-  $:  $:  bac=(list cord)
                      alc=(list cord)
                      boc=(list cord)
                  ==
                  ali=diff
                  bob=diff
              ==
      ?~  ali  [[~ ~ ~] ali bob]
      ?~  bob  [[~ ~ ~] ali bob]
      ?-    -.i.ali
          %&
        ?-    -.i.bob
            %&  [[~ ~ ~] ali bob]                       ::  no conflict
            %|
          =+  lob=(lent p.i.bob)
          ?:  =(lob p.i.ali)
            [[p.i.bob p.i.bob q.i.bob] t.ali t.bob]
          ?:  (lth lob p.i.ali)
            [[p.i.bob p.i.bob q.i.bob] [[%& (sub p.i.ali lob)] t.ali] t.bob]
          =+  wat=(scag (sub lob p.i.ali) p.i.bob)
          =+  ^=  res
              %=  $
                ali  t.ali
                bob  [[%| (scag (sub lob p.i.ali) p.i.bob) ~] t.bob]
              ==
          :*  :*  (welp bac.res wat)
                  (welp alc.res wat)
                  (welp boc.res q.i.bob)
              ==
              ali.res
              bob.res
          ==
        ==
      ::
          %|
        ?-    -.i.bob
            %&
          =+  loa=(lent p.i.ali)
          ?:  =(loa p.i.bob)
            [[p.i.ali q.i.ali p.i.ali] t.ali t.bob]
          ?:  (lth loa p.i.bob)
            [[p.i.ali q.i.ali p.i.ali] t.ali [[%& (sub p.i.bob loa)] t.bob]]
          =+  wat=(slag (sub loa p.i.bob) p.i.ali)
          =+  ^=  res
              %=  $
                ali  [[%| (scag (sub loa p.i.bob) p.i.ali) ~] t.ali]
                bob  t.bob
              ==
          :*  :*  (welp bac.res wat)
                  (welp alc.res q.i.ali)
                  (welp boc.res wat)
              ==
              ali.res
              bob.res
          ==
        ::
            %|
          =+  loa=(lent p.i.ali)
          =+  lob=(lent p.i.bob)
          ?:  =(loa lob)
            [[p.i.ali q.i.ali q.i.bob] t.ali t.bob]
          =+  ^=  res
              ?:  (gth loa lob)
                $(ali [[%| (scag (sub loa lob) p.i.ali) ~] t.ali], bob t.bob)
              ~&  [%scagging loa=loa pibob=p.i.bob slag=(scag loa p.i.bob)]
              $(ali t.ali, bob [[%| (scag (sub lob loa) p.i.bob) ~] t.bob])
          :*  :*  (welp bac.res ?:((gth loa lob) p.i.bob p.i.ali))
                  (welp alc.res q.i.ali)
                  (welp boc.res q.i.bob)
              ==
              ali.res
              bob.res
          ==
        ==
      ==
    --
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  action
    ^-  $-(json ^action)
    %-  of
    :~  [%commit commit]
        [%delete delete]
        [%reset reset]
        [%merge merge]
        [%branch branch]
        [%fetch fetch]
    ==
  ::
  ++  commit
    ^-  $-(json [@tas @tas (map path wain)])
    %-  ot
    :^    [%repo (se %tas)]
        [%branch (se %tas)]
      [%snap snap]
    ~
  ::
  ++  delete
    ^-  $-(json [@tas @tas])
    %-  ot
    :+  [%repo (se %tas)]
      [%branch (se %tas)]
    ~
  ::
  ++  reset
    ^-  $-(json [@tas @tas @ux])
    %-  ot
    :^    [%repo (se %tas)]
        [%branch (se %tas)]
      [%hash (se %ux)]
    ~
  ::
  ++  merge
    ^-  $-(json [@p @tas @tas @tas])
    %-  ot
    :-  [%from (se %p)]
    :^    [%repo (se %tas)]
        [%branch (se %tas)]
      [%incoming (se %tas)]
    ~
  ::
  ++  branch
    ^-  $-(json [@p @tas @tas @tas])
    %-  ot
    :-  [%from (se %p)]
    :^    [%repo (se %tas)]
        [%branch (se %tas)]
      [%name (se %tas)]
    ~
  ::
  ++  fetch
    ^-  $-(json [@p @tas @tas])
    %-  ot
    :^    [%from (se %p)]
        [%repo (se %tas)]
      [%branch (se %tas)]
    ~
  ::
  ++  snap
    |=  jon=json
    ^-  (map path wain)
    ?>  ?=([%o *] jon)
    %-  ~(gas by *(map path wain))
    %+  turn  ~(tap by p.jon)
    |=  [a=@t b=json]
    =>  .(+< [a b]=+<)
    :-  (rash a stap)
    ?+  b  !!
      [%a *]  ((ar so) b)
      [%s @]  ~[+:(need (de:base64:mimes:html +.b))]
    ==
  --
--

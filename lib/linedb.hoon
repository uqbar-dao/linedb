/-  *linedb
::
=,  format
=,  differ
|%
++  vase-mark
  '''
  /?    310
  !:
  |_  v=vase
  ++  grab  |%
            ++  noun  |=(n=* !<(vase [-:!>(*vase) n]))
            ++  mime  |=(a=@ !<(vase [-:!>(*vase) (cue a)]))
            --
  ++  grow  |%
            ++  noun  v
            ++  mime  [/application/x-urb-vase (as-octs:mimes:html (jam v))]
            --
  ++  grad  %noun
  --
  '''
::
::  diff operations
::
++  di
  |%
  ++  diff-files  |=([old=file new=file] (lusk old new (loss old new)))
  ++  apply-diff  |=([=file =diff] (lurk file diff))
  ++  apply-diffs
    |=  [=snap diffs=(map path diff)]
    ^-  ^snap
    %-  ~(gas by snap)
    %+  turn  ~(tap by diffs)
    |=  [=path =diff]
    :-  path
    %+  apply-diff
      (~(gut by snap) path *wain)
    diff
  ::
  ++  print-diff
    |=  diffs=(urge:clay @t)
    ^-  wain
    =|  result=wain
    =/  old-line-number=@ud  1  ::  file line number starts at 1
    =/  new-line-number=@ud  1
    |-
    ?~  diffs  (flop result)
    =/  maybe-diff=(each @ud (pair wain wain))  i.diffs
    ?:  ?=(%& -.maybe-diff)
      %=  $
        diffs            t.diffs
        old-line-number  (add old-line-number p.maybe-diff)
        new-line-number  (add new-line-number p.maybe-diff)
      ==
    %=  $
        diffs  t.diffs
    ::
        old-line-number
      ?~(p.p.maybe-diff old-line-number +(old-line-number))
    ::
        new-line-number
      ?~(q.p.maybe-diff new-line-number +(new-line-number))
    ::
        result
      %-  weld  :_  result
      =*  lines
        [(crip "{<old-line-number>}, {<new-line-number>}") ~]
      ?~  p.p.maybe-diff
        ?~  q.p.maybe-diff  ['' lines]
        [(cat 3 '+  ' -.q.p.maybe-diff) lines]
      ?~  q.p.maybe-diff
        [(cat 3 '-  ' -.p.p.maybe-diff) lines]
      :+  (cat 3 '-  ' -.p.p.maybe-diff)
        (cat 3 '+  ' -.q.p.maybe-diff)
      lines
    ==
  ::
  ++  line-mapping
    |=  =diff
    ^-  (map @ud @ud)
    =|  io=@ud  ::  old
    =|  in=@ud  ::  new
    =|  new-lines=(list (pair @ud @ud))
    |-
    ?~  diff  (~(gas by *(map @ud @ud)) new-lines)
    ?-    -.i.diff
        %&
      %=    $
          io  (add io p.i.diff)
          in  (add in p.i.diff)
          diff  t.diff
          new-lines
        |-
        ?:  =(0 p.i.diff)  new-lines
        %=  $
          new-lines  [[+(io) +(in)] new-lines]
          p.i.diff   (dec p.i.diff)
          io       +(io)
          in       +(in)
        ==
      ==
    ::
        %|
      %=  $
        io  (add io (lent p.i.diff))
        in  (add in (lent q.i.diff))
        diff  t.diff
      ==
    ==
  ::
  ++  diff-snaps                                       ::  from two snaps
    |=  [old=snap new=snap]
    ^-  (map path diff)
    %-  ~(gas by *(map path diff))
    %+  murn  ~(tap by (~(uni by old) new))
    |=  [=path *]
    =;  =diff
      ::  NOTE: if no changes, don't send the diff
      ?:  ?&  =(1 (lent diff))
              ?=(^ diff)
              =(%& -.i.diff)
          ==
      ~  `[path diff]
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
++  enjs
  =,  enjs:format
  |%
  ++  all-repos
    |=  repos=(list [@p ^path])
    ^-  json
    :-  %a
    %+  turn  repos
    |=  [repo-host=@p p=^path]
    ?>  ?=([@ @ ~] p)
    %-  pairs
    :^    [%repo-host %s (scot %p repo-host)]
        [%repo-name %s i.p]
      [%branch-name %s i.t.p]
    ~
  ::
  ++  log
    |=  log=(list meta)
    ^-  json
    :-  %a
    %+  turn  log
    |=  [commit-hash=@ux parent=@ux author=@p time=@da]
    %-  pairs
    :~  [%commit-hash %s (scot %ux commit-hash)]
        [%parent %s (scot %ux parent)]
        [%author %s (scot %p author)]
        [%time (sect time)]
    ==
  ::
  ++  cache-size
    |=  cache-size=(map @da [@ud @ud])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by cache-size)
    |=  [day=@da number-cache-entries=@ud total-size=@ud]
    :-  (@t +:(sect day))
    %-  pairs
    :+  [%number-cache-entries (numb number-cache-entries)]
      [%total-size (numb total-size)]
    ~
  ::
  ++  list-branches
    |=  pafs=(list ^path)
    ^-  json
    :-  %a
    %+  turn  pafs
    |=  =^path  s+(spat path)
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
        [%fork fork]
        [%clear-cache (ot [%before (se %da)]~)]
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
    ^-  $-(json [@tas @tas @p @tas])
    %-  ot
    :~  [%repo (se %tas)]
        [%branch (se %tas)]
        [%host (se %p)]
        [%incoming (se %tas)]
    ==
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
  ++  fork
    ^-  $-(json [@tas @tas @tas])
    %-  ot
    :^    [%repo (se %tas)]
        [%branch (se %tas)]
      [%new-repo (se %tas)]
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

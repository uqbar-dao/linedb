/-  *screed, *linedb
/+  dbug, default-agent, ldb=linedb, *mip, screed-lib=screed, verb
::
%-  agent:dbug
%+  verb  &
^-  agent:gall
=>  |%
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          repos=(map @tas repo)
      ==
    +$  card  card:agent:gall
    --
=|  state-0
=*  state  -
=<  |_  =bowl:gall
    +*  this  .
        hc    ~(. +> bowl)
        def   ~(. (default-agent this %|) bowl)
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
        ?+  mark  (on-poke:def mark vase)
          %linedb-action  (handle-action:hc !<(action vase))
        ==
      [cards this]
    ::
    ++  on-agent  on-agent:def
    ++  on-watch  on-watch:def
    ++  on-peek   handle-scry:hc
    ++  on-arvo   on-arvo:def
    ++  on-leave  on-leave:def
    ++  on-fail   on-fail:def
    --
::
|_  bowl=bowl:gall
++  handle-action
  |=  act=action
  ^-  (quip card _state)
  ?-    -.act
      %new-repo
    =.  repos
      %+  ~(put by repos)  name.act
      :-  [our.bowl %master]
      (~(put by *(map @tas branch)) %master *branch)
    `state
  ::
      %commit
    =.  repos
      %+  ~(jab by repos)  repo.act
      |=  =repo
      (~(commit-active r:ldb repo) our.bowl now.bowl snap.act)
    `state
  ::
      %branch
    =.  repos
      %+  ~(jab by repos)  repo.act
      |=(=repo (~(new-branch r:ldb repo) name.act))
    `state
  ::
      %checkout
    =.  repos
      %+  ~(jab by repos)  repo.act
      |=(=repo (~(checkout r:ldb repo) branch.act))
    `state    
  ::
      %merge
    =.  repos
      %+  ~(jab by repos)  repo.act
      |=(=repo (~(merge r:ldb repo) branch.act))
    `state
  ==
::
++  handle-scry
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  `~
      [%x %repos ~]  ``noun+!>((turn ~(tap by repos) head))
      [%x %branch @ ~]
    ``noun+!>(~(branches r:ldb (~(got by repos) i.t.t.path)))
  ==
--

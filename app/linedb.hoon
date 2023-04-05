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
          %linedb-fetch   (handle-fetch:hc !<(fetch vase))
        ==
      [cards this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card _this)
      ~&  >  wire
      ~&  >  -.sign
      ?+    wire  (on-agent:def wire sign)
          [%fetch %ask ~]
        ?+    -.sign  (on-agent:def wire sign)
            %fact
          ~&  >  p.cage.sign
          `this
        ==
      ::
          [%fetch %req ~]
        ?+    -.sign  (on-agent:def wire sign)
            %fact
          ~&  >  p.cage.sign
          `this
        ==
      ==
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
      %delete-branch
    =.  repos
      %+  ~(jab by repos)  repo.act
      |=(=repo (~(delete-branch r:ldb repo) name.act))
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
  ::
      %reset
    =.  repos
      %+  ~(jab by repos)  repo.act
      |=(=repo (~(reset-branch r:ldb repo) [branch hash]:act))
    `state
  ==
::
++  handle-fetch
  |=  =fetch
  ^-  (quip card _state)
  ?-    -.fetch
      %ask
    :_  state
    =+  !>([%request repo.fetch])
    [%pass /fetch/ask %agent [who.fetch dap.bowl] %poke %linedb-fetch -]~
  ::
      %request
    =-  [%pass /fetch/req %agent [src dap]:bowl %poke %linedb-fetch -]~^state
    ?~  got=(~(get by repos) repo.fetch)  !>(~)
    !>([%response repo.fetch u.got])
  ::
      %response
    :: TODO partial checkout - just grab one branch
    `state(repos (~(put by repos) [name repo]:fetch))
  ==
::
++  handle-scry
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  `~
      [%x %repos ~]  ``noun+!>((turn ~(tap by repos) head))
      [%x %branches @ ~]
    ``noun+!>(~(branches r:ldb (~(got by repos) i.t.t.path)))
  ::
      [%x %active-branch @ ~]
    ``noun+!>(active-branch.p:(~(got by repos) i.t.t.path))
  ==
--

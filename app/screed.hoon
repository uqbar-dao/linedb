/-  *screed, *linedb
/+  dbug, default-agent, linedb, *mip, screed-lib=screed, verb
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
          post-metadata=(map path metadata)
          history=_branch:linedb
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
          %screed-action        (handle-action:hc !<(act=action vase))
        ==
      [cards this]
    ::
    ++  on-agent  on-agent:def
    ++  on-watch  on-watch:def
    ++  on-peek  handle-scry:hc
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
      %save-file
    =.  history.state
      %^  add-commit:history  src.bowl  now.bowl
      (~(put by latest-snap:history) path.act (cord-to-file md.act))
    =.  post-metadata
      (~(put by post-metadata) path.act [title.act now.bowl ~])
    :: if we have comments, adjust their lines 
    =/  line-map  (line-mapping:linedb (latest-diff:history path.act))
    =.  post-metadata
      %+  ~(jab by post-metadata)  path.act
      |=  [title=@t date=@da comments=(map @da comment)]
      :+  title  date
      %-  ~(gas by *(map @da comment))
      ^-  (list [@da comment])
      %+  murn  ~(tap by comments:(~(got by post-metadata) path.act))
      |=  [key=@da val=comment]
      ^-  (unit [_key _val])
      =+  lin=(~(get by line-map) line.val)
      ?~(lin ~ `[key val(line u.lin)])
    `state
  ::
      %add-comment
    =.  post-metadata
      %+  ~(jab by post-metadata)  path.act
      |=  [title=@t date=@da comments=(map @da comment)]
      :+  title  date
      %+  ~(put by comments)  now.bowl
      [line.act src.bowl content.act] 
    `state
  ::
      %delete-comment
    =.  post-metadata
      %+  ~(jab by post-metadata)  path.act
      |=  [title=@t date=@da comments=(map @da comment)]
      :+  title  date
      (~(del by comments) id.act)
    `state
  ::
  ==
++  handle-scry
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  ~
      [%x %post ^]
    =-  ``screed-update+!>(post+-)
    =+  meta=(~(gut by post-metadata) t.t.path *metadata)
    :^    path
        title.meta
      published.meta
    (latest-file:history t.t.path)
  ::
      [%x %posts ~]
    =-  ``screed-update+!>(posts+-)
    %+  turn  ~(tap by post-metadata)
    |=([=^path =metadata] [path [title published]:metadata])
  ::
      [%x %comments ^]
    =-  ``screed-update+!>(comments+-)
    ~(tap by comments:(~(gut by post-metadata) t.t.path *metadata))
  ==
--

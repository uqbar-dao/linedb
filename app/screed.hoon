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
          %handle-http-request  (http-req:hc !<([@tas inbound-request:eyre] vase))
          %screed-action        (handle-action:hc !<(act=action vase))
        ==
      [cards this]
    ::
    ++  on-agent  on-agent:def
    ++  on-watch
      |=  =path
      ^-  (quip card _this)
      ?>  ?=([%http-response *] path)
      `this
    ::
    ++  on-peek  handle-scry:hc
    ::
    ++  on-arvo
      |=  [=wire =sign-arvo]
      ^-  (quip card _this)
      ?+  wire  (on-arvo:def wire sign-arvo)
        [%bind ~]  ?>(?=([%eyre %bound %.y *] sign-arvo) `this)
      ==
    ++  on-leave  on-leave:def
    ++  on-fail   on-fail:def
    --
::
|_  bowl=bowl:gall
++  http-req
  |=  [rid=@tas req=inbound-request:eyre]
  ^-  (quip card _state)
  :_  state
  %^    http-response-cards:screed-lib
      rid
    [200 ['Content-Type' 'text/plain; charset=utf-8']~]
  =-  `(as-octs:mimes:html -)
  (latest-file:history (rash url.request.req stap))
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
      [%x %head ~]   ``noun+!>(head:history)
  ::
      [%x %comments ^]
    =-  ``noun+!>(-)
    ~(tap by comments:(~(gut by post-metadata) t.t.path *metadata))
  ::
      [%x %posts ~]
    =-  ``noun+!>(-)
    %+  turn  ~(tap by post-metadata)
    |=([=^path =metadata] [path [title published]:metadata])
  ::
      [%x %post ^]
    :: TODO also get the markdown
    =-  ``noun+!>(-)
    =+  meta=(~(gut by post-metadata) t.t.path *metadata)
    :^    path
        title.meta
      published.meta
    (latest-file:history t.t.path)
  ==
--

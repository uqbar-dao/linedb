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
          local=_branch:linedb
          remotes=(map ship _branch:linedb)
          local-metadata=(map path metadata)
          remote-metadata=(mip ship path metadata)
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
        ?+    mark  (on-poke:def mark vase)
            %handle-http-request
          (http-req:hc !<([@tas inbound-request:eyre] vase))
            %screed-action
          (handle-action:hc !<(action vase))
        ==
      [cards this]
    ::
    ++  on-agent  on-agent:def
    ++  on-watch  |=(=path ?>(?=([%http-response *] path) `this))
    ++  on-peek   handle-scry:hc
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
  =+  url=(rash url.request.req stap)
  :_  state
  %^    http-response-cards:screed-lib
      rid
    [200 ['Content-Type' 'text/plain; charset=utf-8']~]
  `(as-octs:mimes:html (latest-file:local url))
::
++  handle-action
  |=  act=action
  ^-  (quip card _state)
  ?-    -.act
      %save-file
    =.  local.state
      %^  add-commit:local  src.bowl  now.bowl
      (~(put by latest-snap:local) path.act (cord-to-file md.act))
    =.  local-metadata
      %+  ~(put by local-metadata)  path.act
      [src.bowl title.act now.bowl ~ %none ~]
    :: if we have comments, adjust their lines 
    =/  line-map  (line-mapping:linedb (latest-diff:local path.act))
    =.  local-metadata
      %+  ~(jab by local-metadata)  path.act
      |=  =metadata
      %=    metadata
          comments
        %-  ~(gas by *(map @da comment))
        ^-  (list [@da comment])
        %+  murn  ~(tap by comments:(~(got by local-metadata) path.act))
        |=  [key=@da val=comment]
        ^-  (unit [_key _val])
        =+  lin=(~(get by line-map) line.val)
        ?~(lin ~ `[key val(line u.lin)])
      ==
    :_  state
    [%pass /bind %arvo %e %connect `path.act dap.bowl]~
  ::
      %add-comment
    =.  local-metadata
      %+  ~(jab by local-metadata)  path.act
      |=  m=metadata
      %=    m
          comments
        (~(put by comments.m) now.bowl [line.act src.bowl content.act])
      ==
    `state
  ::
      %delete-comment
    =.  local-metadata
      %+  ~(jab by local-metadata)  path.act
      |=  m=metadata
      m(comments (~(del by comments.m) id.act))
    `state
  ::
      %request-post
    :_  state
    :_  ~
    :^  %pass  /  %agent
    :^  [src dap]:bowl  %poke  %screed-action
    !>  :-  %respond-post
    :+  path.act  (~(gut by local-metadata) path.act *metadata)
    (latest-file:local path.act)
  ::
      %respond-post
    =/  remote  (~(gut by remotes) src.bowl *_branch:linedb)
    =.  remote
      %^    add-commit:remote
          src.bowl
        now.bowl
    (~(put by latest-snap:local) path.act (cord-to-file file.act))
    =.  remotes
      (~(put by remotes) src.bowl remote)
    `state
  ==
++  handle-scry
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  ~
      [%x %post ^]
    =-  ``screed-update+!>(post+-)
    =+  meta=(~(gut by local-metadata) t.t.path *metadata)
    :^    path
        title.meta
      published.meta
    (latest-file:local t.t.path)
  ::
      [%x %posts ~]
    =-  ``screed-update+!>(posts+-)
    %+  turn  ~(tap by local-metadata)
    |=([=^path =metadata] [path our.bowl [title published]:metadata])
  ::
      [%x %remote-posts ~]
    =-  ``noun+!>(posts+-)
    %+  turn  ~(tap bi remote-metadata)
    |=  [=ship =^path =metadata]
    [path ship [title published]:metadata]
  ::
      [%x %comments ^]
    =-  ``screed-update+!>(comments+-)
    ~(tap by comments:(~(gut by local-metadata) t.t.path *metadata))
  ==
--

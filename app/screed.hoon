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
          published=(map path =post)
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
  ::
      %publish
    ?>  =(src our):bowl
    :_  state(published (~(put by published) [path html]:act))
    [%pass /bind %arvo %e %connect `path.act dap.bowl]~
  ::
      %commit-file
    ?>  =(src our):bowl :: TODO group blogs
    =.  history.state :: maybe build this into ldb?
      =/  old=snapshot
        ?:  =(0 head.history)
          *(map path file)
        latest-snap:history
      =/  new=snapshot  (~(put by old) [path md]:act)
      (commit:history.state src.bowl new)
    ::  if there are no comments, return
    ?~  got=(~(get by comments) path.act)  `state
    ::  if we have comments, adjust their lines
    =/  =diff     (latest-diff:history path.act)
    =/  line-map  (line-mapping:linedb diff)
    =.  comments
      %+  ~(put by comments)  path.act
      %+  gas:comment-on  *((mop line comment) lth)
      ^-  (list [line comment])
      %+  murn  (tap:comment-on u.got)
      |=  [key=line val=comment]
      ^-  (unit [_key _val])
      =+  got=(~(get by line-map) key)
      ?~(got ~ `[u.got val])
    `state
  ::
      %comment
    ::  TODO verify signature
    =:  author.comment.act     src.bowl
        timestamp.comment.act  now.bowl
      ==
    =/  comment-set  (~(got by comments) path.act)
    =.  comment-set  (put:comment-on comment-set [line comment]:act)
    =.  comments     (~(put by comments) path.act comment-set)
    `state
  ::
      %change-permissions
    `state
    :: `state(permissions (~(put bi permissions) [path ship permission]:act))
  ==
++  handle-scry
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  ~
  ::
      [%x %head ~]   ``noun+!>(head:history)
      [%x %files ~]
    ``noun+!>((turn ~(tap by latest-snap:history) head))
  ::
      [%x %latest ^]  ``noun+!>((latest-file:history t.t.path))
  ::
      [%x %i @ ^]
    =*  index      (slav %ud i.t.t.path)
    =*  path  t.t.t.path
    ``noun+!>((get-file:history path index))
  ::
      [%x %history ~]  ``noun+!>(history) :: for testing only
  ::
      [%x %comments ^]
    =*  path  t.t.path
    ``noun+!>((tap:comment-on comments:(~(gut by posts) path *post))) :: TODO better
  ==
--

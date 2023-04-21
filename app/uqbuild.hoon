/-  ub=uqbuild
/+  agentio,
    dbug,
    default-agent,
    verb,
    uqbuild
::
|%
+$  card  card:agent:gall
--
::
=|  state-0:ub
=*  state  -
::
%-  agent:dbug
%+  verb  &
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def      ~(. (default-agent this %|) bowl)
    io       ~(. agentio bowl)
    ub-lib   ~(. uqbuild bowl *repo-info:ub build-cache ~)
::
++  on-init  `this
::
++  on-save  !>(state)
::
++  on-load
  |=  =old=vase
  `this(state !<(state-0:ub old-vase))
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
++  on-watch  |=  p=path  (on-watch:def p)
++  on-agent  |=  [w=wire =sign:agent:gall]  (on-agent:def w sign)
++  on-arvo  |=  [w=wire =sign-arvo:agent:gall]  (on-arvo:def w sign-arvo)
::
++  on-peek
  |=  p=path
  ^-  (unit (unit cage))
  ?+    p  (on-peek:def p)
      [%x %build-result @ ~]
    =*  file-hash=@ux  (slav %ux i.t.t.p)
    :^  ~  ~  %uqbuild-update
    !>  ^-  update:ub
    :-  %build
    ?^  build=(~(get by build-cache) file-hash)  [%& u.build]
    [%| (crip "build not found for file-hash {<file-hash>}")]
  ==
::
++  on-poke
  |=  [m=mark v=vase]
  ^-  (quip card _this)
  |^
  ::  TODO handle app project pokes in their own arm
  =^  cards  state
    ?+  m  (on-poke:def m v)
      %uqbuild-action  (handle-action !<(action:ub v))
    ==
  [cards this]
  ::
  ++  handle-action
    |=  act=action:ub
    ^-  (quip card _state)
    ?>  =(our.bowl src.bowl)
    ?-    -.act
        %build
      =*  ubl
        ~(. uqbuild bowl [repo-host repo-name branch-name commit-hash]:act build-cache ~)
      :: =*  ubl
      ::   %=  ub-lib
      ::       repo-host    repo-host.act
      ::       repo-name    repo-name.act
      ::       branch-name  branch-name.act
      ::       commit-hash  commit-hash.act
      ::   ==
      =/  [built-file=vase =build-state:ub]
        (build-file:ubl file-path.act)
      :_  state(build-cache build-cache.build-state)
      ?~  our-app.act  ~
      :_  ~
      %+  ~(poke-our pass:io /pokeback/[u.our-app.act])
        u.our-app.act
      :-  %uqbuild-update
      !>([%build %& built-file])
    ==
  --
--

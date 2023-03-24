/-  *linedb
::
|%
++  branch
  =|  [snaps=((mop index commit) lth) head=index]
  |%
  ++  add-commit
    |=  [author=ship new-snap=snapshot]
    ^+  branch
    =*  commit
      :+  author
        new-snap
      ?:  =(0 head)  (build-diff ~ new-snap)
      (build-diff snapshot:(got:snap-on snaps head) new-snap)
    %=  +>.$
      head   +(head)
      snaps  (put:snap-on snaps +(head) commit)
    ==
  ::
  ++  set-head
    |=  new-head=@ud
    ^+  branch
    ?>  (has:snap-on snaps new-head)
    +>.$(head new-head)
  ::
  ++  build-diff
    |=  [old=snapshot new=snapshot]
    ^-  (map path diff)
    %-  ~(urn by (~(uni by old) new))
    |=  [=path *]
    ^-  diff
    =/  a=file
      ?~(got=(~(get by old) path) *file u.got)
    =/  b=file
      ?~(got=(~(get by new) path) *file u.got)
    (lusk:differ a b (loss:differ a b))
  ::
  ++  get-version
    |=  [=file-name v=index]
    ^-  cord
    ?>  (lte v head) :: TODO error handling
    %-  of-wain:format
    ?~  got=(~(get by (get-snap v)) file-name)
      ~
    u.got
  ::
  ++  get-latest
    |=  =file-name
    ^-  cord
    %-  of-wain:format
    (~(got by latest-snap) file-name)
  ::
  ++  get-diff
    |=  [=file-name v1=index v2=index]
    ^-  diff
    =/  old=wain  (~(got by (get-snap v1)) file-name)
    =/  new=wain  (~(got by (get-snap v2)) file-name)
    (lusk:differ old new (loss:differ old new))
  ::
  ++  get-snap       |=(=index snapshot:(got:snap-on snaps index))
  ++  get-commit     |=(=index (got:snap-on snaps index))
  ++  latest-snap    snapshot:(got:snap-on snaps head)
  ++  latest-commit  (got:snap-on snaps head)
  --
--

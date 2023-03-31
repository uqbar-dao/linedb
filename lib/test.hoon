/-  *linedb
/+  ldb=linedb
|%
++  wain-1
  :~  'line1'
  ==
++  wain-2
  :~  'line1'
      'line2'
  ==
++  wain-3
  :~  'line1'
      'line2'
      'line3'
  ==
++  wain-4
  :~  'line1'
      'line2'
      'line3'
      'line4'
  ==
++  snap-1  (~(gas by *snapshot) [/f wain-1]~)
++  snap-2  (~(gas by *snapshot) [/f wain-2]~)
++  snap-3  (~(gas by *snapshot) [/f wain-3]~)
++  snap-4  (~(gas by *snapshot) [/f wain-4]~)
++  test
  =|  =branch
  =.  branch  (~(add-commit b:ldb branch) *@p *@da snap-1)
  =/  hash-1  head.branch
  =.  branch  (~(add-commit b:ldb branch) *@p *@da snap-2)
  =.  branch  (~(add-commit b:ldb branch) *@p *@da snap-3)
  =.  branch  (~(add-commit b:ldb branch) *@p *@da snap-4)
  =/  hash-2  head.branch
  ~&  >  hash-1
  ~&  >  hash-2
  ~&  >  ~(log b:ldb branch)
  ~&  >  ~(par b:ldb branch)
  :: ~&  >  ~(head-diffs b:ldb branch)
  =.  branch  (~(squash b:ldb branch) hash-1 hash-2)
  ~&  >>  ~(log b:ldb branch)
  ~&  >>  ~(par b:ldb branch)
  :: ~&  >>  ~(head-diffs b:ldb branch)
  5
++  asdf
  ~&  >>>  (diff-files:d:ldb wain-1 wain-4)
  5
--
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
++  file-1  (wain-to-file wain-1)
++  file-2  (wain-to-file wain-2)
++  file-3  (wain-to-file wain-3)
++  file-4  (wain-to-file wain-4)
++  test
  (~(add-commit b *branch) *@p *@da 
--
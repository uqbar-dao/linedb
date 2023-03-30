/-  *linedb
/+  ldb=linedb
|%
++  wain-1
  :~  'line1'
      'line2'
      'line3'
      'line4'
      'line5'
  ==
++  wain-2
  :~  'line 1'
      'line2'
      'line 3'
      'line4'
      'line 5'
  ==
++  file-1  (wain-to-file wain-1)
++  file-2  (wain-to-file wain-2)
++  
--
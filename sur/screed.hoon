/-  *linedb
|%
+$  action
  $%  [%publish =file-name html=@t]
      [%commit-file =path md=wain]
      [%comment =file-name =line =comment]
      [%change-permissions =file-name =ship =permission]
  ==
+$  permission
  $~(%none ?(%none %read %comment %edit))
+$  comment
  $:  author=@p
      sig=* :: TODO
      timestamp=@da
      content=@t
  ==
++  comment-on  ((on line comment) lth)
--
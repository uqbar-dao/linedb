/-  *linedb
|%
+$  action
  $%  [%publish =file-name html=@t]
      [%commit-file =path md=wain]
      [%comment =file-name =line =comment]
      [%change-permissions =file-name =ship =permission]
  ==
:: +$  file-permission
::   $~(%none ?(%none %all %selected)) :: TODO social graph integration
:: +$  user-permission
::   $~(%none ?(%none %read %comment %edit))
+$  comment
  $:  author=@p
      sig=* :: TODO
      timestamp=@da
      content=@t
  ==
++  comment-on  ((on line comment) lth)
--
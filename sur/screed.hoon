/-  *linedb
|%
+$  metadata
  $:  title=@t
      published=@da
      comments=((mop line comment) lth) :: TODO not sure if this needs to be a mop
      :: permissions
  ==
::
+$  action
  $%  [%save-file =path title=@t md=wain] :: should commit and edit metadata
      [%comment =path =line content=@t]
  ==
+$  comment
  $:  author=@p
      timestamp=@da
      content=@t
      :: sig=* :: TODO
  ==
++  comment-on  ((on line comment) lth)
--
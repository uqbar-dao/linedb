/-  *linedb
|%
+$  post
  $:  title=@t
      md=wain
      comments=((mop line comment) lth)
  ==
::
+$  action
  $%  [%publish =path html=@t]
      [%commit-file =path md=wain]
      [%comment =path =line =comment]
  ==
+$  comment
  $:  author=@p
      sig=* :: TODO
      timestamp=@da
      content=@t
  ==
++  comment-on  ((on line comment) lth)
--
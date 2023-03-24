|%
+$  action
  $%  [%publish =path html=@t]
      [%commit-file =path md=wain]
      [%comment =path line=@ud =comment]
  ==
+$  comment
  $:  author=@p
      sig=* :: TODO
      timestamp=@da
      content=@t
  ==
--